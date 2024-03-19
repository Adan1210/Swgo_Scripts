using  UnROOT, DataFrames, CSV;
##############################################################################################
path_SWGO = dirname(pwd());
###########################################################################################
# Initialice the names of all ROOT Files to work.
path = [];
list_files_values = [["DAT" * lpad(i, 6, '0'), j] for i in 1:4000, j in 0:0];
###########################################################################################
df = DataFrame(mc_logGroundEnergy=Float64[], SimEvent_xCoreTrue=Float64[], SimEvent_nMuonParticles=Int64[], SimEvent_energyTrue=Float64[], SimEvent_yCoreTrue=Float64[], mc_coreX=Float64[], SimEvent_sumMuonEnergy=Float64[], mc_delCore=Float64[], mc_logEnergy=Float64[], event_nHit=Int64[], rec_LHLatDistFitEnergy=Float64[], mc_delAngle=Float64[], mc_coreY=Float64[], SimEvent_nHadronParticles=Int64[], SimEvent_sumHadronEnergy=Float64[], mc_zenithAngle=Float64[], SimEvent_sumEMEnergy=Float64[]);
# mc.delCore: Difference between reconstructed and true core
# SimEvent.energyTrue: Same as mc.logEnergy without Log10(1/GeV)
# rec.LHLatDistFitEnergy: Energy reconstructed by the LHLDF method
# mc.zenithAngle: Zenith angle of the primary particle
# mc.logEnergy: Log10(True Energy/GeV)
# mc.coreX : core X location from CORSIKA in HAWC coordinates in HAWC coordinates
# mc.coreY : core Y location from CORSIKA in HAWC coordinates in HAWC coordinates
# mc.logGroundEnergy: Log10( total energy reaching the ground / GeV )
for i in eachindex(list_files_values)
    # Create the names DAT000001, DAT000002, ...
    DATXXX = list_files_values[i][1]
    YYY    = list_files_values[i][2]

    # Initialize the path
    path = path_SWGO * "/swgo_files/ROOT_rec_Aerie_C/reco-$(DATXXX)_A1_gamma_$(YYY)_50000.root"
    # Initialize the ROOT file
    try
        f = ROOTFile(path)
        mytree = LazyTree(f ,"XCDF",["mc.logGroundEnergy", "SimEvent.xCoreTrue", "SimEvent.nMuonParticles", "SimEvent.energyTrue", "SimEvent.yCoreTrue", "mc.coreX", "SimEvent.sumMuonEnergy", "mc.delCore", "mc.logEnergy", "event.nHit", "rec.LHLatDistFitEnergy", "mc.delAngle", "mc.coreY", "SimEvent.nHadronParticles", "SimEvent.sumHadronEnergy", "mc.zenithAngle", "SimEvent.sumEMEnergy"])

        for Tleaf in mytree
            # event.nHit(10), mc.delCore(11), SimEvent.energyTrue(4), mc.zenithAngle(16)
            if Tleaf[10]>=25 && 300>=Tleaf[11]/100 && Tleaf[4]>=0 && π/4>=Tleaf[16] 
                row = (mc_logGroundEnergy=Tleaf[1], SimEvent_xCoreTrue=Tleaf[2]/100, SimEvent_nMuonParticles=Tleaf[3], SimEvent_energyTrue=Tleaf[4], SimEvent_yCoreTrue=Tleaf[5]/100, mc_coreX=Tleaf[6]/100, SimEvent_sumMuonEnergy=Tleaf[7], mc_delCore=Tleaf[8]/100, mc_logEnergy=Tleaf[9], event_nHit=Tleaf[10], rec_LHLatDistFitEnergy=Tleaf[11], mc_delAngle=Tleaf[12], mc_coreY=Tleaf[13]/100, SimEvent_nHadronParticles=Tleaf[14], SimEvent_sumHadronEnergy=Tleaf[15], mc_zenithAngle=Tleaf[16], SimEvent_sumEMEnergy=Tleaf[17])
                push!(df, row, promote=true);
            end
        end
    catch e
    end
end
#######################################################################################
file_name_df = path_SWGO*"/swgo_files/Plots/df_data_server_2D.csv";
df
#######################################################################################
CSV.write(file_name_df, df)