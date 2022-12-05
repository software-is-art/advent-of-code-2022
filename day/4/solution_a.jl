# Parse the input and create a list of ranges
function parse_input(input::Vector{String})
    ranges = []
    for line in input
        parts = split(line, ",") # split on commas
        for part in parts
            range_parts = split(part, "-") # split the range on dashes
            push!(ranges, (parse(Int, range_parts[1]), parse(Int, range_parts[2])))
        end
    end
    return ranges
end


# Check if one range fully contains another range
function is_fully_contained(range1::Tuple, range2::Tuple)
    #println(range1)
   # println(range2)
    # Check if range1 fully contains range2
    if range1[1] <= range2[1] && range1[2] >= range2[2]
        return true
    end

    # Check if range2 fully contains range1
    if range2[1] <= range1[1] && range2[2] >= range1[2]
        return true
    end

    # If neither range fully contains the other, return false
    return false
end

# Count the number of pairs of ranges where one range fully contains the other
# within each assignment row
function count_fully_contained(ranges::Array)
    count = 0
    for i in 1:2:length(ranges)
        if is_fully_contained(ranges[i], ranges[i+1])
            count += 1
        end
    end
    return count
end

# Solve the puzzle
function solve(input::Vector{String})
    ranges = parse_input(input)
    return count_fully_contained(ranges)
end

# Read the input
lines = readlines("input.txt")

# Pass the array of strings to the num_fully_contained_pairs function
println(solve(lines))
