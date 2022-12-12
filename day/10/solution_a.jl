struct Registers
    x::Int
end

struct Noop end
struct Addx end

const opLookup = Dict("noop" => Noop(), "addx" => Addx())

function parseArgs(::Noop, args::Vector{SubString{String}})
    return []
end

function execute(::Noop, cycles::Vector{Registers})
    push!(cycles, cycles[end])
end

function parseArgs(::Addx, args::Vector{SubString{String}})
    return parse(Int, args[1])
end

function execute(::Addx, cycles::Vector{Registers}, operand::Int)
    registers = cycles[end]
    push!(cycles, registers)
    push!(cycles, Registers(registers.x + operand))
end


function processor(instructions::Vector{String})
    registers = Registers(1)
    cycles = [registers]
    for instruction in [split(x, " ") for x in instructions]
        op = opLookup[instruction[1]]
        args = parseArgs(op, instruction[2:end])
        execute(op, cycles, args...)
    end
    return cycles
end

function sumSignalStrength(registers::Vector{Registers}, cycles::Vector{Int})
    return reduce(+, [registers[c].x * c for c in cycles])
end

registerStates = processor(readlines("day/10/input.txt"))
println(sumSignalStrength(registerStates, [20, 60, 100, 140, 180, 220]))