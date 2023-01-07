const Point = Tuple{Int, Int}

abstract type Tile end
struct Air <: Tile end
struct Rock <: Tile end
struct SandFalling <: Tile end
struct SandAtRest <: Tile end

abstract type Result end
struct Done <: Result end
struct OutOfBounds <: Result end
struct Continue <: Result
    point::Point
end

function step(point::Point, delta::Point)
    (x, y) = point
    (dx, dy) = delta
    if dy != 0
        s = div(dy, abs(dy))
        (x, y) = (x, y + s)
        (dx, dy) = (dx, dy - s)
    end
    if dx != 0
        s = div(dx, abs(dx))
        (x, y) = (x + s, y)
        (dx, dy) = (dx - s, dy)
    end
    return ((x, y), (dx, dy))
end

function readInput(filename)
    tiles = Dict{Point, Tile}()
    for trace in readlines(filename)
        previous = nothing
        for span in split(trace, " -> ")
            point = eval(Meta.parse(string("($span)")))
            if previous !== nothing
                delta = (previous[1] - point[1], previous[2] - point[2])
                tiles[point] = Rock()
                current = point
                while delta != (0, 0)
                    (current, delta) = step(current, delta)
                    tiles[current] = Rock()
                end
            end
            previous = point
        end
    end
    return tiles
end

function getTile(slice::Dict{Point, Tile}, point::Point)
    if haskey(slice, point)
        return slice[point]
    end
    return Air()
end

function xRange(slice::Dict{Point, Tile})
    maxX = typemin(Int)
    minX = typemax(Int)
    for ((next, _), _) in slice
        if next > maxX
            maxX = next
        end
        if next < minX
            minX = next
        end
    end
    return (minX, maxX)
end

function yRange(slice::Dict{Point, Tile})
    y = typemin(Int)
    for ((_, next), _) in slice
        if next > y
            y = next
        end
    end
    return (0, y)
end

function blocked(::Air)
    return false
end
function blocked(next)
    return true
end

function checkBounds(point::Point, xBounds::Point, yBounds::Point)
    (x, y) = point
    (xMin, xMax) = xBounds
    (yMin, yMax) = yBounds
    if xMin <= x <= xMax && yMin <= y <= yMax
        return Continue(point)
    end
    return OutOfBounds()
end

function trickle(slice::Dict{Point, Tile}, previous::Continue, xBounds::Point, yBounds::Point)
    (x, y) = previous.point
    if blocked(getTile(slice, previous.point))
        return OutOfBounds()
    end
    nextPoint = (x, y + 1)
    nextTile = getTile(slice, nextPoint)
    if (!blocked(nextTile))
        return checkBounds(nextPoint, xBounds, yBounds)
    end
    nextPoint = (x - 1, y + 1)
    nextTile = getTile(slice, nextPoint)
    if !blocked(nextTile)
        return checkBounds(nextPoint, xBounds, yBounds)
    end
    nextPoint = (x + 1, y + 1)
    nextTile = getTile(slice, nextPoint)
    if !blocked(nextTile)
        return checkBounds(nextPoint, xBounds, yBounds)
    end
    slice[previous.point] = SandAtRest()
    return Done()
end

function trickleSand(slice::Dict{Point, Tile})
    source = (500, 0)
    trickling = true
    yBounds = yRange(slice)
    xBounds = xRange(slice)
    while trickling
        current = Continue(source)
        while current !== Done() && (trickling = current !== OutOfBounds())
            current = trickle(slice, current, xBounds, yBounds)
        end
    end
    return slice
end

function countSand(slice::Dict{Point, Tile})
    return count(kvp -> kvp[2] === SandAtRest(), slice)
end

slice = trickleSand(readInput("day/14/input.txt"))
println(slice)
sandCount = countSand(slice)
println(sandCount)