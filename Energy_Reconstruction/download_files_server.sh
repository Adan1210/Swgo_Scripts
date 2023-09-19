#!/bin/bash
cd ../swgo_files/DATA_Colaboration/
base_url="http://swgo.umd.edu/mcdata/M5/production/A1/gamma"

for i in {1..4000}; do
    for j in {0..4};do
        # Formatear el nombre del archivo con el número adecuado
        file_name=$(printf "hawcsim-DAT%06d_A1_gamma_%d_50000.xcd" $i $j)

        # Construir la URL completa
        full_url="${base_url}/${file_name}"
    
        # Ejecutar el comando curl
        curl --user swgo:austral! "$full_url" --remote-name
    done
done
cd ../../swgo_scripts/
# chmod -R a+rwx ./