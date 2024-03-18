
# Crear un histograma 2D que funcione como un mapa de calor
heatmap(randn(10,10), color=:viridis, colorbar=true)
randn(10,10)
using  UnROOT, DataFrames, Plots,Statistics, Plots, CSV, JSON
##############################################################################################
path_SWGO = dirname(pwd());
###########################################################################################
# Initialice the names of all ROOT Files to work.
path = [];
list_files_values = [["DAT" * lpad(i, 6, '0'), j] for i in 1:4, j in 0:4];
###########################################################################################
#Create the main_list, that list contain the data for work and have the form:
list_positions_rᵢ, range = [],[10^5,10^5,10^6] ;
for i in eachindex(list_files_values)
    # Create the names DAT000001, DAT000002, ...
    DATXXX = list_files_values[i][1]
    YYY    = list_files_values[i][2]

    # Initialize the path
    path = path_SWGO * "/swgo_files/ROOT_rec_Aerie_C/reco-$(DATXXX)_A1_gamma_$(YYY)_50000.root"
    # Initialize the ROOT file
    try
        f = ROOTFile(path)
        mytree = LazyTree(f ,"XCDF",["event.nHit","mc.delCore","SimEvent.energyTrue","rec.LHLatDistFitEnergy","mc.zenithAngle","mc.logEnergy"])
        main_list = [];

        for Tleaf in mytree
            if Tleaf[1]>=25 && 300>=Tleaf[2]/100 && Tleaf[3]>=0 && π/4>=Tleaf[5] 
                element = [Tleaf[3], Tleaf[4],Tleaf[6]] #[Energy, X, y]
                push!(main_list, element)
            end
        end
        append!(list_positions_rᵢ, main_list)
    catch e
    end
end
true_energy = [arr[1] for arr in list_positions_rᵢ]
true_log_energy = [arr[2] for arr in list_positions_rᵢ]
rec_log_energy = [arr[3] for arr in list_positions_rᵢ]




# Tus datos de ejemplo, necesitas reemplazar estos con tus datos reales
E_true = rand(10:100, 1000)  # Energías verdaderas aleatorias
E_reco = E_true .* (1 .+ (rand(1000) .- 0.5) / 10)  # Energías reconstruidas con un pequeño error

# Calcular los logaritmos necesarios para los ejes x e y
log_E_true = log10.(E_true)
log_ratio = log10.(E_reco ./ E_true)

# Crear un histograma 2D que funcione como un mapa de calor
heatmap(log_E_true, log_ratio, bins=(50,50), color=:viridis, colorbar=true)















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

