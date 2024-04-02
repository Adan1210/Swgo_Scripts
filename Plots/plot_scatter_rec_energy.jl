using  DataFrames, PyPlot, CSV
##############################################################################################
path_SWGO = dirname(pwd());
#######################################################################################
file_name_df = path_SWGO*"/swgo_files/Plots/df_data_server_2D.csv";
#######################################################################################
df = CSV.read(file_name_df, DataFrame)
true_energy = df[!,"SimEvent_energyTrue"]/1000; #Transform to TeVs
x = df[!,"mc_coreX"];
y = df[!,"mc_coreY"];
#######################################################################################
clf()
# Crear el gráfico de dispersión con barra de energía de color

# Crear la figura y el eje
fig, ax = subplots()

# Scatter plot
sc = ax.scatter(x, y, c=true_energy, cmap="viridis", s=1)

# Configuración de ejes y etiquetas
ax.set_xlabel("X (m)")
ax.set_ylabel("Y (m)")
ax.set_xlim(-20, 20)
ax.set_ylim(-20, 20)
ax.set_xticks(-20:5:20)
ax.set_yticks(-20:5:20)

# Título y configuración de la barra de colores
ax.set_title("Position of the core with initial energy (TeV)")
cbar = colorbar(sc)
cbar.set_label("Energy (TeV)")

# Configuración de la cuadrícula
ax.grid(linestyle="--", linewidth=1, alpha=0.2)

# Configuración de fuentes
ax.title.set_fontname("Times New Roman")
ax.title.set_fontsize(10)
ax.xaxis.label.set_fontname("Times New Roman")
ax.xaxis.label.set_fontsize(10)
ax.yaxis.label.set_fontname("Times New Roman")
ax.yaxis.label.set_fontsize(10)


# Guardar la figura
file_name = path_SWGO * "/swgo_files/Plots/scatter_plot_core_position.png"
savefig(file_name, dpi=500)