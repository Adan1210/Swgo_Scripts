using UnROOT, Plots, Statistics, DataFrames, CSV
#Initialize the Files
path = [];
list_energies_total = [];
for i in 1:4000
    DATXXX = "DAT" * lpad(i, 6, '0') # Create the names DAT000001, DAT000002, ...
    for YYY in 0:4
        # Initialize the path
        path      = "/home/lmorales/swgo/swgo_files/DATA_Colaboration/ROOT_Aerie/hawcsim-$(DATXXX)_A1_gamma_$(YYY)_50000.root"
        path      = eval(Meta.parse("path"))
        # Initialize the ROOT file
        root_file = ROOTFile(path)
        mytree    = LazyTree(root_file ,"XCDF",["HAWCSim.PE.PMTID", "HAWCSim.PE.Energy", "HAWCSim.Evt.Energy"])
        #Initialize the lists
        list_pmtID          = [ Float64.(sub_array) for sub_array in mytree[:, :HAWCSim_PE_PMTID] ]
        list_energy         = [ Float64.(sub_array) for sub_array in mytree[:, :HAWCSim_PE_Energy] ]
        list_initial_energy = [ Float64.(sub_array) for sub_array in mytree[:, :HAWCSim_Evt_Energy] ]
        # Initialize the list of showers
        list_showers = []
        # Initialize the list of showers with the PMT ID and the initial energy
        for i in 1:length(list_energy)
            push!(list_showers, [collect(t) for t in zip(list_pmtID[i], list_energy[i])])
        end
        # Add the initial energy to each shower
        for i in 1:length(list_showers)
            xd=list_showers[i]
            if !isempty(xd)
                for subvec in xd
                    push!(subvec, list_initial_energy[i])
                end
            end
        end
        # Delete the empty showers
        list_showers = [sublist for sublist in list_showers if !isempty(sublist)]
        # Filter for initial energy
        list_filter = [[sublist2 for sublist2 in sublist3 if sublist2[3] > 10000] for sublist3 in list_showers]
        list_showers = filter(!isempty, list_filter)
        append!(list_energies_total, list_showers)
    end
end
list_energies_total