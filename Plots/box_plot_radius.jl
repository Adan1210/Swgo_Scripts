using DataFrames, CSV, PyPlot
##############################################################################################
path_SWGO = dirname(pwd())
#######################################################################################
# Create the main_list, that list contain the data for work and have the form:
list_positions_rᵢ, list_energies, range1 = [], [], [10^5, 10^5, 10^6]

#######################################################################################
file_name_df_0 = path_SWGO * "/swgo_files/Plots/df_0_r_vs_E0_binsbar.csv"
df_0 = CSV.read(file_name_df_0, DataFrame)

#######################################################################################

fig, ax = subplots(figsize=(15, 10))  # Puedes especificar el tamaño de la figura con figsize

for j in range1[1]:range1[2]:range1[3]
    # Crear un nuevo DataFrame filtrado en cada iteración
    df_filtered = df_0[(j - range1[2]) .<= df_0[!, "energies"] .<= j, :]
    # Crear un boxplot para cada rango de energías
    ax[:boxplot](df_filtered[!, :positions_rᵢ], positions=[j], widths=range1[2]/2, labels=["$(round(j/10^5-1)/10)-$(round(j/10^5)/10)"])
end

# Configurar el título y las etiquetas de los ejes
ax[:set_title]("Core reconstuction by energy", fontsize=16, color="black")
ax[:set_xlabel]("Energy (GeV)", fontsize=14, color="black")
ax[:set_ylabel]("r", fontsize=14, color="black")
# Establecer límites para los ejes
ax.set_ylim(0, 35)
ax.set_yticks(0:5:35)
ax.tick_params(axis="x", labelsize=12, labelrotation=0)
ax.tick_params(axis="y", labelsize=12, labelcolor="black")

ax.grid(axis="y",color = "gray", linestyle = ":", linewidth = 0.3)
# Save the figure
file_name = path_SWGO*"/swgo_files/Plots/r_123.png";
# Guardar el gráfico en un archivo
PyPlot.savefig(file_name)