using ParserCombinator

abstract type Node end
struct Point <: Node
    x::Int
    y::Int
end
struct Pair <: Node
    sensor::Point
    beacon::Point
end

pair = Delayed()
spc = P"[ \n\t]*"
val = PInt64()
x = E"x=" + val
y = E"y=" + val
separator = spc + (E":" | E",") + spc
point = x + separator + y > Point
pair.matcher = E"Sensor at " + point + separator + E"closest beacon is at " + point + spc > Pair
pairs = pair[0:end]

function parseAst(fileName::String)
    return parse_one(read(fileName, String), pairs)
end

println(parseAst("day/15/small.txt"))