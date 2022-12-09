struct File
    name::String
    size::Int64
end

mutable struct Dir
    name::String
    size::Int64
    children::Dict{String, Dir}
    files::Dict{String, File}
    parent::Union{Dir, Nothing}
end

function addSizeToPath(_::Nothing, _::Int64)
end

function addSizeToPath(dir::Dir, size::Int64)
    dir.size += size;
    addSizeToPath(dir.parent, size)
end

function tryParseCommand(segments::Vector{SubString{String}}, currentDir::Dir)
    if segments[2] == "cd" && segments[3] == ".."
        return currentDir.parent
    end
    if segments[2] == "cd"
        name = join(segments[3:end], " ")
        return currentDir.children[name]
    end
end

function tryParseDirectory(segments::Vector{SubString{String}}, currentDir::Dir)
    if segments[1] != "dir"
        return nothing
    end
    dir = createDir(join(segments[2:end], " "), currentDir)
    currentDir.children[dir.name] = dir
    return dir
end

function tryParseFile(segments::Vector{SubString{String}}, currentDir::Dir)
    file_size = tryparse(Int64, segments[1])
    if file_size == nothing
        return nothing
    end
    file = File(join(segments[2:end], " "), file_size)
    currentDir.files[file.name] = file
    addSizeToPath(currentDir, file.size)
    return file
end

function parseLine(line::String, currentDir::Dir)
    segments = split(line, " ")
    file = tryParseFile(segments, currentDir) 
    if file != nothing
        return currentDir
    end
    dir = tryParseDirectory(segments, currentDir)
    if dir != nothing
        return currentDir
    end
    dir = tryParseCommand(segments, currentDir)
    if dir != nothing
        return dir
    end
    return currentDir
end

function createDir(name::String, parent::Union{Dir, Nothing})
    return Dir(
        name,
        0,
        Dict{String, Dir}(),
        Dict{String, File}(),
        parent
    )
end

function parse(input::Vector{String})
    root = createDir("/", nothing)
    currentDir = root
    for line in input[2:end]
        currentDir = parseLine(line, currentDir)
    end
    return root
end

function findCandidates(current::Dir, selected::Vector{Dir}, limit::Int64)
    if current.size <= limit
        push!(selected, current)
    end
    for (_, dir) in current.children
        findCandidates(dir, selected, limit)
    end
    return selected
end

root = parse(readlines("day/7/input.txt"))
candidates = findCandidates(root, Vector{Dir}(), 100000)
sum = reduce(+, [c.size for c in candidates])
println(sum)