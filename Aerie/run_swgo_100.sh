#enviroment variable pointing to the config folder use by HAWC sim
export HAWCSIM_CONFIG=./config
#Runnin the corsika shower through HAWC sim
hawcsim-exe -i ./input_aerie_CORSIKA/100showers_CORSIKA/100showers_particle1_0_75_yanque_0_CORSIKA/DAT_100showers_particle1_0_75_yanque_0_CORSIKA -o ./output_aerie_XCDF/100showers_aerie/aerie_100showers_particle1_0_75_yanque_0.xcd --otype xcdf
echo "Converting to root file format"
xcdf-root --input ./output_aerie_XCDF/100showers_aerie/aerie_100showers_particle1_0_75_yanque_0.xcd -o ./output_aerie_XCDF/100showers_aerie/aerie_100showers_particle1_0_75_yanque_0.root
echo "Done"

