function readInput(filename::String)
    packets = []
    for line in readlines(filename)
        if length(line) == 0
            continue
        end
        push!(packets, eval(Meta.parse(line)))
    end
    push!(packets, [[2]])
    push!(packets, [[6]])
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
    sort!(packets, lt=compare)
end

function decoderKey(packets)
    key = 1
    for (index, packet) in enumerate(packets)
        if (packet == [[6]] || packet == [[2]])
            key = key * index
        end
    end
    return key
end

packets = readInput("day/13/input.txt")
process(packets)
println(decoderKey(packets))