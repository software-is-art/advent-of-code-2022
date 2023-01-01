abstract type Direction end
struct Left <: Direction end
struct Right <: Direction end
struct Up <: Direction end
struct Down <: Direction end
const directions = [Left(), Right(), Up(), Down()]
struct Point
    x::Int
    y::Int
end

function Point(x::Int, y::Int, bounds::Matrix{Int})
    if !checkbounds(Bool, bounds, x, y)
        return nothing
    end
    return Point(x, y)
end

function Point(tuple::Tuple{Int, Int}, bounds::Matrix{Int})
    (x, y) = tuple
    return Point(x, y, bounds)
end

struct Graph
    map::Matrix{Int}
    start::Point
    dest::Point
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
    return Graph(matrix, Point(start, matrix), Point(dest, matrix))
end

function coordinates(point::Point, bounds::Matrix{Int})
    return coordinate(point.index, bounds)
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
    return Point(point.x + 1, point.y, bounds)
end

function visitNeighbours(current::Point, weight::Int, unvisited::Dict{Point, Int}, visited::Dict{Point, Int}, map::Matrix{Int})
    for dir in directions
        next = move(dir, current, map)
        if next === nothing
            continue
        end
        gradient = map[next.x, next.y] - map[current.x, current.y]
        if (gradient < 0 || 0 <= gradient <= 1) && haskey(unvisited, next)
            unvisited[next] = min(unvisited[next], weight + 1)
        end
    end
    delete!(unvisited, current)
    visited[current] = weight
end

function traverse(graph::Graph)
    (xDim, yDim) = size(graph.map)
    unvisited = Dict{Point, Int}([(Point(x, y), typemax(Int)) for x in 1:xDim for y in 1:yDim])
    visited = Dict{Point, Int}()
    unvisited[graph.start] = 0
    (weight, current) = findmin(unvisited)
    while weight < typemax(Int)
        visitNeighbours(current, weight, unvisited, visited, graph.map)
        (weight, current) = findmin(unvisited)
    end
    return visited[graph.dest]
end

graph = readMap("day/12/input.txt")
distance = traverse(graph)
println(distance)