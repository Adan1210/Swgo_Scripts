using UnROOT, Plots, Statistics, DataFrames, CSV
#Initialize the Files
path = [];
list_energies_total = [];
for i in 1:4000
    DATXXX = "DAT" * lpad(i, 6, '0') # Create the names DAT000001, DAT000002, ...
    for YYY in 0:4
        # Initialize the path
        path      = "/home/lmorales/swgo/swgo_files/DATA_Colaboration/ROOT_Aerie/hawcsim-$(DATXXX)_A1_gamma_$(YYY)_50000.root"
        path      = eval(Meta.parse("path"))
        # Initialize the ROOT file
        root_file = ROOTFile(path)
        mytree    = LazyTree(root_file ,"XCDF",["HAWCSim.PE.PMTID", "HAWCSim.PE.Energy", "HAWCSim.Evt.Energy"])
        #Initialize the lists
        list_pmtID          = [ Float64.(sub_array) for sub_array in mytree[:, :HAWCSim_PE_PMTID] ]
        list_energy         = [ Float64.(sub_array) for sub_array in mytree[:, :HAWCSim_PE_Energy] ]
        list_initial_energy = [ Float64.(sub_array) for sub_array in mytree[:, :HAWCSim_Evt_Energy] ]
        # Initialize the list of showers
        list_showers = []
        # Initialize the list of showers with the PMT ID and the initial energy
        for i in 1:length(list_energy)
            push!(list_showers, [collect(t) for t in zip(list_pmtID[i], list_energy[i])])
        end
        # Add the initial energy to each shower
        for i in 1:length(list_showers)
            xd=list_showers[i]
            if !isempty(xd)
                for subvec in xd
                    push!(subvec, list_initial_energy[i])
                end
            end
        end
        # Delete the empty showers
        list_showers = [sublist for sublist in list_showers if !isempty(sublist)]
        # Filter for initial energy
        list_filter = [[sublist2 for sublist2 in sublist3 if sublist2[3] > 10000] for sublist3 in list_showers]
        list_showers = filter(!isempty, list_filter)
        append!(list_energies_total, list_showers)
    end
end
list_energies_total



using LightXML
using DataFrames

# Leer el archivo XML
xml_doc = parse_file("./survey.xml")  # Reemplaza "ruta_del_archivo.xml" con la ruta real de tu archivo

# Obtener el elemento raíz del documento
root_element = root(xml_doc)


# Buscar todos los elementos <layout>
layout_element = find_element(root_element, "layout")

# Buscar todos los elementos <tank> dentro de <layout>
tanks = get_elements_by_tagname(layout_element, "tank")

# Crear un DataFrame vacío
df = DataFrame(ID = Int[], x = Float64[], y = Float64[], z = Float64[])

# Iterar sobre cada tank y luego sobre cada channel
for tank in tanks
    channels = get_elements_by_tagname(tank, "channel")
    println("Número de canales en este tanque: ", length(channels))
    for channel in channels
        id = parse(Int, attribute(channel, "id"))
        position_element = find_element(channel, "position")
        if position_element === nothing
            println("No se encontró el elemento de posición para el canal con ID: ", id)
            continue
        end
        x = parse(Float64, content(find_element(position_element, "x")))
        y = parse(Float64, content(find_element(position_element, "y")))
        z = parse(Float64, content(find_element(position_element, "z")))
        push!(df, (ID=id, x=x, y=y, z=z))
    end
end
# Mostrar el DataFrame
print(df)

using LightXML
using DataFrames

# Leer el archivo XML
xml_doc = xml_doc = parse_file("./survey.xml")  # Reemplaza "ruta_del_archivo.xml" con la ruta real de tu archivo

# Obtener el elemento raíz del documento
root_element = root(xml_doc)

# Buscar todos los elementos <layout>
layout_element = find_element(root_element, "layout")

# Buscar todos los elementos <tank> dentro de <layout>
tanks = get_elements_by_tagname(layout_element, "tank")

# Crear un DataFrame vacío
df = DataFrame(ID = Int[], x = Float64[], y = Float64[], z = Float64[])

# Iterar sobre cada tank, luego sobre cada conjunto <channels> y finalmente sobre cada <channel>
for tank in tanks
    channels_set = find_element(tank, "channels")
    if channels_set !== nothing
        channels = get_elements_by_tagname(channels_set, "channel")
        println("Número de canales en este tanque: ", length(channels))
        for channel in channels
            id = parse(Int, attribute(channel, "id"))
            position_element = find_element(channel, "position")
            if position_element === nothing
                println("No se encontró el elemento de posición para el canal con ID: ", id)
                continue
            end
            x = parse(Float64, content(find_element(position_element, "x")))
            y = parse(Float64, content(find_element(position_element, "y")))
            z = parse(Float64, content(find_element(position_element, "z")))
            push!(df, (ID=id, x=x, y=y, z=z))
        end
    end
end

# Mostrar el DataFrame
df

print(df)






