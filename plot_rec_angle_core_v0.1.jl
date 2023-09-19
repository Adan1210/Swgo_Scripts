using UnROOT, Plots, Statistics
# List of energies for the primary particle
list_energies = [500, 1000, 5000, 10000, 50000]
# Create a list for mc_del_core and mc_del_angle for each energy
for i in list_energies
    eval(Meta.parse("mc_del_core_$i = []"))
    eval(Meta.parse("mc_del_angle_$i = []"))
end
list_mc_del_core = []
list_mc_del_angle = []
# Initialize the path to the ROOT files
path              = []
for j in list_energies
    for i in 10:10:1000
        path               = "./swgo_files/ROOT_rec_Aerie/$(j)_GeV_yanque/$(i-9)_to_$(i)showers_particle1_$(j)GeV_yanque_0degrees_rec_Aerie.root"
        path               = eval(Meta.parse("path"))
        mc_del_core_n      = "mc_del_core_$j"
        mc_del_core_n      = eval(Meta.parse(mc_del_core_n))
        mc_del_angle_n     = "mc_del_angle_$j"
        mc_del_angle_n     = eval(Meta.parse(mc_del_angle_n))
        root_file          = ROOTFile(path)
        mc_del_core        = collect(LazyTree(root_file ,"XCDF",["mc.delCore"])[:,1])          # Difference between reconstructed and true core in meters
        mc_del_angle       = collect(LazyTree(root_file ,"XCDF",["mc.delAngle"])[:,1])*180/π   # Difference between reconstructed and true angle in degrees
        append!(mc_del_core_n, mc_del_core)
        append!(mc_del_angle_n, mc_del_angle)
    end
    mc_del_core_n      = "mc_del_core_$j"
    mc_del_core_n      = eval(Meta.parse(mc_del_core_n))
    mc_del_angle_n     = "mc_del_angle_$j"
    mc_del_angle_n     = eval(Meta.parse(mc_del_angle_n))
    push!(list_mc_del_core, mc_del_core_n)
    push!(list_mc_del_angle, mc_del_angle_n)
end
# Create the labels for the energies plot
energies_label    = [string(round(x / 1000, digits=1)) for x in list_energies]
# Plot mc_del_angle
mean_mc_del_angle = map(mean,list_mc_del_angle)
std_mc_del_angle  = map(std, list_mc_del_angle)

plot(energies_label, mean_mc_del_angle, ylim=(0, 3),
title = "Mean of the difference between reconstructed and true angle", titlefontsize =10,  #title
label =:"Photon", legendtitle ="Primary Particle:", legend =:topright, legendfontsize =10, #options for the lengend
framestyle =:box, gridstyle =:solid, gridlinewidth = 2, gridalpha = 0.2,                   #frame and grid
xlabel="Primary Energy (TeV)", ylabel ="Mean of the difference(°)",                        #options for the axis
xguidefontsize =10, yguidefontsize =10,                                                    #options for the axis
seriestype=:scatter, markershape =:circle, markersize = 4, markerstrokecolor=:auto,        #options for the points
yerr = std_mc_del_angle, linewidth = 1,                                                    #options for the error bars
dpi=500)                                                                                   #resolution for the figure
# Save the figure
file_name = "./swgo_files/swgo_plots/mean_mc_del_angles.png"
savefig(file_name)

# Plot mc_del_core
mean_mc_del_core = map(mean,list_mc_del_core)
std_mc_del_core  = map(std, list_mc_del_core)

plot(energies_label, mean_mc_del_core, ylim=(0, 100), 
title ="Mean of the difference between reconstructed and true core",titlefontsize =10,     #title
label =:"Photon", legendtitle ="Primary Particle:", legend =:topright, legendfontsize =10, #options for the lengend
framestyle =:box, gridstyle =:solid, gridlinewidth = 2, gridalpha = 0.2,                   #frame and grid
xlabel="Primary Energy (TeV)", ylabel ="Mean of the difference(m)",                        #options for the axis
xguidefontsize =10, yguidefontsize =10,                                                    #options for the axis
seriestype=:scatter, markershape =:circle, markersize = 4, markerstrokecolor=:auto,        #options for the points
yerr = std_mc_del_core, linewidth=1,                                                       #options for the error bars
dpi=500)                                                                                   #resolution for the figure
# Save the figure
file_name = "./swgo_files/swgo_plots/mean_mc_del_cores.png"
savefig(file_name)



# See the variables in the ROOT file 
# rec_aerie00 = ROOTFile("./swgo_files/ROOT_rec_Aerie/5000_GeV_yanque/1_to_10showers_particle1_5000GeV_yanque_0degrees_rec_Aerie.root")
# collect(LazyTree(rec_aerie00 ,"XCDF",["srec.nHit"])[:,1])
# mytree00    = LazyTree(rec_aerie00,"XCDF")
# names2      = collect(names(mytree00))
