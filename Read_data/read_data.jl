using  UnROOT
##############################################################################################
path_SWGO = dirname(pwd())
path = path_SWGO * "/swgo_files/ee.root"
###########################################################################################
f = ROOTFile(path)
# Initialize the ROOT file
mytree = LazyTree(f ,"XCDF",["event.nHit","mc.delCore","SimEvent.energyTrue","rec.LHLatDistFitEnergy","mc.zenithAngle","mc.logEnergy"])
main_list = [];
for Tleaf in mytree
    if Tleaf[1]>=25 && 300>=Tleaf[2]/100 && Tleaf[3]>=0 && π/4>=Tleaf[5]
    element = [Tleaf[1], Tleaf[2]/100, Tleaf[3], Tleaf[4], Tleaf[5]]
    push!(main_list, element)
    end
end
main_list

# Give the names of variables of the files
names1 = names(LazyTree(f, "XCDF"))
names1
###########################################################################################

using CSV
CSV.write("names_variables.csv", DataFrame(Column1=names1), header=false)


Int64.(1.4136532e6)
Float64(1.4136532e6)/100
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