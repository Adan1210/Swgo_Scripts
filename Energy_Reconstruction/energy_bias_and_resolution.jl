using UnROOT, Plots, Statistics, DataFrames, CSV
# List of energies for the primary particle
list_energies = [1000,2500,5000,7500,10000,25000,50000]
# Create a list for rec_LHLatDistFitEnergy for each energy
for j in list_energies
    eval(Meta.parse("log10_rec_energy_$j  = []"))
    eval(Meta.parse("log10_prim_energy_$j = []"))
end
path                  = []
list_log10_rec_energy = []
list_log10_prim_energy= []
list_prim_energy=[]
list_rec_energy= []

############################################################ Initialize the Rec Files ############################################################
for j in list_energies
    for i in 1:100
        path                     = "/home/lmorales/swgo/swgo_files/ROOT_rec_LHLatDistFit_Aerie/particle1_$(j)_to_$(j)GeV_0_to_0degrees_A1_Yanque/rec_energy_Aerie_$(i)shower_particle1_$(j)_to_$(j)GeV_0_to_0degrees_A1_Yanque.root"
        path                     = eval(Meta.parse("path"))

        log10_prim_energy_n      = "log10_prim_energy_$j"
        log10_prim_energy_n      = eval(Meta.parse(log10_prim_energy_n))
        log10_rec_energy_n       = "log10_rec_energy_$j"
        log10_rec_energy_n       = eval(Meta.parse(log10_rec_energy_n))

        root_file                = ROOTFile(path)
        log10_prim_energy        = collect(LazyTree(root_file ,"XCDF",["mc.logEnergy"])[:,1])
        log10_rec_energy         = collect(LazyTree(root_file ,"XCDF",["rec.LHLatDistFitEnergy"])[:,1])

        append!(log10_prim_energy_n, log10_prim_energy)
        append!(log10_rec_energy_n,  log10_rec_energy)

    end

    log10_prim_energy_n      = "log10_prim_energy_$j"
    log10_prim_energy_n      = eval(Meta.parse(log10_prim_energy_n))    
    log10_rec_energy_n       = "log10_rec_energy_$j"
    log10_rec_energy_n       = eval(Meta.parse(log10_rec_energy_n))

    push!(list_log10_prim_energy, log10_prim_energy_n)
    push!(list_log10_rec_energy , log10_rec_energy_n)
end

for j in 1:length(list_energies)
    # Ordenar el arreglo según el primer valor del subarreglo en orden ascendente
    temp_combined_arr = collect(zip(list_log10_prim_energy[j], list_log10_rec_energy[j]))
    temp_sorted_arr   = sort(temp_combined_arr, by=x->x[1])
    list_log10_prim_energy[j] = [subarr[1] for subarr in temp_sorted_arr]
    list_log10_rec_energy[j]  = [subarr[2] for subarr in temp_sorted_arr]

    push!(list_prim_energy, 10 .^(list_log10_prim_energy[j]))
    push!(list_rec_energy , 10 .^(list_log10_rec_energy[j]))
end


############################################################ Plot Energy bias ############################################################
# Calculate the energy bias
list_energy_bias   = map(mean,[list_log10_prim_energy[x] .- list_log10_rec_energy[x] for x in collect(1:length(list_log10_rec_energy))])

# Plot size
font = Plots.font("Times New Roman",10)
# Plot
plot(
    list_energies, xaxis=:log, 
    list_energy_bias,
    xlim=(minimum(list_energies)[1]/1.3,maximum(list_energies)[end]*1.3),              #limits of x axis
    ylim=(-0.40,0.40),
    xticks=[10^exp for exp in (3:1:4)],
    yticks=(-0.40:0.20:0.40),                                     #limits of y axis
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
    titlefont=font,
    guidefont=font,
    legendfont=font,
    dpi=500)                                                                  #resolution for the figure
# Save the figure
file_name = "/home/lmorales/swgo/swgo_scripts/swgo_plots/energy_bias.svg"
savefig(file_name)


############################################################ Energy resolution ############################################################
# Calculate the energy resolution
function calculate_rms(vector)
    squared_values = vector .^ 2
    mean_squared = mean(squared_values)
    rms = sqrt(mean_squared)
    return rms
end
list_energy_resolution = map(calculate_rms,[list_log10_prim_energy[x] .- list_log10_rec_energy[x] for x in collect(1:length(list_log10_rec_energy))])
# Plot size
font = Plots.font("Times New Roman",10)
# Plot
plot(
    list_energies, xaxis=:log, 
    list_energy_resolution, 
    xlim=(list_energies[1]/1.3,list_energies[end]*1.3),                    #limits of x axis
    ylim=(0,0.30),                     #limits of y axis
    xticks=[10^exp for exp in (3:1:4)],
    yticks=(0:0.10:0.30),
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
    titlefont=font,
    guidefont=font,
    legendfont=font,
    dpi=500)                                                                                     #resolution for the figure
# Save the figure
file_name = "/home/lmorales/swgo/swgo_scripts/swgo_plots/energy_resolution.svg"
savefig(file_name)