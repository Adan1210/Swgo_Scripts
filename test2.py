#Training
import numpy as np
import matplotlib.pyplot as plt



def shower100(matrix,q,subd):
    
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
    
    plt.figure(figsize=(1, 1), dpi = 600)
    plt.axis('off')
    plt.imshow(zeros,cmap='gray_r')
    plt.savefig('./shower100_%d.png' % (q) )
    plt.close()
    
    

#for k in range(0,360):
#    for l in range(0,50):
 #       b = 1 - 0.0055 * k
  #      R = 20 + l * 0.125
   #     ronchi(R,D,o,b,lines, q)
    #    q = q+1
        
def shower600(matrix,q,subd):
    
    zeros4 = np.zeros((100,100))
    col_1= matrix[:,0]//6
    col_2= matrix[:,1]//6
    nmatrix = np.transpose(np.array([col_1,col_2,matrix[:,2]]))
    
    for i in range(len(nmatrix)):
        x = nmatrix[i,0] + 50 
        y = nmatrix[i,1] + 50
        e = nmatrix[i,2]
    
        zeros4[int(x),int(y)] += e
        
    zeros4=zeros4/np.amax(zeros4)
    file_name =  f'./{subd}/shower600_{q}.png'
    plt.figure(figsize=(2, 2), dpi = 100)
    plt.axis('off')
    plt.imshow(zeros4,cmap='gray_r')
    plt.savefig(file_name)
    plt.close()
            

