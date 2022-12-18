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


(map, start, dest, dimensions) = readMap("day/12/input.txt")
matrix = reshape(map, dimensions)
println(matrix)
