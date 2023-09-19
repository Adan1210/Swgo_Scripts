include("./My_functions.jl")
using .a: flatten_to_level
using UnROOT, Statistics, DataFrames, CSV

#Initialize the Files
path = [];
list_files_values=[["DAT" * lpad(i, 6, '0'), j] for i in 1:1, j in 1:1];
df = DataFrame(ID = Int[], Detected_Energy = Float64[], Shower_Initial_Energy = Float64[]);

for i in 1:length(list_files_values)
    # Create the names DAT000001, DAT000002, ...
    DATXXX=list_files_values[i][1] 
    YYY   =list_files_values[i][2]
    # Initialize the path
    path      = "/home/lmorales/swgo/swgo_files/DATA_Colaboration/ROOT_Aerie/hawcsim-$(DATXXX)_A1_gamma_$(YYY)_50000.root"
    path      = eval(Meta.parse("path"))
    # Initialize the ROOT file
    root_file = ROOTFile(path)
    mytree    = LazyTree(root_file ,"XCDF",["HAWCSim.PE.PMTID", "HAWCSim.PE.Energy", "HAWCSim.Evt.Energy"])
    #Initialize the lists
    list_pmtID          = [ Int.(sub_array)     for sub_array in mytree[:, :HAWCSim_PE_PMTID] ]
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
    # Flatten the list
    list_showers = flatten_to_level(list_showers, 3)
    # Add the values ad the dataframe of showers
    temp_list_energies_total = []
    append!(temp_list_energies_total, list_showers)
    for sublista in temp_list_energies_total
        push!(df, (ID=sublista[1], Detected_Energy=sublista[2], Shower_Initial_Energy=sublista[3]))
    end
end
# Read the CSV file with the ID and positions
df1 = DataFrame(CSV.File("./table_ID_and_positions.csv"));

# Legend
# df = DataFrame(ID = ..., PRIM_energy = ..., energy_total = ...)
# df1 = DataFrame(ID = ..., x = ..., y = ..., z = ...)

# Combine the dataframes by the ID
df = innerjoin(df1, df, on = :ID)
# We change the order of the columns
df = df[:, [:Shower_Initial_Energy, :x, :y, :z, :Detected_Energy]]
# Write the CSV file
CSV.write("./data_hornita.csv", df);