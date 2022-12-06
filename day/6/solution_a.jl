function findPacketStart(message::String)
    packet_length = 4
    offset = packet_length - 1;
    for i in range(1, length(message) - packet_length)
        raw_packet = message[i:i + offset]
        header_packet = Set(raw_packet)
        if length(header_packet) == packet_length
            return i + offset
        end
    end
    return length(message) 
end

println(findPacketStart(read("input.txt", String)))