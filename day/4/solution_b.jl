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


# Check if one range partially overlaps another range
function is_partially_overlapping(range1::Tuple, range2::Tuple)
    # Check if range1 partially overlaps range2
    if range1[1] <= range2[1] && range1[2] >= range2[1]
        return true
    end

    # Check if range2 partially overlaps range1
    if range2[1] <= range1[1] && range2[2] >= range1[1]
        return true
    end

    # If neither range partially overlaps the other, return false
    return false
end

# Count the number of pairs of ranges where one range partially overlaps the other
# within each assignment row
function count_partially_overlapping(ranges::Array)
    count = 0
    for i in 1:2:length(ranges)
        if is_partially_overlapping(ranges[i], ranges[i+1])
            count += 1
        end
    end
    return count
end

# Solve the puzzle
function solve(input::Vector{String})
    ranges = parse_input(input)
    return count_partially_overlapping(ranges)
end

# Check if a path to the input file was provided as an argument
if length(ARGS) < 1
    println("Usage: julia script.jl /path/to/input.txt")
    return
  end
  
# Read the lines of the input file into an array of strings
path = ARGS[1]
lines = readlines(path)

# Pass the array of strings to the num_fully_contained_pairs function
println(solve(lines))
