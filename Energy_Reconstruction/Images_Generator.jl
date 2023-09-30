include("../My_functions.jl")
using .my_functions: replace_ID_with_coords
using  UnROOT, DataFrames, CSV, Base.Threads, Parquet, Plots

# Import the CSV file with the ID and the positions
path_ID = "/home/adan1210/Desktop/swgo_scripts/table_ID_and_positions_A1.parquet"
df_ID = DataFrame(Parquet.Table(path_ID))
dict_ID = Dict(row.ID => (row.x, row.y, row.z) for row in eachrow(df_ID));
##############################################################################################
#Initialize the Files
path = [];
list_files_values=[["DAT" * lpad(i, 6, '0'), j] for i in 102:150, j in 1:4];

main_list = [];
for i in 1:length(list_files_values)
    # Create the names DAT000001, DAT000002, ...
    DATXXX = list_files_values[i][1] 
    YYY    = list_files_values[i][2]
    
    # Initialize the path
    path = "/home/lmorales/swgo/swgo_files/ROOT_Aerie_C/hawcsim-$(DATXXX)_A1_gamma_$(YYY)_50000.root"
    
    # Initialize the ROOT file
    f = ROOTFile(path)

    mytree = LazyTree(f ,"XCDF",["HAWCSim.PE.PMTID","HAWCSim.Evt.Energy", "HAWCSim.PE.Energy"])
    list = []
    Threads.@threads for Tleaf in mytree # Tleaf[1]=PMTID, Tleaf[2]=Initial Energy, Tleaf[3]=Energy
        if !isempty(Tleaf[1]) && Tleaf[2] > 250000
            pmtID=Int64.(Tleaf[1])
            Tbrunch = [ [Tleaf[2],i, j] for (i,j) in zip(Tleaf[1], Tleaf[3]) ]
            push!(list, Tbrunch)
        end
    end
    temp_list = []
    for sublist in list
    push!(temp_list, replace_ID_with_coords(sublist, dict_ID))
    end
    list = temp_list;
    append!(main_list, list)
end
main_list

i
#j=length(main_list)
#i=i+j
E₀ = [];
for list_of_lists in main_list
    # Crear un diccionario para almacenar la frecuencia y el color de cada punto
    point_dict = Dict()
    E1₀ = Float64[];
    for sublist in list_of_lists
        E1₀= sublist[1]
        x = sublist[2]
        y = sublist[3]
        e₀= sublist[4]
        color_value = e₀/ 10  # Poner el color en un una escala de /10 GeV
        point = (x, y)
    
        if haskey(point_dict, point)
            # Si el punto ya existe en el diccionario, incrementar la frecuencia y acumular el valor de color
            freq, color = point_dict[point]
            point_dict[point] = (freq + 1, color + color_value)
        else
            # Si el punto no existe en el diccionario, inicializar la frecuencia y el valor de color
            point_dict[point] = (1, color_value)
        end
    end
    push!(E₀,E1₀)
    # Extraer las columnas x, y y los colores
    x = Float64[]
    y = Float64[]
    colors = Float64[]

    for ((xi, yi), (freq, color)) in point_dict
        push!(x, xi)
        push!(y, yi)
        push!(colors, 1-color)
    end

    #E₀ = replace(string(E₀), "." => "_")
    # Crear el gráfico
    scatter(x, y, 
    color=:grays, label=false, 
    xlabel="x", ylabel="y", zcolor=colors, 
    framestyle=:none, grid=false,
    xlims=(-300, 300), ylims=(-300, 300), 
    markersize=1.9, markerstrokewidth=0,
    colorbar = false,
    clims=(0,2),dpi=600)
    # Guardar el gráfico en un archivo SVG
    savefig("/home/lmorales/swgo/swgo_files/Images_ML/shower_$(i).svg")
    i=i+1
end
E₀
open("/home/lmorales/swgo/swgo_files/Images_ML/shower_list.txt", "a") do file
    # Escribe cada elemento de la lista en una nueva línea del archivo
    for elemento in E₀
        write(file, "$elemento\n")
    end
end









#DEBUGG
f = UnROOT.ROOTFile("/home/lmorales/swgo/swgo_files/DATA_Colaboration/ROOT_Aerie/hawcsim-DAT000050_A1_gamma_1_50000.root");
LazyTree(f ,"XCDF",["HAWCSim.Evt.Num"])

f["XCDF"]["HAWCSim.Evt.Num"]
mytree = LazyTree(f ,"XCDF",["HAWCSim.PE.PMTID","HAWCSim.Evt.Energy", "HAWCSim.PE.Energy"])

list = []
Threads.@threads for Tleaf in mytree # Tleaf[1]=PMTID, Tleaf[2]=Initial Energy, Tleaf[3]=Energy
    if !isempty(Tleaf[1]) && Tleaf[2] > 200000
        pmtID=Int64.(Tleaf[1])
        Tbrunch = [ [Tleaf[2],i, j] for (i,j) in zip(Tleaf[1], Tleaf[3]) ]
        push!(list, Tbrunch)
    end
end

function replace_ID_with_coords(lst, dict_ID)
    # Usar una comprensión de lista para reemplazar el ID solo con las coordenadas x,y
    return [[sublst[1], dict_ID[sublst[2]][1], dict_ID[sublst[2]][2], sublst[3]] for sublst in lst]
end

temp_list = []
Threads.@threads for sublist in list
    push!(temp_list, replace_ID_with_coords(sublist, dict_ID))
end
list = temp_list;

