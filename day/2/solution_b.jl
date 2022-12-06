# Define a dictionary that maps hand shapes to scores
shape_scores = Dict(:Rock => 1, :Paper => 2, :Scissors => 3)

# Define a dictionary that maps round outcome to scores
outcome_scores = Dict(:Win => 6, :Draw => :3, :Lose => 0)

# Decode opponent
opponent_codes = Dict('A' => :Rock, 'B' => :Paper, 'C' => :Scissors)

# Decode player
player_codes = Dict('X' => :Lose, 'Y' => :Draw, 'Z' => :Win)

# Winning shapes
shape_winners = Dict(:Rock => :Paper, :Scissors => :Rock, :Paper => :Scissors)

# Losing shapes
shape_losers = Dict(:Rock => :Scissors, :Scissors => :Paper, :Paper => :Rock)

# Strategy actions
shape_strategy = Dict(
    :Lose => shape -> shape_losers[shape],
    :Win => shape -> shape_winners[shape],
    :Draw => shape -> shape
)

# Define a function to calculate the score for a single round
function score_round(player_code, opponent_code)
    # Decode the strategy
    player_outcome = player_codes[player_code]
    opponent_shape = opponent_codes[opponent_code]

    # Evaluate the strategy
    player_shape = shape_strategy[player_outcome](opponent_shape)

    # Score is outcome + shape
    score = shape_scores[player_shape] + outcome_scores[player_outcome]
    println((opponent_code, player_code, player_outcome, opponent_shape, player_shape, score))
    return score
end

# Read the strategy guide from the input file
strategy_guide_lines = readlines("input.txt")

#println(strategy_guide_lines)

# Define the strategy guide as an array of tuples
strategy_guide = [first(zip(split(line, " ")...)) for line in strategy_guide_lines]

# Use a reducing operation to calculate the total score
total_score = reduce(+, [score_round(player_code, opponent_code) for (opponent_code, player_code) in strategy_guide])

# Print the total score
println(total_score)