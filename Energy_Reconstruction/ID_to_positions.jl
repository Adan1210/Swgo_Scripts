using LightXML, DataFrames, Statistics, Parquet, CSV
# Read the XML file
path_SWGO = pwd();
path_survey = path_SWGO * "/Arrays/survey_A1.xml";
xml_doc = xml_doc = parse_file(path_survey);  
# Obtain the root element
root_element = root(xml_doc);
# Shear all <layout>
layout_element = find_element(root_element, "layout");
# Shear all elements <tank> inside in <layout>
tanks = get_elements_by_tagname(layout_element, "tank");

# Create a null df
df1 = DataFrame(ID = Int[], x = Float64[], y = Float64[], z = Float64[]);
# Iterate over each tank, then over each set of <channels>, and finally over each <channel>.
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
# Create a null df
df2 = DataFrame(ID = Int[], x = Float64[], y = Float64[], z = Float64[]);
# Iterate over each tank and extract the position information.
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

# Iterate over the row of df2 and sum over the rows of df1.
for i in 1:nrow(df2)
    # Indices of the rows in df1 to which row i of df2 will be added.
    idx1 = 2*i - 1
    idx2 = 2*i
    
    df1[idx1, :x] += df2[i, :x]
    df1[idx1, :y] += df2[i, :y]
    df1[idx1, :z] += df2[i, :z]
    
    df1[idx2, :x] += df2[i, :x]
    df1[idx2, :y] += df2[i, :y]
    df1[idx2, :z] += df2[i, :z]
end
# Compatibility issues we have to put ID as Float64
df1.ID = Float64.(df1.ID)
df1

# Write the CSV file
path_ID_table_CSV = path_SWGO * "/Arrays/table_ID_and_positions_A1.csv"
CSV.write(path_ID_table_CSV, df1)

# Write the Parquet file
# path_ID_table_parquet = path_SWGO * "/Arrays/table_ID_and_positions_A1.parquet"
# Parquet.write_parquet(path_ID_table_parquet, df1)
# Read the Parquet file
# df_ID = DataFrame(Parquet.Table(path_ID))