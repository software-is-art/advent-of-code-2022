pop_many!(x, n) = [pop!(x) for _ in 1:n]
push_many!(x, n) = [push!(x, a) for a in reverse(n)]
reverse_all!(x) = [reverse(a) for a in x]

# Read the steps from the text file
lines = readlines("input.txt")

# Parse the steps from each line using a regular expression
steps = [match(r"move (\d+) from (\d+) to (\d+)", line).captures for line in lines]

# Convert the strings to integers
steps = [(parse(Int, src), parse(Int, dest), parse(Int, num)) for (src, dest, num) in steps]

# Initial stacks of crates
stacks = [
    [:W, :R, :T, :G],
    [:W, :V, :S, :M, :P, :H, :C, :G],
    [:M, :G, :S, :T, :L, :C],
    [:F, :R, :W, :M, :D, :H, :J],
    [:J, :F, :W, :S, :H, :L, :Q, :P],
    [:S, :M, :F, :N, :D, :J, :P],
    [:J, :S, :C, :G, :F, :D, :B, :Z],
    [:B, :T, :R],
    [:C, :L, :W, :N, :H]
]

stacks = reverse_all!(stacks)

# Perform the rearrangement procedure
for (num, src, dest) in steps
    push_many!(stacks[dest], pop_many!(stacks[src], num))
end

# Print the top crate of each stack
for (i, stack) in enumerate(stacks)
    println(stack[length(stack)])
end
