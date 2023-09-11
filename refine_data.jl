using UnROOT, Plots, Statistics, DataFrames, CSV

# Create a list for Aerie files for each energy
list_energies = [1000,2500,5000,7500,10000,25000,50000]
for j in list_energies
    eval(Meta.parse("x_$j  = []"))
    eval(Meta.parse("y_$j  = []"))
    eval(Meta.parse("z_$j  = []"))
    eval(Meta.parse("energy_$j  = []"))
end
path        = []
list_x      = []
list_y      = []
list_z      = []
list_energy = []

######################################### Initialize the Files #########################################
for j in list_energies
    for i in 1:100
        path          = "/home/lmorales/swgo/swgo_files/ROOT_Aerie/particle1_$(j)_to_$(j)GeV_0_to_0degrees_A1_Yanque/Aerie_$(i)shower_particle1_$(j)_to_$(j)GeV_0_to_0degrees_A1_Yanque.root"
        path          = eval(Meta.parse("path"))

        x_n           = "x_$j"
        x_n           = eval(Meta.parse(x_n))
        y_n           = "y_$j"
        y_n           = eval(Meta.parse(y_n))
        z_n           = "z_$j"
        z_n           = eval(Meta.parse(z_n))
        energy_n      = "energy_$j"
        energy_n      = eval(Meta.parse(energy_n))

        root_file     = ROOTFile(path)
        x             = collect(LazyTree(root_file ,"XCDF",["HAWCSim.WH.XNE"])[:,1])[1]/100
        y             = collect(LazyTree(root_file ,"XCDF",["HAWCSim.WH.YNE"])[:,1])[1]/100
        z             = collect(LazyTree(root_file ,"XCDF",["HAWCSim.WH.ZNE"])[:,1])[1]/100
        energy        = collect(LazyTree(root_file ,"XCDF",["HAWCSim.WH.Energy"])[:,1])[1]

        push!(x_n, x)
        push!(y_n, y)
        push!(z_n, z)
        push!(energy_n, energy)
    end 
    
    x_n           = "x_$j"
    x_n           = eval(Meta.parse(x_n))
    y_n           = "y_$j"
    y_n           = eval(Meta.parse(y_n))
    z_n           = "z_$j"
    z_n           = eval(Meta.parse(z_n))
    energy_n      = "energy_$j"
    energy_n      = eval(Meta.parse(energy_n))

    push!(list_x, x_n)
    push!(list_y, y_n)
    push!(list_z, z_n)
    push!(list_energy, energy_n)
end


for j in 1:length(list_energies)
    for i in 1:length(list_x[j])
        # Create matrix
        dimension      = length(list_energy[j][i])
        primary_energy = list_energies[j]
        matrix         = hcat(list_x[j][i], list_y[j][i], list_z[j][i], list_energy[j][i], fill(primary_energy,dimension))
        df             = DataFrame(matrix, [:x, :y, :z, :energy_shower, :energy_primary])
        CSV.write("./Matrix_Horna/matrix$(i)_$(primary_energy)GeV.csv", df)
    end
end











for j in 1:length(list_energies)
    matrix1 = []
    for i in 1:length(list_x[j])
        # Create matrix
        matrix = hcat(list_x[j][i], list_y[j][i], list_z[j][i], list_energy[j][i])
        push!(matrix1, matrix)
    end
    push!(list_matrix, matrix1)
end


# Debugging
root_file                = ROOTFile("/home/lmorales/swgo/swgo_files/DATA_Colaboration/ROOT_Aerie/hawcsim-DAT000091_A1_gamma_4_50000.root")

const r = LazyTree(root_file,"XCDF")
names1 = names(r)



collect(LazyTree(root_file ,"XCDF",["HAWCSim.WH.XNE"]))

LazyTree(root_file ,"XCDF",["HAWCSim.PE.origPType"])
x = collect(LazyTree(root_file ,"XCDF",["HAWCSim.WH.XNE"])[:,1])[1]/100
y = collect(LazyTree(root_file ,"XCDF",["HAWCSim.WH.YNE"])[:,1])[1]/100
z = collect(LazyTree(root_file ,"XCDF",["HAWCSim.WH.ZNE"])[:,1])[1]/100
energy = collect(LazyTree(root_file ,"XCDF",["HAWCSim.WH.Energy"])[:,1])[1]

matrix = hcat(listx, listy, listz, list_energy)


parTrackID = collect(LazyTree(root_file ,"XCDF",["HAWCSim.PE.parTrackID"])[:,1])[1]
parPType = collect(LazyTree(root_file ,"XCDF",["HAWCSim.PE.parPType"])[:,1])[1]
energy = collect(LazyTree(root_file ,"XCDF",["HAWCSim.PE.Energy"])[:,1])[1]
