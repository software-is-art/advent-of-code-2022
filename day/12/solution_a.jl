function readMap(filename)
    map = Vector{Int}()
    start = 0
    dest  = 0
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
    return (map, start, dest, dimensions)
end

abstract type Direction end
struct Left <: Direction val::Int end
struct Right <: Direction val::Int end
struct Up <: Direction val::Int end
struct Down <: Direction val::Int end

function shift(input::AbstractMatrix, fillVal::Int, x::Int, y::Int)
    m, n = size(input)
    result = input
    if x != 0
        column = fill(fillVal, m, abs(x))
        result = (x > 0 ? [column result[:, 1:(n - x)]] : [result[:, (abs(x) + 1):n] column])
    end
    if y != 0
        column = fill(fillVal, abs(y), n)
        result = (y > 0 ? [result[(y + 1):m, :]; column] : [column; result[1:(m - abs(y)), :]])
    end
    return result
end

function shift(input::AbstractMatrix, left::Left)
    return shift(input, 100, abs(left.val) * -1, 0)
end

function shift(input::AbstractMatrix, left::Right)
    return shift(input, 100, abs(left.val), 0)
end

function shift(input::AbstractMatrix, left::Up)
    return shift(input, 100, 0, abs(left.val) * -1)
end

function shift(input::AbstractMatrix, left::Down)
    return shift(input, 100, 0, abs(left.val))
end

(map, start, dest, dimensions) = readMap("day/12/input.txt")
matrix = reshape(map, dimensions)
right = shift(matrix, Right(1))
grad = right - matrix
println(grad)
