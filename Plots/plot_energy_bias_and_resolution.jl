using DataFrames, CSV, Statistics, PyPlot
path_SWGO = dirname(pwd())
file_name_df = path_SWGO * "/swgo_files/Plots/df_data_server_2D.csv"
df = CSV.read(file_name_df, DataFrame)
# Seleccionar solo las columnas necesarias
df_2 = select(df, [:mc_logEnergy, :rec_LHLatDistFitEnergy])
sort!(df_2, :mc_logEnergy)
# Definir los límites de los rangos
bins = collect(range(1.5, stop=6, step=0.5))
list_energies = 10 .^ bins

# Calcular las posiciones de los puntos (en la mitad del ancho de la línea)
point_positions = [10^((bins[i] + bins[i+1]) / 2) for i in 1:(length(bins)-1)]

list_energy_bias = Float64[]
for i in 1:(length(bins)-1)
    df_3 = filter(row -> bins[i+1] > row.mc_logEnergy > bins[i], df_2)
    df_3.resta = df_3.mc_logEnergy .- df_3.rec_LHLatDistFitEnergy
    push!(list_energy_bias, mean(df_3.resta))
end

list_energy_bias

clf()
# Crear el gráfico de puntos en escala logarítmica
scatter(point_positions, list_energy_bias, label="Photon")
xscale("log")  # Establecer la escala logarítmica para el eje x

# Unir los puntos con una línea
plot(point_positions, list_energy_bias, color="black", linestyle="solid")

# Agregar líneas horizontales para los bines
for i in 1:(length(bins)-1)
    plot([list_energies[i], list_energies[i+1]], [list_energy_bias[i], list_energy_bias[i]], color="black", linestyle="solid")
end

# Configurar el resto de parámetros del gráfico
xlim(list_energies[1]/1.3, list_energies[end]*1.3)
ylim(-1, 2)
xticks([10^exp for exp in (1.5:0.5:6)])
yticks(-1:0.5:2)
title("Energy bias for 3556523 showers")
xlabel("Primary Energy (GeV)")
ylabel("Energy bias")
grid(true)
gridalpha=0.3
dpi=500

# Guardar la figura
file_name = path_SWGO * "/swgo_files/Plots/energy_bias.png"
savefig(file_name)


################################ Energy resolution ################################
# Calculate the energy resolution
function calculate_rms(vector)
    squared_values = vector .^ 2
    mean_squared = mean(squared_values)
    rms = sqrt(mean_squared)
    return rms
end

list_resolution = Float64[]
for i in 1:(length(bins)-1)
    df_3 = df_2[bins[i+1] .> df_2.mc_logEnergy .> bins[i], :]
    df_3.resta = df_3.mc_logEnergy .- df_3.rec_LHLatDistFitEnergy
    rest = Array(df_3[!, :resta])
    resolution = calculate_rms(rest)
    push!(list_resolution, resolution)
end
list_resolution

clf()
# Crear el gráfico de puntos en escala logarítmica
scatter(point_positions, list_resolution, label="Photon")
xscale("log")  # Establecer la escala logarítmica para el eje x

# Unir los puntos con una línea
plot(point_positions, list_resolution, color="black", linestyle="solid")

# Agregar líneas horizontales para los bines
for i in 1:(length(bins)-1)
    plot([list_energies[i], list_energies[i+1]], [list_resolution[i], list_resolution[i]], color=:black, linestyle=:solid)
end

# Configurar el resto de parámetros del gráfico
xlim(list_energies[1]/1.3, list_energies[end]*1.3)
ylim(0, 2.5)
xticks([10^exp for exp in (1.5:0.5:6)])
yticks(0:0.5:2.5)
title("Energy resolution for 3556523 showers")
xlabel("Primary Energy (GeV)")
ylabel("Energy resolution")
grid(true)
gridalpha=0.3
dpi=500

# Guardar la figura
file_name = path_SWGO * "/swgo_files/Plots/energy_resolution.png"
savefig(file_name)