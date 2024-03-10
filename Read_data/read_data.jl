using  UnROOT, DataFrames, Base.Threads, Plots, Base.Filesystem
##############################################################################################
path_SWGO = dirname(pwd())
##############################################################################################
# # Files doesn't work
# path_filter = path_SWGO * "/swgo_files/ROOT_Aerie_C/missing_files.txt";  # Reemplaza esto con la ruta real
# excluded_pairs = Set();
# open(path_filter, "r") do file
#     for line in eachline(file)
#         i, j = parse.(Int, split(line))
#         push!(excluded_pairs, (i, j))
#     end
# end
###########################################################################################
# Initialice the names of all ROOT Files to work.
path = [];
excluded_pairs = Set();
list_files_values = [["DAT" * lpad(i, 6, '0'), j] for i in 1:1, j in 0:4 if !((i, j) in excluded_pairs)]; 
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
    f = ROOTFile(path)
    mytree = LazyTree(f ,"XCDF",["event.hit.time","rec.coreX", "rec.coreY"])
    main_list = [];

    for Tleaf in mytree
        element = [Tleaf[2]/100, Tleaf[3]/100]
        push!(main_list, element)
    end

    append!(list_positions_rᵢ, main_list)
end

list_positions_rᵢ


#######################################################################################
using Optim

function Sᵢ(A, σ, x, xᵢ, N, Rₘ)
    return A / (2 * π * σ^2) * exp(-((x - xᵢ)^2 / (2 * σ^2))) + N / ((0.5 + abs(x - xᵢ) / Rₘ)^3)
end

Rₘ=120
N=5*10^-5
σ=10
xᵢ=list_positions_rᵢ[10][1][1][1]

# Definimos la función objetivo, que depende solo de las variables que queremos optimizar
function objective_function(params)
    A, x = params
    Sᵢ(A, σ, x, xᵢ, N, Rₘ)
end

# Establecemos un punto de partida para la optimización
initial_guess = [1.0, 1.0];

# Realizamos la optimización utilizando el descenso de gradiente
result = optimize(objective_function, initial_guess, LBFGS());

# Obtenemos los valores que minimizan la función
optimal_params = Optim.minimizer(result);

println("El valor óptimo de A es: ", optimal_params[1])
println("El valor óptimo de x es: ", optimal_params[2])

















######################## SEE THE Variables of one file ########################################
###########################################################################################
#Create the main_list, that list contain the data for work and have the form:

# Initialize the path
path = path_SWGO * "/swgo_files/ee.root"
f = ROOTFile(path)


# Initialize the ROOT file
mytree = LazyTree(f ,"XCDF",["event.nHit","mc.delCore","SimEvent.energyTrue","mc.zenithAngle"])
mytree2 = LazyTree(f ,"XCDF",["mc.delCore","SimEvent.energyTrue"])
main_list = [];
for Tleaf in mytree
    if Tleaf[1]>=25 && 300>=Tleaf[2]/100>=0 && Tleaf[3]>=0 && Tleaf[4] <= π/4
    element = [Tleaf[1], Tleaf[2]/100, Tleaf[3], Tleaf[4]]
    push!(main_list, element)
    end
end
main_list






# Give the names of variables of the files
names1 = names(LazyTree(f, "XCDF"))
names1[98]


main_list
###########################################################################################



using CSV
CSV.write("names_variables.csv", DataFrame(Column1=names1), header=false)


Int64.(1.4136532e6)
Float64(1.4136532e6)/100