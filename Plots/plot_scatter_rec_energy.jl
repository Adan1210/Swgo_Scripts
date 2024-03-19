using  DataFrames, Plots, CSV
##############################################################################################
path_SWGO = dirname(pwd());
#######################################################################################
file_name_df = path_SWGO*"/swgo_files/Plots/df_data_server_2D.csv";
#######################################################################################
df = CSV.read(file_name_df, DataFrame);
true_energy = df[!,"SimEvent_energyTrue"]/1000;
x = df[!,"mc_coreX"];
y = df[!,"mc_coreY"];
#######################################################################################
# Crear el gráfico de dispersión con barra de energía de color
scatter(x, y, 
    zcolor= true_energy,
    xlabel="X (m)",                                        #label of x axis
    ylabel="Y (m)",                                        #label of y axis
    zlabel="Energy (TeV)",                                 #label of z axis
    #zscale=:log10,
    xlim = (-20,20),
    ylim = (-20,20),
    xticks = -20:5:20,
    yticks = -20:5:20,

    title="Position of the core with initial energy (TeV)",      #title
    label=:false,                                     #label of the legend
    legend=:true,                                      #z bar
    gridstyle=:dash, xgrid=true, ygrid=true,                              # GRID
    gridlinewidth=1, gridalpha=0.2,                                        # grid and width
    linestyle=:solid, linewidth=1,                         #type of line;

    marker=:circle, markersize=1,                          #marker and size
    markerstrokecolor=:black, markerstrokewidth=0.2,       #contour of the marker
    c=reverse(cgrad(:viridis)),
    titlefont=font("Times New Roman",10),
    guidefont=font("Times New Roman",10),
    dpi=500)

# Save the figure
file_name = path_SWGO*"/swgo_files/Plots/position_core_scatter.png";
savefig(file_name);