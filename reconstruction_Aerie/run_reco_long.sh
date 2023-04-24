#run with the extended output (per hit info)
swgo-reco \
--config-file config/config.xml \
--daq-sim-file config/daqsim-config.ini \
--input ./input_reco_XCDF/aerie_100showers_particle1_0_75_yanque_0.xcd --extended -o ./output_reco_XCDF/reclong_aerie_100showers_particle1_0_75_yanque_0.xcd
echo "Converting to root file format"
xcdf-root --input ./output_reco_XCDF/reclong_aerie_100showers_particle1_0_75_yanque_0.xcd -o ./output_reco_XCDF/reclong_aerie_100showers_particle1_0_75_yanque_0.root
echo "Done"