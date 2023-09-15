using UnROOT, Plots, Statistics, DataFrames, CSV
#Initialize the Files
for i in 1:2
    DATXXX = "DAT" * lpad(i, 6, '0') # Esto crea una cadena como DAT000001, DAT000002, ...
    
    for YYY in 0:4
        path      = "/home/lmorales/swgo/swgo_files/DATA_Colaboration/ROOT_Aerie/hawcsim-$(DATXXX)_A1_gamma_$(YYY)_50000.root"
        path      = eval(Meta.parse("path"))
        root_file = ROOTFile(path)


    
    end
end









# Debugging
root_file                = ROOTFile("/home/lmorales/swgo/swgo_files/DATA_Colaboration/ROOT_Aerie/hawcsim-DAT000091_A1_gamma_0_50000.root")

mytree = LazyTree(root_file ,"XCDF",["HAWCSim.PE.PMTID", "HAWCSim.PE.Energy", "HAWCSim.Evt.Energy"])

list_pmtID = mytree[:, :HAWCSim_PE_PMTID]
list_pmtID = [ Float64.(sub_array) for sub_array in list_pmtID ]
list_energy = mytree[:, :HAWCSim_PE_Energy]
list_energy = [ Float64.(sub_array) for sub_array in list_energy ]
list_initial_energy = mytree[:, :HAWCSim_Evt_Energy]
list_initial_energy = [ Float64.(sub_array) for sub_array in list_initial_energy ]

list = []
for i in 1:length(list_energy)
    push!(list, [collect(t) for t in zip(list_pmtID[i], list_energy[i])])
end

for i in 1:length(list)
    xd=list[i]
    if !isempty(xd)
        for subvec in xd
            push!(subvec, list_initial_energy[i])  # Usamos 2.0 porque queremos un Float64
        end
    end
end
#Borrar los que no tienen nada
list = [sublista for sublista in list if !isempty(sublista)]

# Filtrar los grupos vacíos
list_filter = [[sublista for sublista in subgrupo if sublista[3] > 50000] for subgrupo in list]
list_filter = filter(!isempty, list_filter)





vars = Dict{String, Int64}()

for i = 1:100
    # Usamos lpad para asegurarnos de tener 6 dígitos
    var_name = "DAT" * lpad(i, 6, '0')
    vars[var_name] = i
end




