
# Define a dictionary that maps hand shapes to scores
hand_shapes = Dict(:Rock => 1, :Paper => 2, :Scissors => 3)

# Decode opponent
opponent_codes = Dict('A' => :Rock, 'B' => :Paper, 'C' => :Scissors)

# Decode player
player_codes = Dict('X' => :Rock, 'Y' => :Paper, 'Z' => :Scissors)

# Define a function to calculate the score for a single round
function round_outcome(player_shape, opponent_shape)
    # If both shapes are the same, the round is a draw
    if player_shape == opponent_shape
        return 3
    end

    # If the player's shape defeats the opponent's shape, they win
    if (player_shape == :Rock && opponent_shape == :Scissors) ||
       (player_shape == :Paper && opponent_shape == :Rock) ||
       (player_shape == :Scissors && opponent_shape == :Paper)
        return 6
    end

    # Otherwise, the player loses
    return 0
end

# Calculates the total score for a round
function score_round(player_code, opponent_code)
    # Decode the shapes
    player_shape = player_codes[player_code]
    opponent_shape = opponent_codes[opponent_code]

    # Get the round outcome score
    outcome_score = round_outcome(player_shape, opponent_shape)
    shape_score = hand_shapes[player_shape]
    return outcome_score + shape_score
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