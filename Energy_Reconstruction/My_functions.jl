#My functions
module a

export flatten_to_level
# Flatten a list to a certain level
function flatten_to_level(lst, level)
    if level == 1 || !isa(lst, AbstractArray)
        return [lst]
    end
    return vcat(map(x -> flatten_to_level(x, level-1), lst)...)
end

end
