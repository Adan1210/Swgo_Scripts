using  UnROOT, DataFrames, Plots,Statistics, Plots, CSV, JSON
##############################################################################################
path_SWGO = dirname(pwd());
###########################################################################################
# Initialice the names of all ROOT Files to work.
path = [];
list_files_values = [["DAT" * lpad(i, 6, '0'), j] for i in 1:4, j in 0:4];
###########################################################################################
#Create the main_list, that list contain the data for work and have the form:
list_positions_rᵢ, range = [],[10^5,10^5,10^6] ;

for i in eachindex(list_files_values)
    # Create the names DAT000001, DAT000002, ...
    DATXXX = list_files_values[i][1]
    YYY    = list_files_values[i][2]

    # Initialize the path
    path = path_SWGO * "/swgo_files/ROOT_rec_Aerie_C/reco-$(DATXXX)_A1_gamma_$(YYY)_50000.root"
    # Initialize the ROOT file
    try
        f = ROOTFile(path)
        mytree = LazyTree(f ,"XCDF",["event.nHit","mc.coreY","mc.delCore","mc.coreX","SimEvent.energyTrue","mc.zenithAngle"])
        main_list = [];

        for Tleaf in mytree
            if Tleaf[1]>=25 && 300>=Tleaf[3]/100 && Tleaf[4]>=0 && π/4>=Tleaf[6] 
                element = [Tleaf[4], Tleaf[5]/100,Tleaf[2]/100] #[Energy, X, y]
                push!(main_list, element)
            end
        end
        append!(list_positions_rᵢ, main_list)
    catch e
    end
end
#######################################################################################
file_name_df = path_SWGO*"/swgo_files/Plots/df_position_core_scatter.csv";
#######################################################################################
#df = DataFrame(positions_rᵢ = list_positions_rᵢ)
#CSV.write(file_name_df, df)

#######################################################################################
df = CSV.read(file_name_df, DataFrame);
string_list_positions_rᵢ = df[!,"positions_rᵢ"];
# Inicializar un array vacío para almacenar los arrays de Float64
list_positions_rᵢ = Array{Float64,1}[];

# Convertir cada string en un array de Float64 y agregarlo al array de arrays
for string in string_list_positions_rᵢ
    push!(list_positions_rᵢ, JSON.parse(string))
end
list_positions_rᵢ
#######################################################################################

true_energy = [arr[1] for arr in list_positions_rᵢ];
x = [arr[2] for arr in list_positions_rᵢ];
y = [arr[3] for arr in list_positions_rᵢ];

# Crear el gráfico de dispersión con barra de energía de color
scatter(x, y, 
    zcolor= true_energy,
    xlabel="X (m)",                                        #label of x axis
    ylabel="Y (m)",                                        #label of y axis
    zlabel="Energy (GeV)",                                 #label of z axis
    #zscale=:log10,
    xlim = (-20,20),
    ylim = (-20,20),

    title="Position of the core with initial energy (GeV)",      #title
    label=:"Position",                                     #label
    legend=:topright,                                      #lengend
    framestyle=:box, gridstyle=:solid,                     #frame
    gridlinewidth=2, gridalpha=0.3,                        #grid and width
    palette = :matter,
    linestyle=:solid, linewidth=1,                         #type of line
    marker=:circle, markersize=2,                          #marker and size
    markerstrokecolor=:black, markerstrokewidth=0.2,       #contour of the marker
    c=reverse(cgrad(:viridis)),
    titlefont=font("Times New Roman",10),
    guidefont=font("Times New Roman",10),
    dpi=500)

# Save the figure
file_name = path_SWGO*"/swgo_files/Plots/position_core_scatter.png";
savefig(file_name);