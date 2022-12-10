import Base: parse

mutable struct Tree
    height::Int8
    viewN::Int
    viewS::Int
    viewE::Int
    viewW::Int
end

struct Forest
    x::Int
    y::Int
    trees::Vector{Vector{Tree}}
end

function parseForest(lines::Vector{String})
    trees = Vector{Vector{Tree}}()
    for (i, line) in enumerate(lines)
        row = Vector{Tree}()
        insert!(trees, i, row)
        for (j, char) in enumerate(line)
            insert!(row, j, Tree(parse(Int8, char), 0, 0, 0, 0))
        end
    end
    return Forest(length(trees[1]), length(trees), trees)
end

function addToRay(height::Int8, ray::Vector{Int8})
    for (i, otherH) in enumerate(reverse(ray))
        if (otherH >= height)
            push!(ray, height)
            return i
        end
    end
    push!(ray, height)
    return length(ray) - 1
end

function rayCastNS(forest::Forest)
    for i in 1:forest.x
        ray = Vector{Int8}()
        for j in 1:forest.y
            tree = forest.trees[j][i]
            tree.viewN = addToRay(tree.height, ray)
        end
    end
end

function rayCastSN(forest::Forest)
    for i in 1:forest.x
        ray = Vector{Int8}()
        for j in reverse(1:forest.y)
            tree = forest.trees[j][i]
            tree.viewS = addToRay(tree.height, ray)
        end
    end
end

function rayCastEW(forest::Forest)
    for i in 1:forest.y
        ray = Vector{Int8}()
        for j in reverse(1:forest.x)
            tree = forest.trees[i][j]
            tree.viewE = addToRay(tree.height, ray)
        end
    end
end

function rayCastWE(forest::Forest)
    for i in 1:forest.y
        ray = Vector{Int8}()
        for j in 1:forest.x
            tree = forest.trees[i][j]
            tree.viewW = addToRay(tree.height, ray)
        end
    end
end

function calculateVisibility(forest::Forest)
    rayCastNS(forest)
    rayCastSN(forest)
    rayCastEW(forest)
    rayCastWE(forest)
end

forest = parseForest(readlines("day/8/input.txt"))
calculateVisibility(forest)
println(maximum([tree.viewN * tree.viewE * tree.viewS * tree.viewW for row in forest.trees for tree in row]))