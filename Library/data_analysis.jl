#My functions
module DataAnalysis

export flatten_to_level, replace_ID_with_coords, create_string_range, create_string_range_scientific
using Printf
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

function create_string_range(factor, i)
    start = i * factor
    stop = (i + 1) * factor
    if factor < 1
        exponent = floor(log10(factor))
        start_mantissa = round(start / 10^exponent, sigdigits=2)
        stop_mantissa = round(stop / 10^exponent, sigdigits=2)
        start_str = (start_mantissa == round(start_mantissa)) ? string(Int(start_mantissa)) : @sprintf("%.1f", start_mantissa)
        stop_str = (stop_mantissa == round(stop_mantissa)) ? string(Int(stop_mantissa)) : @sprintf("%.1f", stop_mantissa)
        return "$(start_str)×10^$(Int(exponent)) - $(stop_str)×10^$(Int(exponent))"
    else
        start_str = (start == round(start)) ? string(Int(start)) : @sprintf("%.1f", start)
        stop_str = (stop == round(stop)) ? string(Int(stop)) : @sprintf("%.1f", stop)
        return "$(start_str) - $(stop_str)"
    end
end

function create_string_range_scientific(factor, i)
    range = String[]
    start = i * factor
    stop = (i + 1) * factor
    if factor < 1
        exponent = floor(log10(factor))
        start_mantissa = start / 10^exponent
        stop_mantissa = stop / 10^exponent
        push!(range, "$(start_mantissa)×10^$(Int(exponent)) - $(stop_mantissa)×10^$(Int(exponent))")
    else
        push!(range, "$(start) - $(stop)")
    end
    return range
end
end