import Base: parse

mutable struct Tree
    height::Int8
    visible::Bool
end

struct Forest
    trees::Vector{Vector{Tree}}
end

function parseForest(lines::Vector{String})
    trees = Vector{Vector{Tree}}()
    for (i, line) in enumerate(lines)
        row = Vector{Tree}()
        insert!(trees, i, row)
        for (j, char) in enumerate(line)
            insert!(row, j, Tree(parse(Int8, char), false))
        end
    end
    return Forest(trees)
end

function setRowEdges(row::Vector{Tree})
    row[1].visible = true
    row[end].visible = true
end

function setForestEdges(forest::Forest)
    [tree.visible = true for tree in forest.trees[1]]
    [tree.visible = true for tree in forest.trees[end]]
    [setRowEdges(row) for row in forest.trees]
end

function rayCastNS(forest::Forest)
    tallestInPath = copy(forest.trees[1])
    for row in forest.trees[2:end]
        for (i, tree) in enumerate(row)
            if tree.height > tallestInPath[i].height
                tree.visible = true
                tallestInPath[i] = tree
            end
        end
    end
end

function rayCastSN(forest::Forest)
    tallestInPath = copy(forest.trees[end])
    for row in reverse(forest.trees[1:end-1])
        for (i, tree) in enumerate(row)
            if tree.height > tallestInPath[i].height
                tree.visible = true
                tallestInPath[i] = tree
            end
        end
    end
end

function rayCastEW(forest::Forest)
    tallestInPath = collect([row[end] for row in forest.trees])
    columns = length(forest.trees[1])
    for i in reverse(1:columns-1)
        for (j, row) in enumerate(forest.trees)
            tree = row[i]
            if tree.height > tallestInPath[j].height
                tree.visible = true
                tallestInPath[j] = tree
            end
        end
    end
end

function rayCastWE(forest::Forest)
    tallestInPath = collect([row[1] for row in forest.trees])
    columns = length(forest.trees[1])
    for i in 1:columns-1
        for (j, row) in enumerate(forest.trees)
            tree = row[i]
            if tree.height > tallestInPath[j].height
                tree.visible = true
                tallestInPath[j] = tree
            end
        end
    end
end

function calculateVisibility(forest::Forest)
    setForestEdges(forest)
    rayCastNS(forest)
    rayCastSN(forest)
    rayCastEW(forest)
    rayCastWE(forest)
end

forest = parseForest(readlines("day/8/input.txt"))
calculateVisibility(forest)
println(reduce(+, [Int32(tree.visible) for row in forest.trees for tree in row]))