include("../data_analysis.jl")
using .DataAnalysis: replace_ID_with_coords
using  UnROOT, DataFrames, Base.Threads, CSV, Plots, Base.Filesystem
##############################################################################################
# Import the CSV file with the ID and Positions pf the PMT's.
path_SWGO = dirname(pwd())
path_ID_CSV = path_SWGO * "/Swgo_Scripts/Arrays/table_ID_and_positions_A1.csv";

df_ID = CSV.read(path_ID_CSV, DataFrame);
dict_ID = Dict(row.ID => (row.x, row.y, row.z) for row in eachrow(df_ID));
##############################################################################################
# Initialice the names of all ROOT Files to work.
path = [];
list_files_values = [["DAT" * lpad(i, 6, '0'), j] for i in 1:1, j in 0:0 if !(i == 50 && j == 1)];
##############################################################################################
#Create the main_list, that list contain the data for work and have the form:
main_list = [];
#Initialize the ROOT file and almacenated in the main_list.
for i in 1:length(list_files_values)
    # Create the names DAT000001, DAT000002, ...
    DATXXX = list_files_values[i][1] 
    YYY    = list_files_values[i][2]
    
    # Initialize the path
    path = path_SWGO * "/swgo_files/ROOT_Aerie_C/hawcsim-$(DATXXX)_A1_gamma_$(YYY)_50000.root"
    
    # Initialize the ROOT file
    f = ROOTFile(path)
    mytree = LazyTree(f ,"XCDF",["HAWCSim.PE.PMTID","HAWCSim.Evt.Energy", "HAWCSim.PE.Energy"])

    list_energies_ID = []
    Threads.@threads for Tleaf in mytree # Tleaf[1]=PMTID, Tleaf[2]=Initial Energy, Tleaf[3]=Energy
        if !isempty(Tleaf[1]) && Tleaf[2] > 250000
            pmtID=Int64.(Tleaf[1])
            Tbrunch = [ [Tleaf[2],i, j] for (i,j) in zip(Tleaf[1], Tleaf[3]) ]
            push!(list_energies_ID, Tbrunch)
        end
    end

    list_energies_positions = []
    for sublist in list_energies_ID
    push!(list_energies_positions, replace_ID_with_coords(sublist, dict_ID))
    end

    append!(main_list, list_energies_positions)
end
##############################################################################################
list_max_energy_total_Tank = [];
list_n_pmt = [];
list_E₀ = [];
# The function generate_scatter_plots() create the plots of all 🚿 simulated with energy >25TeV, and obtain the lists: max energy detected in a tank, number of pmts of defected per shower simulated, and the energy of the particle primary  per shower 🚿.
function generate_scatter_plots(main_list, output_directory::String, number_shower::Int)
    for list_of_lists in main_list
        point_dict = Dict()
        E₀ = Float64[]
        for sublist in list_of_lists
            E₀  = sublist[1]
            x   = sublist[2]
            y   = sublist[3]
            e₀  = sublist[4]
            point = (x, y)

            if haskey(point_dict, point)
                freq, energy_total_PMT = point_dict[point]
                point_dict[point]      = (freq + 1, energy_total_PMT + e₀)
            else
                point_dict[point] = (1, e₀)
            end
        end
        push!(list_E₀, E₀) #This E₀ repeat in all the shower of list_of_lists.
        list_x     = Float64[]
        list_y     = Float64[]
        list_freq  = Float64[]
        list_energy_total_PMT = Float64[]

        for ((x, y), (freq, energy_total_PMT)) in point_dict
            push!(list_x, x)
            push!(list_y, y)
            push!(list_freq, freq)
            push!(list_energy_total_PMT, energy_total_PMT)
        end
        
        max_energy_total_PMT = maximum(list_energy_total_PMT)
        n_pmt = sum(list_freq)
        push!(list_max_energy_total_Tank, max_energy_total_PMT)
        push!(list_n_pmt, n_pmt)

        list_energy_total_PMT_normalice = list_energy_total_PMT ./ max_energy_total_PMT
        scatter(list_x, list_y, 
        color=:grays, label=false, 
        zcolor=list_energy_total_PMT_normalice, 
        framestyle=:none, grid=false,
        xlims=(-300, 300), ylims=(-300, 300), 
        markersize=1.9, markerstrokewidth=0,
        colorbar=false,
        clims=(0,1), 
        size =(1200,1200), dpi =600);
        
        savefig(output_directory * "/shower_$(number_shower).png");
        number_shower += 1
    end
    # Write in a txt file
    data = Dict(
    "E₀" => list_E₀,
    "n_pmt" => list_n_pmt,
    "max_energy_total_Tank" => list_max_energy_total_Tank
    )
    df = DataFrame(data)
    CSV.write(output_directory * "/data.csv", df)
end
##############################################################################################
# This is just the path where the plots will be generated.
path_images = dirname(dirname(path_SWGO)) * "/rhorna/imagenes/images_luis"
# This the number of the first shower (it's just a label).
shower_initial = length(readdir(path_images)) == 0 ? 1 : length(readdir(path_images))
#Finally we generate the plots and a CSV where the list are almacenated.
generate_scatter_plots(main_list, path_images, shower_initial)
##############################################################################################