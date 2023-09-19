#!/bin/bash
chmod -R a+rwx ../ &&

for i in {1..4000}; do
    for j in {0..4};do
        # Formatear el nombre del archivo con el número adecuado
        name=$(printf "hawcsim-DAT%06d_A1_gamma_%d_50000" $i $j)
        xcdf_file=".xcd"
        root_file=".root"
        xcdf_name="${name}${xcdf_file}"
        root_name="${name}${root_file}"
        xcdf-root \
        --input ../swgo_files/DATA_Colaboration/"$xcdf_name" \
        -o ../swgo_files/DATA_Colaboration/ROOT_Aerie/"$root_name" &&
        echo "XCDF to ROOT DONE ${i}_${j} shower" &
    done
done

chmod -R a+rwx ../