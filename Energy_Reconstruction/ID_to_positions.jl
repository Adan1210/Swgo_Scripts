using LightXML, DataFrames, Statistics, Parquet
# Leer el archivo XML
path_survey = "/home/adan1210/Desktop/swgo_scripts/Arrays/survey_A1.xml";
xml_doc = xml_doc = parse_file(path_survey);  # Reemplaza "ruta_del_archivo.xml" con la ruta real de tu archivo
# Obtener el elemento raíz del documento
root_element = root(xml_doc);
# Buscar todos los elementos <layout>
layout_element = find_element(root_element, "layout");
# Buscar todos los elementos <tank> dentro de <layout>
tanks = get_elements_by_tagname(layout_element, "tank");

# Crear un DataFrame vacío
df1 = DataFrame(ID = Int[], x = Float64[], y = Float64[], z = Float64[]);
# Iterar sobre cada tank, luego sobre cada conjunto <channels> y finalmente sobre cada <channel>
for tank in tanks
    channels_set = find_element(tank, "channels")
    if channels_set !== nothing
        channels = get_elements_by_tagname(channels_set, "channel")
        #println("Number of shower in this tank: ", length(channels))
        for channel in channels
            id = parse(Int, attribute(channel, "id"))
            position_element = find_element(channel, "position")
            if position_element === nothing
                #println("It doesn't have a tank with ID: ", id)
                continue
            end
            x = parse(Float64, content(find_element(position_element, "x")))/100
            y = parse(Float64, content(find_element(position_element, "y")))/100
            z = parse(Float64, content(find_element(position_element, "z")))/100
            push!(df1, (ID=id, x=x, y=y, z=z))
        end
    end
end
# Crear un DataFrame vacío
df2 = DataFrame(ID = Int[], x = Float64[], y = Float64[], z = Float64[]);
# Iterar sobre cada tank y extraer la información de posición
for tank in tanks
    id = parse(Int, attribute(tank, "id"))
    position_element = find_element(tank, "position")
    if position_element !== nothing
        x = parse(Float64, content(find_element(position_element, "x")))/100
        y = parse(Float64, content(find_element(position_element, "y")))/100
        z = parse(Float64, content(find_element(position_element, "z")))/100
        push!(df2, (ID=id, x=x, y=y, z=z))
    end
end

# Iterar sobre las filas de dataframe2 y sumarlas a las filas correspondientes de dataframe1
for i in 1:nrow(df2)
    # Indices de las filas en dataframe1 a las que se sumará la fila i de dataframe2
    idx1 = 2*i - 1
    idx2 = 2*i
    
    df1[idx1, :x] += df2[i, :x]
    df1[idx1, :y] += df2[i, :y]
    df1[idx1, :z] += df2[i, :z]
    
    df1[idx2, :x] += df2[i, :x]
    df1[idx2, :y] += df2[i, :y]
    df1[idx2, :z] += df2[i, :z]
end
# Cuetiones de compatibilidad tenemos que poner ID como Float64
df1.ID = Float64.(df1.ID)
df1

# Write the Parquet file
path = "/home/adan1210/Desktop/swgo_scripts/table_ID_and_positions_A1.parquet"
Parquet.write_parquet(path, df1)