#My functions
module my_functions

export flatten_to_level, replace_ID_with_coords

# Flatten a list to a certain level
function flatten_to_level(lst, level)
    if level == 1 || !isa(lst, AbstractArray)
        return [lst]
    end
    return vcat(map(x -> flatten_to_level(x, level-1), lst)...)
end
# Replace the ID with the coordinates
function replace_ID_with_coords(lst, dict_ID)
    # Usar una comprensión de lista para reemplazar el ID solo con las coordenadas x,y
    return [[sublst[1], dict_ID[sublst[2]][1], dict_ID[sublst[2]][2], sublst[3]] for sublst in lst]
end

end
232-232322
