function findPacketStart(message::String, packetLength::Int)
    offset = packetLength - 1
    for i in range(1, length(message) - packetLength)
        raw_packet = message[i:i + offset]
        header_packet = Set(raw_packet)
        if length(header_packet) == packetLength
            return i + offset
        end
    end
    return length(message) 
end

println(findPacketStart(read("input.txt", String), 14))