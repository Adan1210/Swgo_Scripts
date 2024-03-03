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
# Files doesn't work
path_filter = path_SWGO * "/swgo-aerie/missing_files.txt";  # Reemplaza esto con la ruta real
excluded_pairs = Set();
open(path_filter, "r") do file
    for line in eachline(file)
        i, j = parse.(Int, split(line))
        push!(excluded_pairs, (i, j))
    end
end
###########################################################################################
# Initialice the names of all ROOT Files to work.
path = [];
list_files_values = [["DAT" * lpad(i, 6, '0'), j] for i in 1:10, j in 0:4 if !((i, j) in excluded_pairs)]; #aun no compilo esto, se quedo en 517
###########################################################################################
#Create the main_list, that list contain the data for work and have the form:
main_list = [];
# Initialize the path
path = path_SWGO * "/swgo_files/ROOT_Aerie_C/hawcsim-DAT000001_A1_gamma_1_50000.root"
f = ROOTFile(path)
# Give the names of variables of the files
names1 = names(LazyTree(f, "XCDF"))

names1("Evt_X")