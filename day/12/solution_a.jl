using Test

abstract type Direction end
struct Left <: Direction end
struct Right <: Direction end
struct Up <: Direction end
struct Down <: Direction end
const directions = [Left(), Right(), Up(), Down()]
struct Point
    x::UInt8
    y::UInt8
end

function Point(x::Int64, y::Int64, bounds::Matrix{Int})
    if !checkbounds(Bool, bounds, x, y)
        return nothing
    end
    return Point(convert(UInt8, x), convert(UInt8, y))
end

function Point(x::UInt8, y::UInt8, bounds::Matrix{Int})
    return Point(Int64(x), Int64(y), bounds)
end

function Point(tuple::Tuple{Int64, Int64}, bounds::Matrix{Int})
    (x, y) = tuple
    return Point(x, y, bounds)
end

struct Path
    head::Point
    parent::Union{Path, Nothing}
end

function Path(head::Point)
    return Path(head, nothing)
end

function Base.iterate(path::Path)
    return (path.head, path.parent)
end

function Base.iterate(::Path, next::Path)
    return (next.head, next.parent)
end

function Base.iterate(::Path, next::Nothing)
    return next
end

Base.IteratorSize(::Path) = Base.SizeUnknown()

function pathLength(path::Path)
    return reduce(+, [1 for _ in path])
end

function head(path::Path)
    return path.head
end

struct Paths
    map::Matrix{Int}
    start::Point
    dest::Point
    forwards::Set{Path}
    forwardsPoints::Set{Point}
    backwards::Set{Path}
    backwardsPoints::Set{Point}
end

function Paths(paths::Paths, forwards::Set{Path}, backwards::Set{Path})
    return Paths(paths.map, paths.start, paths.dest, forwards, paths.forwardsPoints, backwards, paths.backwardsPoints)
end

function Paths(map::Matrix{Int}, start::Point, dest::Point)
    forwards = Set{Path}()
    backwards = Set{Path}()
    push!(forwards, Path(start))
    push!(backwards, Path(dest))
    return Paths(map, start, dest, forwards, Set([start]), backwards, Set([dest]))
end

function readMap(filename)
    map = Vector{Int}()
    start = (0, 0)
    dest  = (0, 0)
    dimensions = (0, 0)
    for (x, line) in enumerate(readlines(filename))
        for (y, c) in enumerate(line)
            if c == 'S'
                start = (x, y)
                c = 'a'
            end
            if c == 'E'
                dest = (x, y)
                c = 'z'
            end
            push!(map, c - 'a')
            dimensions = (x, y)
        end
    end
    (x, y) = dimensions
    reshaped = reshape(map, y, x)
    matrix = permutedims(reshaped)
    return (matrix, Point(start, matrix), Point(dest, matrix))
end

function coordinates(point::Point, bounds::Matrix{Int})
    return coordinate(point.index, bounds)
end

function move(direction::Up, point::Point, bounds::Matrix{Int})
    return Point(point.x, point.y - UInt8(1), bounds)
end

function move(direction::Down, point::Point, bounds::Matrix{Int})
    return Point(point.x, point.y + UInt8(1), bounds)
end

function move(direction::Left, point::Point, bounds::Matrix{Int})
    return Point(point.x - UInt8(1), point.y, bounds)
end

function move(direction::Right, point::Point, bounds::Matrix{Int})
    return Point(point.x + UInt8(1), point.y, bounds)
end

function push(items::Vector{Point}, item::Point)
    new = copy(items)
    push!(new, item)
    return new
end

function fork(parent::Path, map::Matrix{Int}, next::Set{Path}, points::Set{Point})
    for dir in directions
        h = head(parent)
        target = move(dir, h, map)
        if target === nothing
            continue
        end
        gradient = abs(map[target.x, target.y] - map[h.x, h.y])
        if 0 <= gradient <= 1 && !in(target, parent)
            push!(next, Path(target, parent))
            push!(points, target)
        end
    end
end

function traverse(paths::Set{Path}, map::Matrix{Int}, points::Set{Point})
    next = Set{Path}()
    for path in paths
        fork(path, map, next, points)
    end
    return next
end

function converge(paths::Paths)
    for forward in paths.forwards
        for backward in paths.backwards
            if head(forward) == head(backward)
                return pathLength(forward) + pathLength(backward) - 2
            end
        end
    end
    return nothing
end

function traverseForwards(paths::Paths)
    return Paths(
        paths,
        traverse(paths.forwards, paths.map, paths.forwardsPoints),
        paths.backwards
    )
end

function traverseBackwards(paths::Paths)
    return Paths(
        paths,
        paths.forwards,
        traverse(paths.backwards, paths.map, paths.backwardsPoints),
    )
end

function traverse(paths::Paths)
    while true 
        if length(paths.forwards) < length(paths.backwards)
            paths = traverseForwards(paths)
        else
            paths = traverseBackwards(paths)
        end
        println((length(paths.forwards), length(paths.backwards)))
        if length(intersect(paths.forwardsPoints, paths.backwardsPoints)) > 0
            println("Checking convergence")
            converged = converge(paths)
            if (converged !== nothing)
                return converged
            end
        end
    end
end

(map, start, dest) = readMap("day/12/input.txt")
shortest = traverse(Paths(map, start, dest))
println(shortest)