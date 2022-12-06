# Read all the ruck sacks
raw_input = read("input.txt", String)

# Rucksacks per elf
rucksacks = [split(x, "\n") for x in raw_input]

println(rucksacks)