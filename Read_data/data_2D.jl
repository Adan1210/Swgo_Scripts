using  UnROOT, DataFrames, CSV;
##############################################################################################
path_SWGO = dirname(pwd());
###########################################################################################
# Initialice the names of all ROOT Files to work.
list_files_values = [["DAT" * lpad(i, 6, '0'), j] for i in 1:1, j in 0:1];
###########################################################################################
df = DataFrame(
    mc_logGroundEnergy=Float64[], 
    SimEvent_xCoreTrue=Float64[], 
    SimEvent_nMuonParticles=Int64[], 
    SimEvent_energyTrue=Float64[], 
    SimEvent_yCoreTrue=Float64[], 
    mc_coreX=Float64[], 
    SimEvent_sumMuonEnergy=Float64[], 
    mc_delCore=Float64[],
    event_eventID=Int64[],
    rec_zenithAngle=Float64[], 
    mc_logEnergy=Float64[], 
    event_nHit=Int64[], 
    rec_coreX=Float64[],
    mc_coreR=Float64[],
    rec_coreY=Float64[], 
    rec_LHLatDistFitEnergy=Float64[], 
    mc_delAngle=Float64[], 
    SimEvent_phiTrue=Float64[], 
    mc_coreY=Float64[], 
    SimEvent_nHadronParticles=Int64[], 
    SimEvent_thetaTrue=Float64[], 
    SimEvent_sumHadronEnergy=Float64[], 
    mc_zenithAngle=Float64[], 
    rec_azimuthAngle=Float64[], 
    SimEvent_sumEMEnergy=Float64[]);
###########################################################################################
    
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

        mytree = LazyTree(f ,"XCDF",[
            "mc.logGroundEnergy", #1
            "SimEvent.xCoreTrue", #2
            "SimEvent.nMuonParticles", #3
            "SimEvent.energyTrue", #SimEvent.energyTrue(4)
            "SimEvent.yCoreTrue", 
            "mc.coreX", #6
            "SimEvent.sumMuonEnergy", #7
            "mc.delCore", #mc.delCore(8)
            "event.eventID", #9
            "rec.zenithAngle", #10
            "mc.logEnergy", #11
            "event.nHit", # event.nHit(12)
            "rec.coreX", #13
            "mc.coreR", #14
            "rec.coreY", #15
            "rec.LHLatDistFitEnergy", #16
            "mc.delAngle", #17
            "SimEvent.phiTrue", #18
            "mc.coreY", #19
            "SimEvent.nHadronParticles", #20
            "SimEvent.thetaTrue", #21
            "SimEvent.sumHadronEnergy", #22
            "mc.zenithAngle", #mc.zenithAngle(23)
            "rec.azimuthAngle", #rec.azimuthAngle(24)
            "SimEvent.sumEMEnergy" #25
            ])

        for Tleaf in mytree
            if Tleaf[12]>=25 && 300>=Tleaf[14]/100 && Tleaf[4]>=0 && π/4>=Tleaf[23]
                row = (
                    mc_logGroundEnergy=Tleaf[1],
                    SimEvent_xCoreTrue=Tleaf[2]/100, 
                    SimEvent_nMuonParticles=Tleaf[3], 
                    SimEvent_energyTrue=Tleaf[4], 
                    SimEvent_yCoreTrue=Tleaf[5]/100, 
                    mc_coreX=Tleaf[6]/100, 
                    SimEvent_sumMuonEnergy=Tleaf[7], 
                    mc_delCore=Tleaf[8]/100, 
                    event_eventID=Tleaf[9],
                    rec_zenithAngle=Tleaf[10], 
                    mc_logEnergy=Tleaf[11], 
                    event_nHit=Tleaf[12], 
                    rec_coreX=Tleaf[13]/100,
                    mc_coreR=Tleaf[14]/100, 
                    rec_coreY=Tleaf[15]/100, 
                    rec_LHLatDistFitEnergy=Tleaf[16], 
                    mc_delAngle=Tleaf[17], 
                    SimEvent_phiTrue=Tleaf[18], 
                    mc_coreY=Tleaf[19]/100, 
                    SimEvent_nHadronParticles=Tleaf[20], 
                    SimEvent_thetaTrue=Tleaf[21], 
                    SimEvent_sumHadronEnergy=Tleaf[22], 
                    mc_zenithAngle=Tleaf[23], 
                    rec_azimuthAngle=Tleaf[24], 
                    SimEvent_sumEMEnergy=Tleaf[25]
                )

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
sort(df, :event_eventID)

select(df, [:event_eventID])
