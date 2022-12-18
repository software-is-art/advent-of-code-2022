using ParserCombinator

abstract type Node end
struct Items <: Node val::Vector{Int} end
struct Id <: Node val::Int end
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

abstract type AbstractMonkey end
struct Monkey{T} <: AbstractMonkey end

function parseItems(items::String)
    return [Int(a) for a in Meta.parse(items).args]
end

function define(id::Id, test::Test, ::Int)
    index = id.val + 1
    trueIndex = test.branchTrue.val.val + 1
    falseIndex = test.branchFalse.val.val + 1
    @eval begin
        function testAndThrow(::Monkey{$id.val}, items::Vector{Vector{Int}})
            item = items[$index][end]
            if mod(item, $test.condition.val) == 0
                push!(items[$trueIndex], item)
            else
                push!(items[$falseIndex], item)
            end
            pop!(items[$index])
        end
    end
end

function define(id::Id, op::Op, cofactor::Int)
    index = id.val + 1
    exp = Meta.parse(op.val)
    @eval begin
        function inspect(::Monkey{$id.val}, items::Vector{Vector{Int}}, inspects::Vector{Int})
            old = items[$index][end]
            items[$index][end] = mod($exp, $cofactor)
            inspects[$index] += 1
        end
    end
end

function define(id::Id, starting::Items, ::Int)
    index = id.val + 1
    @eval begin
        function setup(::Monkey{$id.val}, items::Vector{Vector{Int}})
            items[$index] = $starting.val
        end

        function finished(::Monkey{$id.val}, items::Vector{Vector{Int}})
            return length(items[$index]) == 0
        end
    end
end

function define(id::Id, ::Id, ::Int) end

function parseMonkeyAst(fileName::String)
    return parse_one(read(fileName, String), monkeys)
end

function transformAst(monkeyNodes)
    monkeys = Vector{AbstractMonkey}()
    cofactor = reduce(*, [filter(x -> typeof(x) == Test, m.val)[1].condition.val for m in monkeyNodes])
    for monkeyNode in monkeyNodes
        id = filter(x -> typeof(x) == Id, monkeyNode.val)[1]
        [define(id, x, cofactor) for x in monkeyNode.val]
        insert!(monkeys, id.val + 1, @eval Monkey{$id.val}())
    end
    return monkeys
end

function playRound(monkeys::Vector{AbstractMonkey}, items::Vector{Vector{Int}}, inspects::Vector{Int})
    for monkey in monkeys
        while !finished(monkey, items)
            inspect(monkey, items, inspects)
            testAndThrow(monkey, items)
        end
    end
end

function run(monkeys::Vector{AbstractMonkey}, rounds::Int)
    items = collect([[0] for x in monkeys])
    inspects = collect([0 for x in monkeys])
    [setup(x, items) for x in monkeys]

    [playRound(monkeys, items, inspects) for x in 1:rounds]
    return inspects
end

function monkeyBusiness(inspects::Vector{Int})
    sorted = sort(inspects, rev=true)
    return Int128(sorted[1]) * Int128(sorted[2])
end

monkeyNodes = parseMonkeyAst("day/11/input.txt")
monkeys = transformAst(monkeyNodes)
inspects = run(monkeys, 10000)
println(monkeyBusiness(inspects))


