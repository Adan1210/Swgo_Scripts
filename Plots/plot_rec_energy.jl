using  UnROOT, DataFrames, Base.Threads, Plots, Base.Filesystem
##############################################################################################
path_SWGO = dirname(pwd())
###########################################################################################
# Initialice the names of all ROOT Files to work.
path = [];
excluded_pairs = Set();
list_files_values = [["DAT" * lpad(i, 6, '0'), j] for i in 1:1, j in 0:4 if !((i, j) in excluded_pairs)];
###########################################################################################
#Create the main_list, that list contain the data for work and have the form:
list_positions_rᵢ = [];
#Initialize the ROOT file and almacenated in the main_list.
for i in eachindex(list_files_values)
    # Create the names DAT000001, DAT000002, ...
    DATXXX = list_files_values[i][1]
    YYY    = list_files_values[i][2]

    # Initialize the path
    path = path_SWGO * "/swgo_files/ROOT_rec_Aerie_C/reco-$(DATXXX)_A1_gamma_$(YYY)_50000.root"
    # Initialize the ROOT file
    f = ROOTFile(path)
    mytree = LazyTree(f ,"XCDF",["SimEvent.energyTrue","rec.coreX","rec.coreY"])
    main_list = [];

    for Tleaf in mytree
        element = [Tleaf[1],Tleaf[2]/100, Tleaf[3]/100]
        push!(main_list, element)
    end

    append!(list_positions_rᵢ, main_list)
end

list_positions_rᵢ

#######################################################################################
using Plots

true_energy = [arr[1] for arr in list_positions_rᵢ]
x = [arr[2] for arr in list_positions_rᵢ]
y = [arr[3] for arr in list_positions_rᵢ]

# Crear el gráfico de dispersión con barra de energía de color
scatter(x, y, 
    zcolor= true_energy,
    xlabel="X (m)",                                        #label of x axis
    ylabel="Y (m)",                                        #label of y axis
    zlabel="Energy (GeV)",                                 #label of z axis
    xlim = (-minimum(x)*10^2.5,maximum(x)*1.07),
    ylim = ( minimum(y)*1.05,maximum(y)+10^3),
    title="Position of the core with initial energy",      #title
    label=:"Position",                                     #label
    legend=:topright,                                      #lengend
    framestyle=:box, gridstyle=:solid,                     #frame
    gridlinewidth=2, gridalpha=0.3,                        #grid and width


    linestyle=:solid, linewidth=1.5,                       #type of line
    marker=:circle, markercolor=:red, markersize=3,        #marker and size
    markerstrokecolor=:black, markerstrokewidth=0.5,       #contour of the marker
    titlefont=font("Times New Roman",10),
    guidefont=font("Times New Roman",10),

    dpi=600)

# Save the figure
file_name = path_SWGO*"/swgo_files/Plots/position_core.svg"
savefig(file_name)