function bitsetComparison(packet::SubString, packetLength::Int)
    bitset = 0
    offset = Int64('a')
    for c in packet
        bitset |= 1 << (Int64(c) - offset) 
    end
    return count_ones(bitset) == packetLength
end

function findPacketStart(message::String, packetLength::Int)
    offset = packetLength - 1
    for i in range(1, length(message) - packetLength)
        raw_packet = SubString(message, i, i + offset)
        if bitsetComparison(raw_packet, packetLength)
            return i + offset
        end
    end
    return length(message) 
end

input = read("input.txt", String)
@time resut = findPacketStart(input, 14)
@time resut = findPacketStart(input, 14)
println(resut)