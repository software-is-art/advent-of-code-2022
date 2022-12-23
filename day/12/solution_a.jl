using Test

abstract type Direction end
struct Left <: Direction end
struct Right <: Direction end
struct Up <: Direction end
struct Down <: Direction end
struct Point
    x::Int
    y::Int
    index::Int
end
function Point(x::Int, y::Int, bounds::Matrix{Int})
    return Point(x, y, bitIndex(x, y, bounds))
end
function Point(point::Tuple{Int, Int}, bounds::Matrix{Int})
    (x, y) = point
    return Point(x, y, bounds)
end

struct Path
    head::Point
    inclusion::BitSet
    steps::Int
end

struct Paths
    map::Matrix{Int}
    start::Point
    dest::Point
    forwards::Set{Path}
    backwards::Set{Path}
end

function Paths(map::Matrix{Int}, start::Point, dest::Point)
    forwards = Set{Path}()
    backwards = Set{Path}()
    push!(forwards, Path(start, BitSet(start.index), 0))
    push!(backwards, Path(dest, BitSet(dest.index), 0))
    return Paths(map, start, dest, forwards, backwards)
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
    matrix = permutedims(reshape(map, dimensions))
    return (matrix, Point(start, matrix), Point(dest, matrix), dimensions)
end

function bitIndex(x::Int, y::Int, matrix::Matrix{Int})
    (stride, _) = size(matrix)
    return x + (y * stride)
end

function move(direction::Up, point::Point, bounds::Matrix{Int})
    return Point(point.x, point.y - 1, bounds)
end

function move(direction::Down, point::Point, bounds::Matrix{Int})
    return Point(point.x, point.y + 1, bounds)
end

function move(direction::Left, point::Point, bounds::Matrix{Int})
    return Point(point.x - 1, point.y, bounds)
end

function move(direction::Right, point::Point, bounds::Matrix{Int})
    return Point(point.x + 1, point.y)
end

function fork(path::Path, paths::Paths, next::Set{Path})
    directions = [Left(), Right(), Up(), Down()]
    for dir in directions
        target = move(dir, path.head, paths.map)
        gradient = abs(paths.map[target.x, target.y]- paths.map[path.head.x, path.head.y])
        if 0 <= gradient <= 1 && !in(target.index, path.inclusion)
            push!(next, Path(target, union(path.inclusion, BitSet(target.index)), path.steps + 1))
        end
    end
end
function traverse(paths::Paths)
    nextForwards = Set{Path}()
    for path in paths.forwards
        fork(path, paths, nextForwards)
    end
    return nextForwards
end

(map, start, dest, dimensions) = readMap("day/12/small.txt")
