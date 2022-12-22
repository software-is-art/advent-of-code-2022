using Test

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
    return shift(input, 100, 0, abs(left.val))
end

function shift(input::AbstractMatrix, left::Down)
    return shift(input, 100, 0, abs(left.val) * -1)
end

testMat = Matrix([1 2 ; 3 4])
@test shift(testMat, Right(1)) == Matrix([100 1; 100 3])
@test shift(testMat, Left(1)) == Matrix([2 100; 4 100])
@test shift(testMat, Up(1)) == Matrix([3 4; 100 100])
@test shift(testMat, Down(1)) == Matrix([100 100; 1 2])

(map, start, dest, dimensions) = readMap("day/12/input.txt")
matrix = permutedims(reshape(map, dimensions))
leftGrad = shift(matrix, Right(1)) - matrix
rightGrad = shift(matrix, Left(1)) - matrix
downGrad = shift(matrix, Up(1)) - matrix
upGrad = shift(matrix, Down(1)) - matrix

println(start)
println(matrix[21, 1])