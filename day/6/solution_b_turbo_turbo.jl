function uniqueItemCount(bitset::Array{Int32})
    return count_ones(reduce(|, bitset))
end

function charsRead(message::String, packetLength::Int)
    ascii_offset = Int32('a');
    packet = zeros(Int32, packetLength)
    for (i, c) in enumerate(message)
        packet[(i % packetLength) + 1] = 1 << (Int32(c) - ascii_offset)
        if uniqueItemCount(packet) == packetLength
            return i
        end
    end
    return length(message) 
end

input = read("input.txt", String)
@time resut = charsRead(input, 14)
println(resut)