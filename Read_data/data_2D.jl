using  UnROOT, DataFrames, CSV;
##############################################################################################
path_SWGO = dirname(pwd());
###########################################################################################
# Initialice the names of all ROOT Files to work.
path = [];
list_files_values = [["DAT" * lpad(i, 6, '0'), j] for i in 1:1, j in 0:4];
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
    rec_zenithAngle=Float64[], 
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
            "SimEvent.nMuonParticles", 
            "SimEvent.energyTrue", #SimEvent.energyTrue(4)
            "SimEvent.yCoreTrue", 
            "mc.coreX", #6
            "SimEvent.sumMuonEnergy", 
            "mc.delCore", #mc.delCore(8)
            "rec.zenithAngle", #9
            "mc.logEnergy", #10
            "event.nHit", # event.nHit(11)
            "rec.coreX", #12
            "rec.coreY", #13
            "rec.LHLatDistFitEnergy", 
            "mc.delAngle", 
            "SimEvent.phiTrue", #16
            "mc.coreY", 
            "SimEvent.nHadronParticles", #18
            "SimEvent.thetaTrue", 
            "SimEvent.sumHadronEnergy", 
            "mc.zenithAngle", #mc.zenithAngle(21)
            "rec.azimuthAngle", 
            "SimEvent.sumEMEnergy"])# 23

        for Tleaf in mytree
            if Tleaf[11]>=25 && 300>=Tleaf[8]/100 && Tleaf[4]>=0 && π/4>=Tleaf[21]
                row = (mc_logGroundEnergy=Tleaf[1],
                    SimEvent_xCoreTrue=Tleaf[2]/100, 
                    SimEvent_nMuonParticles=Tleaf[3], 
                    SimEvent_energyTrue=Tleaf[4], 
                    SimEvent_yCoreTrue=Tleaf[5]/100, 
                    mc_coreX=Tleaf[6]/100, 
                    SimEvent_sumMuonEnergy=Tleaf[7], 
                    mc_delCore=Tleaf[8]/100, 
                    rec_zenithAngle=Tleaf[9], 
                    mc_logEnergy=Tleaf[10], 
                    event_nHit=Tleaf[11], 
                    rec_coreX=Tleaf[12]/100, 
                    rec_coreY=Tleaf[13]/100, 
                    rec_LHLatDistFitEnergy=Tleaf[14], 
                    mc_delAngle=Tleaf[15], 
                    SimEvent_phiTrue=Tleaf[16], 
                    mc_coreY=Tleaf[17]/100, 
                    SimEvent_nHadronParticles=Tleaf[18], 
                    SimEvent_thetaTrue=Tleaf[19], 
                    SimEvent_sumHadronEnergy=Tleaf[20], 
                    mc_zenithAngle=Tleaf[21], 
                    rec_azimuthAngle=Tleaf[22], 
                    SimEvent_sumEMEnergy=Tleaf[23])

                push!(df, row, promote=true);
            end
        end

    catch e
    end
end
#######################################################################################
file_name_df = path_SWGO*"/swgo_files/Plots/CSV_M_L/df_data_server_2D_$(DATXXX)_$(YYY).csv";
df2
#######################################################################################
CSV.write(file_name_df, df2)

df3=sort(df2, :event_eventID)













using  UnROOT, DataFrames, CSV;
##############################################################################################
path_SWGO = dirname(pwd());
###########################################################################################
# Initialice the names of all ROOT Files to work.
path = [];
list_files_values = [["DAT" * lpad(i, 6, '0'), j] for i in 1:4, j in 0:4];
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
    rec_zenithAngle=Float64[], 
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
    SimEvent_sumEMEnergy=Float64[]
    )
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

    try
        f = ROOTFile(path)

        mytree = LazyTree(f ,"XCDF",[
            "mc.logGroundEnergy", 
            "SimEvent.xCoreTrue", 
            "SimEvent.nMuonParticles", 
            "SimEvent.energyTrue", 
            "SimEvent.yCoreTrue", 
            "mc.coreX", 
            "SimEvent.sumMuonEnergy", 
            "mc.delCore", 
            "rec.zenithAngle", 
            "mc.logEnergy", 
            "event.nHit", 
            "rec.coreX", 
            "rec.coreY", 
            "rec.LHLatDistFitEnergy", 
            "mc.delAngle", 
            "SimEvent.phiTrue", 
            "mc.coreY", 
            "SimEvent.nHadronParticles", 
            "SimEvent.thetaTrue", 
            "SimEvent.sumHadronEnergy", 
            "mc.zenithAngle", 
            "rec.azimuthAngle", 
            "SimEvent.sumEMEnergy"
            ])

        for Tleaf in mytree
            row = Dict(
                :mc_logGroundEnergy=>Tleaf[1], 
                :SimEvent_xCoreTrue=>Tleaf[2]/100, 
                :SimEvent_nMuonParticles=>Tleaf[3], 
                :SimEvent_energyTrue=>Tleaf[4], 
                :SimEvent_yCoreTrue=>Tleaf[5]/100, 
                :mc_coreX=>Tleaf[6]/100, 
                :SimEvent_sumMuonEnergy=>Tleaf[7], 
                :mc_delCore=>Tleaf[8]/100, 
                :rec_zenithAngle=>Tleaf[9], 
                :mc_logEnergy=>Tleaf[10], 
                :event_nHit=>Tleaf[11], 
                :rec_coreX=>Tleaf[12]/100, 
                :rec_coreY=>Tleaf[13]/100, 
                :rec_LHLatDistFitEnergy=>Tleaf[14], 
                :mc_delAngle=>Tleaf[15], 
                :SimEvent_phiTrue=>Tleaf[16], 
                :mc_coreY=>Tleaf[17]/100, 
                :SimEvent_nHadronParticles=>Tleaf[18], 
                :SimEvent_thetaTrue=>Tleaf[19], 
                :SimEvent_sumHadronEnergy=>Tleaf[20], 
                :mc_zenithAngle=>Tleaf[21], 
                :rec_azimuthAngle=>Tleaf[22], 
                :SimEvent_sumEMEnergy=>Tleaf[23]
                )
            push!(df, row, promote=true)
        end

    catch e
    end
end
#######################################################################################
# Write the DataFrame to a CSV file
file_name_df = path_SWGO*"/swgo_files/Plots/df_data_server_2D.csv"
CSV.write(file_name_df, df)