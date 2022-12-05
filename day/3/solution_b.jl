function solve(input::AbstractVector)
    # Calculate the sum of the priorities of the common items
    sum = 0
    for i in 1:length(input) ÷ 3
        # Get the rucksacks for the current group
        group_rucksacks = input[i * 3 - 2:i * 3]

        # Calculate the intersection of the items in each rucksack
        common_items = intersect(group_rucksacks[1], group_rucksacks[2])
        common_items = intersect(common_items, group_rucksacks[3])

        # Add the priorities of the common items to the sum
        for item in common_items
            # For lowercase items, the priority is the ASCII value of the character minus 96
            if item >= 'a' && item <= 'z'
                sum += Int(item) - 96
            # For uppercase items, the priority is the ASCII value of the character minus 38
            elseif item >= 'A' && item <= 'Z'
                sum += Int(item) - 38
            end
        end
    end

    return sum
end

# Read the input
lines = readlines("input.txt")

# Pass the array of strings to the num_fully_contained_pairs function
println(solve(lines))
