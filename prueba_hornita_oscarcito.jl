# Debugging
root_file                = ROOTFile("/home/lmorales/swgo/swgo_files/DATA_Colaboration/ROOT_Aerie/hawcsim-DAT000091_A1_gamma_0_50000.root")

# Names
const r = LazyTree(root_file,"XCDF")
names1 = names(r)
# Variables
list_pmtID = collect(LazyTree(root_file ,"XCDF",["HAWCSim.PE.PMTID"])[:,1])
size(list_energy[1])
list_pmtID = collect(LazyTree(root_file ,"XCDF",["HAWCSim.PE.PMTID"])[:,1])
list_energy = collect(LazyTree(root_file ,"XCDF",["HAWCSim.PE.Energy"])[:,1])
size(list_pmtID)
length(list_pmtID)
length(list_energy)
list_pmtID = parse(Int, x -> parse(Int, x, base=16), list_pmtID)

list = []
lista = []
for i in 1:length(list_energy)
    forma = size(list_energy[i])
    forma2 = size(list_pmtID[i])
    if forma != (0,)
        push!(lista, [list_energy[i], list_pmtID[i], i])
    end
end

# Crear una lista vacía para almacenar los valores decimales
lista
nueva_lista = []
# Recorrer la lista original y convertir los UInt64 a decimales
i=1
for elemento in lista

    elemento[2]
    elemento_decimal = float(elemento[2])
    lista[i][2]=elemento_decimal
    i=i+1
end

lista
float(lista[1][2])
for elemento in lista
    elemento[2]
    

end


for elemento in lista
    elemento[2]
    float(elemento2)
    for elemento2 in elemento
        nueva_lista2 = []
        if elemento2 isa UInt64
            # Si es un UInt64, lo convertimos a decimal
            elemento_decimal = float(elemento2)
            push!(nueva_lista2, elemento_decimal)
        else
            # Si no es un UInt64, lo agregamos tal como está
            push!(nueva_lista2, elemento2)
        end
        push!(nueva_lista, nueva_lista2)
    end
end
float(UInt64[0x0000000000001bd3, 0x0000000000001bd3, 0x0000000000000301, 0x0000000000000301, 0x0000000000000301, 0x0000000000002a25, 0x0000000000002181, 0x000000000000052d, 0x000000000000052d, 0x000000000000052d, 0x0000000000002d09, 0x0000000000002d09, 0x0000000000002d09, 0x0000000000002d09, 0x0000000000002d09, 0x0000000000002d09, 0x0000000000002d09, 0x0000000000002d09, 0x0000000000002da9, 0x0000000000002da9])
# Imprimir la nueva lista
println(nueva_lista)
nueva_lista
size(lista)
for i in 1:length(list_energy)
    forma = size(list_energy[i])
    forma2 = size(list_pmtID[i])
    if forma != (0,)
       list.append([list_energy[i],list_pmtID[i],i])
       
    end  
    #println(componente)
    #println("La forma del componente es: $forma")
end

list_energy = collect(LazyTree(root_file ,"XCDF",["HAWCSim.PE.Energy"])[:,1])
list_initial_energy = collect(LazyTree(root_file ,"XCDF",["HAWCSim.Evt.Energy"])[:,1])

list_null = []
push!(list_null, list_pmtID)
push!(list_null, list_initial_energy)
push!(list_null, list_energy)


# Guardar el arreglo en el archivo de texto

CSV.write("./Matrix_Horna/HORNITA1.csv", list_pmtID)


list


LazyTree(root_file ,"XCDF",["HAWCSim.PE.origPType"])
x = collect(LazyTree(root_file ,"XCDF",["HAWCSim.WH.XNE"])[:,1])/100
y = collect(LazyTree(root_file ,"XCDF",["HAWCSim.WH.YNE"])[:,1])[1]/100
z = collect(LazyTree(root_file ,"XCDF",["HAWCSim.WH.ZNE"])[:,1])[1]/100
energy = collect(LazyTree(root_file ,"XCDF",["HAWCSim.WH.Energy"])[:,1])[1]

matrix = hcat(listx, listy, listz, list_energy)


parTrackID = collect(LazyTree(root_file ,"XCDF",["HAWCSim.PE.parTrackID"])[:,1])[1]
parPType = collect(LazyTree(root_file ,"XCDF",["HAWCSim.PE.parPType"])[:,1])[1]
energy = collect(LazyTree(root_file ,"XCDF",["HAWCSim.PE.Energy"])[:,1])[12121]