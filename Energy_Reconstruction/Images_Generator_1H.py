# Primer generador
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Charge dataframe form .CSV
file_path = '/home/rhorna/shower/Swgo_Scripts/data_hornita.csv'
df=pd.read_csv(file_path,delimiter = ",")
nan_counts = df.isna().sum()
print(nan_counts)
# Drop rows with NaN values in-place
df.dropna(inplace=True)

#Selecting columns
matrix = df.values
df2 =df[['x', 'y','Detected_Energy','Shower_Initial_Energy']]
matrix = df2.values

unique_numbers = df['Shower_Initial_Energy'].unique()

# Create a dictionary to store matrices for each unique number
matrices = {}

print('GA')
# Loop through unique numbers and create matrices
for number in unique_numbers:
    subset_df = df[df['Shower_Initial_Energy'] == number]
    matrices[number] = subset_df[['x', 'y','Detected_Energy']].values

####################################################################
# IMAGE GENERATION FUNCTION 
def shower100(matrix,q):
    
    zeros = np.zeros((600,600))
    col_1= matrix[:,0]//1
    col_2= matrix[:,1]//1
    nmatrix = np.transpose(np.array([col_1,col_2,matrix[:,2]]))
    
    for i in range(len(nmatrix)):
        x = nmatrix[i,0] + 300 
        y = nmatrix[i,1] + 300
        e = nmatrix[i,2]
    
        zeros[int(x),int(y)] += e
        
    zeros=zeros/np.amax(zeros)

    file_name =  f'/home/rhorna/shower/Swgo_Scripts/images/shower100_{q}.png'
    plt.figure(figsize=(1, 1), dpi = 300)
    plt.axis('off')
    plt.imshow(zeros,cmap='gray_r')
    plt.savefig(file_name)
    plt.close()
    
#######################################################################

# Mini test ()
q = 1
for i in unique_numbers:
    shower100(matrices[i],q)

    # Comment conditional to make full generation
    #if abs(i -unique_numbers[1000]) < 0.001:
    #    break
    q = q+1


