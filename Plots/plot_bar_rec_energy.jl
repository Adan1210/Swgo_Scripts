using  UnROOT, DataFrames, Base.Threads, Plots, Base.Filesystem, Statistics
##############################################################################################
path_SWGO = dirname(pwd())
###########################################################################################
# Initialice the names of all ROOT Files to work.
path = [];
list_files_values = [["DAT" * lpad(i, 6, '0'), j] for i in 1:100, j in 0:4];
#######################################################################################
#Create the main_list, that list contain the data for work and have the form:
list_positions_rᵢ, list_energies, range = [], [],[10^5,10^5,10^6] ;

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
        mytree = LazyTree(f ,"XCDF",["event.nHit","mc.delCore","SimEvent.energyTrue","mc.zenithAngle"])

        for Tleaf in mytree
            if Tleaf[1]>=25 && 300>=Tleaf[2]/100>=0 && Tleaf[3]>=0 && Tleaf[4] <= π/4
                push!(list_positions_rᵢ, Tleaf[2]/100)
                push!(list_energies, Tleaf[3])
            end
        end

    catch e

    end
end

#list_energies

#######################################################################################
list_mean_r, list_std_r, list_energies_names = [], [], [];

temp = sort(zip(list_positions_rᵢ, list_energies), by=x -> x[2])

for j in range[1]:range[2]:range[3]
    # Inicializa las listas para cada j.
    list_positions_rᵢ_j = Float64[]
    list_energies_rᵢ_j = Float64[]

    # Recorre 'temp' una vez y acumula los valores que cumplan la condición.
    for x in temp
        if j - range[2] <= x[2] <= j
            push!(list_positions_rᵢ_j, x[1])
        end
    end

    # Si la lista no está vacía, calcula las estadísticas.
    if !isempty(list_positions_rᵢ_j)
        push!(list_mean_r, mean(list_positions_rᵢ_j))
        push!(list_std_r, std(list_positions_rᵢ_j))
    else
        push!(list_mean_r, 0)
        push!(list_std_r, 0)
    end
    push!(list_energies_names, j)
end

labels_energies = [string(i == 1 ? 0 : list_energies_names[i-1]/10^6, "-", list_energies_names[i]/10^6) for i in 1:length(list_energies_names)]
list_mean_r

#######################################################################################
bar(
    (0:length(labels_energies)-1), list_mean_r, yerr = list_std_r,
    xlim=(-0.8,length(labels_energies)-0.2),                             #limits of x axis
    ylim=(0,15),                                                           #limits of y axis
    xticks=(0:length(labels_energies),labels_energies) ,                                                        
    yticks=(0:2.5:15),
    title="Mean of Core Position",                                         #title
    #label=:"Photon",                                                      # label
    legend=false,      #legendtitle="Primary Particle:", legend =:topright,       
    bar_width=1,                                                           # Ancho de las barras
    color=:skyblue,                                                        # Color de las barras
    framestyle=:box, gridstyle=:solid,                                     # frame
    gridlinewidth=2, gridalpha=0.3,                                        # grid and width
    xlabel="Primary Energy (PeV)",                                         # label of x axis
    ylabel="r (m)",                                                        # label of y axis
    linestyle=:solid, linewidth=1.5,                                       # type of line
    marker=:circle, markercolor=:red, markersize=10,                       # marker and size
    markerstrokecolor=:black, markerstrokewidth=0.5,                       # contour of the marker
    titlefont=font("Times New Roman",10),
    guidefont=font("Times New Roman",10),
    legendfont=font("Times New Roman",10),
    #aspect_ratio = 0.25, 
    dpi=500)
# Save the figure
file_name = path_SWGO*"/swgo_files/Plots/r_vs_E0_binsbar.png"
savefig(file_name)