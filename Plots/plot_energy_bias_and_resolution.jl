using DataFrames, CSV, Statistics, Plots
pyplot()  # Utilizar PyPlot como backend
#######################################################################################

# Valores de energía en escala logarítmica
energias_log = log10.(10 .^ (1:7))

# Valores de energía
energias = [10, 100, 1000, 10000, 100000, 1000000, 10000000]
valores = [10, 15, 20, 25, 30, 35, 40]

# Ancho del bin en la escala logarítmica
ancho_bin_log = 0.5

# Calcular los límites de los bines en la escala logarítmica
limites_bines_log = collect(minimum(energias_log):ancho_bin_log:maximum(energias_log))

# Convertir los límites de los bines de vuelta a la escala original
limites_bines = 10 .^ limites_bines_log

# Calcular el punto medio de cada bin en la escala logarítmica
puntos_medios_log = [(lim_inf + lim_sup) / 2 for (lim_inf, lim_sup) in zip(limites_bines_log, limites_bines_log[2:end])]

# Convertir los puntos medios de vuelta a la escala original
puntos_medios = 10 .^ puntos_medios_log

# Calcular el valor promedio en cada bin
valores_bines = [mean(valores[(energias .>= lim_inf) .& (energias .< lim_sup)]) for (lim_inf, lim_sup) in zip(limites_bines, limites_bines[2:end])]

gr()
# Crear el gráfico de puntos en escala logarítmica
scatter(puntos_medios, valores_bines, marker=:circle, label="Valor promedio", legend=:topleft, xscale=:log10)

# Agregar líneas horizontales con "2 rayitas" al inicio y al final
for (i, valor) in enumerate(valores_bines)
    plot!([limites_bines[i], limites_bines[i+1]], [valor, valor], color=:black, linewidth=2, line=:solid, legend=false)
end

xlabel!("Energía")
ylabel!("Valor promedio")
title!("Valores promedio en bines de energía")

# Mostrar el gráfico final
plot!()






using DataFrames, CSV, Statistics, Plots
pyplot()  # Usar PyPlot como backend

path_SWGO = dirname(pwd())
file_name_df = path_SWGO * "/swgo_files/Plots/df_data_server_2D.csv"
df = CSV.read(file_name_df, DataFrame)
sort!(df, :mc_logEnergy)

# Seleccionar solo las columnas necesarias
df_2 = select(df, [:mc_logEnergy, :rec_LHLatDistFitEnergy])

# Definir los límites de los rangos
bins = collect(range(1.5, stop=6, step=0.25))
list_energies = 10 .^ bins
list_energy_bias = Float64[]

for i in 1:(length(bins)-1)
    df_3 = filter(row -> bins[i+1] > row.mc_logEnergy > bins[i], df_2)
    df_3.resta = df_3.mc_logEnergy .- df_3.rec_LHLatDistFitEnergy
    push!(list_energy_bias, mean(df_3.resta))
end

# Crear el gráfico de puntos en escala logarítmica
scatter(list_energies[1:18], list_energy_bias, xaxis=:log, label=:"Photon")

# Agregar líneas horizontales para los bines
for i in 1:(length(bins)-1)
    plot!([list_energies[i], list_energies[i+1]], [list_energy_bias[i], list_energy_bias[i]], color=:black, linestyle=:solid)
end

# Configurar el resto de parámetros del gráfico
plot!(
    xlim=(list_energies[1]/1.3, list_energies[end]*2),
    ylim=(-1, 3),
    xticks=[10^exp for exp in (1.5:0.5:6)],
    yticks=(-1:0.5:3),
    title="Energy bias for 1000 showers",
    legend=:topright,
    xlabel="Primary Energy (GeV)",
    ylabel="Energy bias",
    frame=:box,
    grid=:true,
    gridalpha=0.3,
    dpi=500
)

# Guardar la figura
file_name = path_SWGO * "/swgo_files/Plots/energy_bias222.png"
savefig(file_name)


















using DataFrames, CSV, Statistics, Plots


path_SWGO = dirname(pwd())
file_name_df = path_SWGO * "/swgo_files/Plots/df_data_server_2D.csv"
df = CSV.read(file_name_df, DataFrame);
sort!(df, :mc_logEnergy)
#######################################################################################
# Seleccionar solo las columnas necesarias
df_2 = df[:, ["mc_logEnergy", "rec_LHLatDistFitEnergy"]]

# Definir los límites de los rangos
bins = collect(range(1.5, stop = 6, step = 0.25));
list_energies = [10^exp for exp in bins];
list_energy_bias = Float64[];

df_3 = df_2[bins[2] .> df_2.mc_logEnergy .> bins[1], :]

for i in 1:(length(bins)-1)
    df_3 = df_2[bins[i+1] .> df_2.mc_logEnergy .> bins[i], :]
    df_3.resta = df_3.mc_logEnergy .- df_3.rec_LHLatDistFitEnergy
    push!(list_energy_bias, mean(df_3.resta))
end

################################### Plot Energy bias ###################################
# Calculate the energy bias

# Plot
plot(
    list_energies[1:18], xaxis=:log, 
    list_energy_bias,
    xlim=(list_energies/1.3, list_energies*2),              #limits of x axis
    ylim=(-1,3),
    xticks=[10^exp for exp in (1.5:0.5:6)],
    yticks=(-1:0.5:3),                                     #limits of y axis
    title="Energy bias for 1000 showers",                          #title
    label=:"Photon",                                               #label
    legendtitle="Primary Particle:", legend=:topright,             #lengend
    framestyle=:box, gridstyle=:solid,                             #frame
    gridlinewidth=2, gridalpha=0.3,                                #grid and width
    xlabel="Primary Energy (GeV)",                                 #label of x axis
    ylabel="Energy bias",                                          #label of y axis
    linestyle=:solid, linewidth=1.5,                               #type of line
    marker=:circle, markercolor=:red, markersize=3,                #marker and size
    markerstrokecolor=:black, markerstrokewidth=0.5,               #contour of the marker
    titlefont=font("Times New Roman",10),
    guidefont=font("Times New Roman",10),
    legendfont=font("Times New Roman",10),
    dpi=500)                                                                  #resolution for the figure
# Save the figure
file_name = path_SWGO*"/swgo_files/Plots/energy_bias.png"
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
    energy_bias = calculate_rms(rest)
    push!(list_resolution, energy_bias)
end
list_resolution

# Plot
plot(
    list_energies[1:18], xaxis=:log, 
    list_resolution, 
    xlim=(list_energies[1]/1.3,list_energies[end]*1.3),                    #limits of x axis
    ylim=(0,3),                     #limits of y axis
    xticks=[10^exp for exp in (1.5:0.5:6)],
    yticks=(0:0.50:3),
    title="Energy resolution for 1000 showers",                            #title
    label=:"Photon",                                                       #label
    legendtitle="Primary Particle:", legend =:topright,                    #lengend
    framestyle=:box, gridstyle=:solid,                                     #frame
    gridlinewidth=2, gridalpha=0.3,                                        #grid and width
    xlabel="Primary Energy (GeV)",                                         #label of x axis
    ylabel="Energy resolution",                                            #label of y axis
    linestyle=:solid, linewidth=1.5,                                       #type of line
    marker=:circle, markercolor=:red, markersize=3,                        #marker and size
    markerstrokecolor=:black, markerstrokewidth=0.5,                       #contour of the marker
    titlefont=font("Times New Roman",10),
    guidefont=font("Times New Roman",10),
    legendfont=font("Times New Roman",10),
    dpi=500)                                                                                     #resolution for the figure
# Save the figure
file_name = path_SWGO*"/swgo_files/Plots/energy_resolution.png"
savefig(file_name)