using ParserCombinator

struct Monkey{T}
end

function parseItems(items::String)
    return [Int(a) for a in Meta.parse(items).args]
end

macro monkey(id::Int, startingItems)
    @eval begin
        function setItems(::Monkey{$id}, items::Vector{Vector{Int}})
            insert!(items, $id, $startingItems)
        end
        function items(::Monkey{$id}, items::Vector{Vector{Int}})
            return items[$id]
        end
    end
end

monkey = Delayed()
spc = P"[ \n\t]*"
val = PInt64()
separator = spc + E":" + spc
id = spc + E"Monkey" + spc + val + separator
startItems = spc + E"Starting items" + separator + (val + P"[ ,]*")[0:end] + spc
op = spc + E"Operation" + separator + E"new" + spc  + E"=" + spc + p"[a-z*+\/ 0-9]+" + spc
test = spc + E"Test" + separator + E"divisible" + spc + E"by" + spc + val + spc
iff = spc + E"If" + spc
throwTo = separator + E"throw" + spc + E"to" + spc + E"monkey" + spc + val
testTrue = iff + E"true" + throwTo
testFalse = iff + E"false" + throwTo
monkey.matcher = id + (startItems | op | test | testTrue | testFalse)[0:end]
monkeys = monkey[0:end]

a = parse_one(read("day/11/input.txt", String), monkeys)
println(a)

