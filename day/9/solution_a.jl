using LinearAlgebra

const Point = Tuple{Int, Int}
const Head = Vector{Int}
const Tail = Vector{Int}
const Move = Vector{Int}

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

function step(move::Move, head::Head, tail::Tail, sites::Set{Point})
    unitMove = unitVector(move)
    while move != [0, 0]
        move .= move - unitMove
        head .= head + unitMove
        tail = moveTail(head, tail)
        recordTailVisit(sites, tail)
    end
    return (head, tail)
end

function calculate(lines::Vector{String})
    head = [0, 0]
    tail = [0, 0]
    tailSites = Set{Tuple{Int, Int}}()
    recordTailVisit(tailSites, tail)
    for line in lines
        move = parseMove(line)
        (head, tail) = step(move, head, tail, tailSites)
    end
    return length(tailSites)
end

input = readlines("day/9/input.txt")
positions = calculate(input)
println(positions)
