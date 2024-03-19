using DataFrames, CSV
#######################################################################################
path_SWGO = dirname(pwd())
file_name_df = path_SWGO*"/swgo_files/Plots/df_data_server_2D.csv"
df = CSV.read(file_name_df, DataFrame)
#######################################################################################
list_positions_rᵢ = Array(df[!, "mc_delCore"])
list_energies = Array(df[!, "SimEvent_energyTrue"] / 1000)
#######################################################################################
#Create the main_list, that list contain the data for work and have the form:
range1 = [10^5,10^5,10^6] ;
# Convertir el resultado de zip en un Array de Tuples
temp = sort(collect(zip(list_positions_rᵢ, list_energies)), by = x -> x[2])

for j in range1:range1[2]:range1[3]
    # Inicializa las listas para cada j.
    list_positions_rᵢ_j = Float64[]
    list_energies_rᵢ_j = Float64[]

    # Recorre 'temp' una vez y acumula los valores que cumplan la condición.
    for x in temp
        if j - range1 <= x[2] <= j
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
file_name_df = path_SWGO*"/swgo_files/Plots/df_r_vs_E0_binsbar.csv"
#######################################################################################
#df = DataFrame(mean = list_mean_r, std = list_std_r, energies = list_energies_names)
#CSV.write(file_name, df)
#######################################################################################
df = CSV.read(file_name_df, DataFrame);
list_mean_r = df[!,"mean"];
list_std_r = df[!,"std"];
list_energies_names = df[!,"energies"];

labels_energies = [string(i == 1 ? 0 : list_energies_names[i-1]/10^6, "-", list_energies_names[i]/10^6) for i in 1:length(list_energies_names)];

#######################################################################################
bar(
    (0:length(labels_energies)-1), list_mean_r, yerr = list_std_r,
    xlim=(-0.8,length(labels_energies)-0.2),                             #limits of x axis
    ylim=(0,14),                                                           #limits of y axis
    xticks=(0:length(labels_energies),labels_energies) ,                                                        
    yticks=(-3:2:15),

    title="Mean of Core Position",                                         #title
    #label=:"Photon",                                                      # label
    legend=false,      #legendtitle="Primary Particle:", legend =:topright,       
    bar_width=0.6,                                                           # Ancho de las barras
    color=:skyblue,                                                        # bar colour
    gridstyle=:dash, xgrid=false, ygrid=true,                              # GRID
    gridlinewidth=2, gridalpha=0.3,                                        # grid and width

    xlabel="Primary Energy (PeV)",                                         # label of x axis
    ylabel="r (m)",                                                        # label of y axis
    linestyle=:solid, linewidth=1.0,                                       # type of line
    marker=:circle, markercolor=:red, markersize=10,                       # marker and size
    markerstrokecolor=:black, markerstrokewidth=0.5,                       # contour of the marker
    titlefont=font("Times New Roman",10),
    guidefont=font("Times New Roman",10),
    legendfont=font("Times New Roman",10),
    aspect_ratio = 0.3, 
    dpi=500)
# Save the figure
file_name = path_SWGO*"/swgo_files/Plots/r_vs_E0_binsbar.png"
savefig(file_name)