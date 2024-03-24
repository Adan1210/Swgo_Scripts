using  UnROOT
##############################################################################################
path_SWGO = dirname(pwd())
path = path_SWGO * "/swgo_files/ROOT_rec_Aerie_C/reco-DAT000023_A1_gamma_1_50000.root"
###########################################################################################
f = ROOTFile(path)
# Initialize the ROOT file
mytree = LazyTree(f ,"XCDF")

mytree0= LazyTree(f ,"XCDF",["mc.delCore","event.nHit","rec.LHLatDistFitEnergy","mc.zenithAngle","event.eventID"])

mytree1 = LazyTree(f ,"XCDF",[
    "mc.logGroundEnergy", #1
    "SimEvent.xCoreTrue", #2
    "SimEvent.nMuonParticles", #3
    "SimEvent.energyTrue", #SimEvent.energyTrue(4)
    "SimEvent.yCoreTrue", 
    "mc.coreX", #6
    "SimEvent.sumMuonEnergy", #7
    "mc.delCore", #mc.delCore(8)
    "rec.zenithAngle", #9
    "mc.logEnergy", #11
    "event.nHit", # event.nHit(12)
    "rec.coreX", #13
    "rec.coreY", #14
    "rec.LHLatDistFitEnergy", #15
    "mc.delAngle", #16
    "SimEvent.phiTrue", #17
    "mc.coreY", #18
    "SimEvent.nHadronParticles", #19
    "SimEvent.thetaTrue", #20
    "SimEvent.sumHadronEnergy", #21
    "mc.zenithAngle", #mc.zenithAngle(22)
    "rec.azimuthAngle", #rec.azimuthAngle(23)
    "SimEvent.sumEMEnergy"])# 24

#mytree2 = LazyTree(f ,"XCDF",["event.eventID"])

mytree_name = mytree1

names1 = names(mytree_name);
println(names1);
names2 = [replace(text, "_" => ".") for text in names1];
println(names2)


df = DataFrame(
    mc_logGroundEnergy=Float64[], 
    SimEvent_xCoreTrue=Float64[])

for Tleaf in mytree1
    element = Dict(:mc_logGroundEnergy=>Tleaf[1], :SimEvent_xCoreTrue=>Tleaf[2])
    push!(df, element)
end

df

# Give the names of variables of the files
names1 = names(mytree)
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