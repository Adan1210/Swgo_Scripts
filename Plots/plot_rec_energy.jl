using  UnROOT, DataFrames, Base.Threads, Plots, Base.Filesystem
##############################################################################################
path_SWGO = dirname(pwd())
###########################################################################################
# Initialice the names of all ROOT Files to work.
path = [];
list_files_values = [["DAT" * lpad(i, 6, '0'), j] for i in 1:100, j in 0:4];
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
    try
        f = ROOTFile(path)
        mytree = LazyTree(f ,"XCDF",["mc.logEnergy","mc.delCore"])
        main_list = [];

        for Tleaf in mytree
            if Tleaf[2] > 2 #Energy > 100 GeV
                element = [Tleaf[2], Tleaf[1]/100]
                push!(main_list, element)
            end

        end

        append!(list_positions_rᵢ, main_list)
    catch e
    end
end

list_positions_rᵢ

#######################################################################################
using Plots

true_energy = [arr[1] for arr in list_positions_rᵢ]
x = [arr[1] for arr in list_positions_rᵢ]
y = [arr[3] for arr in list_positions_rᵢ]

# Crear el gráfico de dispersión con barra de energía de color
scatter(x, y, 
    zcolor= true_energy,
    xlabel="X (m)",                                        #label of x axis
    ylabel="Y (m)",                                        #label of y axis
    zlabel="Energy (GeV)",                                 #label of z axis
    xlim = (0,20),
    ylim = ( 0, 0.08),
    title="Position of the core with initial energy (GeV)",      #title
    label=:"Position",                                     #label
    legend=:topright,                                      #lengend
    framestyle=:box, gridstyle=:solid,                     #frame
    gridlinewidth=2, gridalpha=0.3,                        #grid and width


    linestyle=:solid, linewidth=1,                       #type of line
    marker=:circle, markersize=2,                          #marker and size
    markerstrokecolor=:black, markerstrokewidth=0.2,       #contour of the marker
    titlefont=font("Times New Roman",10),
    guidefont=font("Times New Roman",10),

    dpi=600)

# Save the figure
file_name = path_SWGO*"/swgo_files/Plots/position_core1.png"
savefig(file_name)

#######################################################################################
using Plots

true_energy = [arr[1] for arr in list_positions_rᵢ]
r = [arr[2] for arr in list_positions_rᵢ]

# Crear el gráfico de dispersión con barra de energía de color
scatter(true_energy, r, 
    xlabel="log(Energy) (GeV)",                                        #label of x axis
    ylabel="r (m)",                                        #label of y axis
    xlim = (1.9, 6.1),
    ylim = ( 0, maximum(r) + 0.1),
    title="Diference core location vs initial particle energy (GeV)", #title
    label=:"Diference between inicial position vs reconstructed position",                                      #label
    legend=:topright,                                       #lengend
    framestyle=:box, gridstyle=:solid,                      #frame
    gridlinewidth=2, gridalpha=0.3,                         #grid and width


    linestyle=:solid, linewidth=1,                          #type of line
    marker=:circle, markersize=2,                           #marker and size
    markerstrokecolor=:black, markerstrokewidth=0.2,        #contour of the marker
    titlefont=font("Times New Roman",10),
    guidefont=font("Times New Roman",10),

    dpi=800)

# Save the figure
file_name = path_SWGO*"/swgo_files/Plots/position_core2.png"
savefig(file_name)