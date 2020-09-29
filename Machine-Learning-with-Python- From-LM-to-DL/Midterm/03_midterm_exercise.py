import numpy as np
classification_vector= np.array([-1,-1,-1,-1,-1,1,1,1,1,1])
mistake= np.array([1,65,11,31,72,30,0,21,4,15])
data_vector= np.array([[0,0], [2,0],[1,1], [0,2],[3,3],[4,1],[5,2],[1,4],[4,4],[5,5]])
x1= np.array([0, 2,  1, 0, 3, 4, 5, 1,4, 5])
x2= np.array([0, 0,  1, 2, 3, 1, 2, 4,4, 5])


kernelized_data= []
for i,x in enumerate(classification_vector):
    kernelized= x1[i]**2, np.sqrt(2)*x1[i]*x2[i], x2[i]**2
    kernelized_data.append(kernelized)

final_kernelized_data= np.array(kernelized_data)

thetas=[]
thetas0= []
final_theta=0
final_theta0= 0 
for i, x  in enumerate(data_vector):
    theta=classification_vector[i]*mistake[i]*(data_vector[i])
    theta0= mistake[i]*classification_vector[i]
    thetas.append(theta)
    thetas0.append(theta0)
    final_theta += theta
    final_theta0 += theta0
