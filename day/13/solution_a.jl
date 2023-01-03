function collect(pair::Nothing, left, packets)
    return left
end

function collect(left, right, packets)
    push!(packets, (left, right))
    return nothing
end

function readInput(filename::String)
    packets = []
    pair = nothing
    for line in readlines(filename)
        if length(line) == 0
            continue
        end
        pair = collect(pair, eval(Meta.parse(line)), packets)
    end
    return packets
end

function zip(left, right)
    l = iterate(left)
    r = iterate(right)
    pairs = []
    while l !== nothing && r !== nothing
        push!(pairs, (l[1], r[1]))
        l = iterate(left, l[2])
        r = iterate(right, r[2])
    end
    if l === nothing && r !== nothing
        push!(pairs, (nothing, r[1]))
    elseif l !== nothing && r === nothing
        push!(pairs, (l[1], nothing))
    elseif length(pairs) == 0
        push!(pairs, (nothing, nothing))
    end
    return pairs
end

function compare(left::Int, right::Int)
    if left < right
        return true
    end
    if right < left
        return false
    end
    return nothing
end

function compare(left::Vector{Any}, right::Int)
    return compare(left, [right])
end

function compare(left::Int, right::Vector{Any})
    return compare([left], right)
end

function compare(left::Nothing, right)
    return true
end

function compare(left, right::Nothing)
    return false
end

function compare(left::Nothing, right::Nothing)
    return nothing
end

function compare(left, right)
    for (l, r) in zip(left, right)
        comparison = compare(l, r)
        if comparison === nothing
            continue
        end
        return comparison
    end
end

function process(packets)
    return [compare(left, right) for (left, right) in packets]
end

function sumIndices(ordering::Vector{Bool})
    sum = 0
    for (i, ordered) in enumerate(ordering)
        if ordered
            sum += i
        end
    end
    return sum
end

packets = readInput("day/13/input.txt")
ordered = process(packets)
println(sumIndices(ordered))