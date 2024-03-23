using  UnROOT, DataFrames, CSV;
##############################################################################################
path_SWGO = dirname(pwd());
###########################################################################################
# Initialice the names of all ROOT Files to work.
path = [];
list_files_values = [["DAT" * lpad(i, 6, '0'), j] for i in 1:1, j in 0:2];

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

    df = DataFrame(
        mc_logGroundEnergy=Float64[], 
        SimEvent_xCoreTrue=Float64[], 
        SimEvent_nMuonParticles=Int64[], 
        SimEvent_energyTrue=Float64[], 
        SimEvent_yCoreTrue=Float64[], 
        mc_coreX=Float64[], 
        SimEvent_sumMuonEnergy=Float64[], 
        mc_delCore=Float64[],
        rec_zenithAngle=Float64[], 
        event_eventID=Int64[],
        mc_logEnergy=Float64[], 
        event_nHit=Int64[], 
        rec_coreX=Float64[], 
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
            "SimEvent.sumMuonEnergy", 
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

        for Tleaf in mytree
            #if Tleaf[11]>=25 && 300>=Tleaf[8]/100 && Tleaf[4]>=0 && π/4>=Tleaf[21]
            row = (mc_logGroundEnergy=Tleaf[1],
                SimEvent_xCoreTrue=Tleaf[2]/100, 
                SimEvent_nMuonParticles=Tleaf[3], 
                SimEvent_energyTrue=Tleaf[4], 
                SimEvent_yCoreTrue=Tleaf[5]/100, 
                mc_coreX=Tleaf[6]/100, 
                SimEvent_sumMuonEnergy=Tleaf[7], 
                mc_delCore=Tleaf[8]/100, 
                rec_zenithAngle=Tleaf[9],
                event_eventID=Tleaf[10], 
                mc_logEnergy=Tleaf[11], 
                event_nHit=Tleaf[12], 
                rec_coreX=Tleaf[13]/100, 
                rec_coreY=Tleaf[14]/100, 
                rec_LHLatDistFitEnergy=Tleaf[15], 
                mc_delAngle=Tleaf[16], 
                SimEvent_phiTrue=Tleaf[17], 
                mc_coreY=Tleaf[18]/100, 
                SimEvent_nHadronParticles=Tleaf[19], 
                SimEvent_thetaTrue=Tleaf[20], 
                SimEvent_sumHadronEnergy=Tleaf[21], 
                mc_zenithAngle=Tleaf[22], 
                rec_azimuthAngle=Tleaf[23], 
                SimEvent_sumEMEnergy=Tleaf[24])

            push!(df, row, promote=true);
            #end
        end
        # Write the DataFrame to a CSV file
        file_name_df = path_SWGO*"/swgo_files/Plots/CSV_M_L/df_data_server_2D_$(DATXXX)_$(YYY).csv";
        CSV.write(file_name_df, df)
    catch e
    end
end
#######################################################################################


# solo me falta correr con indixe 1 DAT000002 Y VARIA 0-4