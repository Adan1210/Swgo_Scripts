#!/bin/bash

# Change to the directory where the files will be downloaded
cd /home/lmorales/swgo/swgo_files/ROOT_rec_Aerie_C/

# User credentials
user="swgo"
password="austral!"

# Base URL path
url_base="http://swgo.umd.edu/mcdata/M5/reco/M6_pass3/A1/gamma/root"

# File number range
i_f=4000
j_f=4

# Loop to download the files
for ((i=2; i<=i_f; i++)); do
    for ((j=0; j<=j_f; j++)); do
        # Format the file number with leading zeros and the index
        num_file=$(printf "%06d" $i)
        index_yyy=$j

        # Construct the full URL
        file_name="reco-DAT${num_file}_A1_gamma_${index_yyy}_50000.root"

        # Download the file with curl
        curl --user $user:$password "${url_base}/${file_name}" --remote-name
        # Opcional: descomentar la siguiente línea para pausar entre descargas
        sleep 0.5
    done
done

echo "Download completed."

# Change to the directory where the files will be read
cd /home/lmorales/swgo/Swgo_Scripts/Read_data/