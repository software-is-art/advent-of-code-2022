using LinearAlgebra

struct Up
    distance::Int
end
struct Down
    distance::Int
end
struct Left
    distance::Int
end
struct Right
    distance::Int
end
const Move = Union{Up, Down, Left, Right}
const Point = Tuple{Int, Int}
const Head = Vector{Int}
const Tail = Vector{Int}

function parseMove(line::String)
    (direction, distance) = split(line, " ")
    if direction == "U"
        return Up(parse(Int, distance))
    elseif direction == "D"
        return Down(parse(Int, distance))
    elseif direction == "L"
        return Left(parse(Int, distance))
    elseif direction == "R"
        return Right(parse(Int, distance))
    end
end

function angle(a, b)
    return acosd(clamp(a⋅b/(norm(a)*norm(b)), -1, 1))
end

function recordTailVisit(sites::Set{Point}, tail::Tail)
    push!(sites, (tail[1], tail[2]))
end

function moveTail(head::Head, tail::Tail, direction::Vector{Int}, sites::Set{Point})
    delta = head - tail
    a = angle(delta, direction)
    d = norm(delta, 1)
    if (a == 0 && d == 2)
        tail.
    end
    println(delta, a)
end
function step(up::Up, head::Head, tail::Tail, sites::Set{Point})
    distance = up.distance
    while distance > 0
        head[2] += 1
        moveTail(head, tail, [0, 1], sites)
        distance -= 1
    end
end

function step(down::Down, head::Head, tail::Tail, sites::Set{Point})
    distance = down.distance
    while distance > 0
        head[2] -= 1
        moveTail(head, tail, [0, -1], sites)
        distance -= 1
    end
end

function step(left::Left, head::Head, tail::Tail, sites::Set{Point})
    distance = left.distance
    while distance > 0
        head[1] -= 1
        moveTail(head, tail, [-1, 0], sites)
        distance -= 1
    end
end

function step(right::Right, head::Head, tail::Tail, sites::Set{Point})
    distance = right.distance
    while distance > 0
        head[1] += 1
        moveTail(head, tail, [1, 0], sites)
        distance -= 1
    end
end

function calculate(lines::Vector{String})
    head = [0, 0]
    tail = [0, 0]
    tailSites = Set{Tuple{Int, Int}}()
    recordTailVisit(tailSites, tail)
    for line in lines
        move = parseMove(line)
        step(move, head, tail, tailSites)
    end
end

input = readlines("day/9/input.txt")
head = calculate(input)
println(head)
