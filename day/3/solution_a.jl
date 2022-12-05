function solve(input::AbstractVector)
    # Calculate the sum of the priorities of the common items
    sum = 0
    for rucksack in input
        # Split the rucksack into its two compartments
        first_compartment = rucksack[1:length(rucksack) ÷ 2]
        second_compartment = rucksack[length(rucksack) ÷ 2 + 1:end]

        # Find the common items by taking the intersection of the two compartments
        common_items = intersect(first_compartment, second_compartment)

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
