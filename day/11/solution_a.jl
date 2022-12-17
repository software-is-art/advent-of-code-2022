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

abstract type Node end
struct Items <: Node val::Vector{Int} end
struct Id <: Node val end
struct Op <: Node val end
struct Condition <: Node val::Int end
struct ThrowTo <: Node val::Int end
struct True <: Node val::ThrowTo end
struct False <: Node val::ThrowTo end
struct Test <: Node 
    condition::Condition
    branchTrue::True
    branchFalse::False
end
function Test(condition::Condition, branchFalse::False, branchTrue::True)
    return Test(condition, branchTrue, branchFalse)
end
struct MonkeyNode <: Node val::Vector{Node} end

monkey = Delayed()
spc = P"[ \n\t]*"
val = PInt64()
separator = spc + E":" + spc
id = spc + E"Monkey" + spc + val + separator > Id
startItems = spc + E"Starting items" + separator + (val + P"[ ,]*")[0:end] + spc |> Items
op = spc + E"Operation" + separator + E"new" + spc  + E"=" + spc + p"[a-z*+\/ 0-9]+" + spc > Op
condition = spc + E"Test" + separator + E"divisible" + spc + E"by" + spc + val + spc > Condition
iff = spc + E"If" + spc
throwTo = separator + E"throw" + spc + E"to" + spc + E"monkey" + spc + val > ThrowTo
testTrue = iff + E"true" + throwTo > True
testFalse = iff + E"false" + throwTo > False
branches = (testTrue + testFalse) | (testFalse + testTrue)
test = condition + branches > Test
monkey.matcher = id + (startItems | op | test )[0:end] |> MonkeyNode
monkeys = monkey[0:end]

a = parse_one(read("day/11/input.txt", String), monkeys)
println(a)

