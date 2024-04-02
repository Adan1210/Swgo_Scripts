include("../Library/data_analysis.jl")
using .DataAnalysis: create_string_range
using DataFrames, CSV, PyPlot
##############################################################################################
path_SWGO = dirname(pwd());
#######################################################################################
file_name_df = path_SWGO * "/swgo_files/Plots/df_data_server_2D.csv";
df = CSV.read(file_name_df, DataFrame)
#######################################################################################
# Create the main_list, that list contain the data for work and have the form:
list_positions_rᵢ, list_energies, scale = [], [], 10^5;
range1 = scale*[1, 1, 10];
scale_plot = range1[1]/(10^3);
#######################################################################################
clf()
fig, ax = subplots(figsize=(20, 10));  # Puedes especificar el tamaño de la figura con figsize

for j in range1[1]:range1[2]:range1[3]
    # Crear un nuevo DataFrame filtrado en cada iteración
    df_filtered = df[(j - range1[2]) .<= df[!, "SimEvent_energyTrue"] .<= j, :]
    # Crear un boxplot para cada rango de energías
    range_label = create_string_range(scale_plot, j/range1[2]-1) 
    ax[:boxplot](df_filtered[!, :mc_delCore], positions=[j], widths=range1[2]/2, labels=[range_label])
end
# Configurar el título y las etiquetas de los ejes
ax[:set_title]("Core reconstuction by energy", fontsize=25, color="black");
ax[:set_xlabel]("Energy (TeV)", fontsize=20, color="black");
ax[:set_ylabel]("Δr", fontsize=20, color="black");
# Establecer límites para los ejes
ax.set_ylim(0, 35);
ax.set_yticks(0:5:35);
ax.tick_params(axis="x", labelsize=12, labelrotation=0);
ax.tick_params(axis="y", labelsize=12, labelcolor="black");

ax.grid(axis="y",color = "gray", linestyle = "--", linewidth = 0.3);
# Save the figure
file_name = path_SWGO*"/swgo_files/Plots/boxplot_deltaR_vs_energy_10_5.png";
# Guardar el gráfico en un archivo
PyPlot.savefig(file_name)