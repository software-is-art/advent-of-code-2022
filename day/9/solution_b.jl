using LinearAlgebra

const Point = Tuple{Int, Int}
const Head = Vector{Int}
const Tail = Vector{Int}
const Move = Vector{Int}
const Knots = Vector{Vector{Int}}

function parseMove(line::String)
    (direction, distance) = split(line, " ")
    if direction == "U"
        return [0, parse(Int, distance)]
    elseif direction == "D"
        return [0, parse(Int, distance) * -1]
    elseif direction == "L"
        return [parse(Int, distance) * -1, 0]
    elseif direction == "R"
        return [parse(Int, distance), 0]
    end
end

function angle(a, b)
    return clamp(dot(a, b)/(norm(a)*norm(b)), -1, 1)
end

function recordTailVisit(::Nothing, ::Tail) end
function recordTailVisit(sites::Set{Point}, tail::Tail)
    push!(sites, (tail[1], tail[2]))
end

function unitVector(vector)
    return map(x -> if x != 0 Int(x / abs(x)) else x end, vector)
end

function moveTail(head::Head, tail::Tail)
    delta = head - tail
    distance = Int(norm(delta, 1)) # Manhattan distance
    if distance >= 3
        return tail .+ unitVector(delta)
    end
    if distance < 2
        return tail
    end
    # If angle is in [0, 90, 180, 270] degrees a is in [0, 1, 0, -1]
    a = angle(delta, [0, 1])
    if a == 0 || a == 1 || a == -1
        return tail .+ unitVector(delta)
    end
    return tail
end

function moveLinkAndTail(knots::Knots, link::Int, sites::Union{Set{Point}, Nothing})
    tail = link + 1
    knots[tail] = moveTail(knots[link], knots[tail])
    recordTailVisit(sites, knots[tail])
end

function step(move::Move, knots::Knots, sites::Set{Point})
    head = 1
    knotCount = length(knots)
    unitMove = unitVector(move)
    while move != [0, 0]
        knots[head] .= knots[head] + unitMove
        for link in 1:knotCount - 2
            moveLinkAndTail(knots, link, nothing)
        end
        moveLinkAndTail(knots, knotCount - 1, sites)
        move .= move - unitMove
    end
end

function calculate(lines::Vector{String})
    knots = collect([[0, 0] for _ in 1:10])
    tailSites = Set{Tuple{Int, Int}}()
    for line in lines
        move = parseMove(line)
        step(move, knots, tailSites)
    end
    return length(tailSites)
end

input = readlines("day/9/input.txt")
positions = calculate(input)
println(positions)
