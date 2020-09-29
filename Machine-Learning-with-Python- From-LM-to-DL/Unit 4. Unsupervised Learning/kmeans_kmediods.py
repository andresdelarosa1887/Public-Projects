import numpy as np
from sklearn.cluster import KMeans
from sklearn_extra.cluster import KMedoids

X= np.array([
    [0, -6],
    [4,4],
    [0,0],
    [-5,2]
    ])

initialized_center= np.array([[-5,2], [0,-6]])

def L1(v1,v2):
    if(len(v1)!= len(v2)):
       print("error")
       return -1
       return sum([abs(v1[i]-v2[i]) for i in range(len(v1))])

# Euclidean Distance Caculator
def dist(a, b, ax=1):
    abs(a-b, axis=ax)

abs(a-b, axis=ax)

dist(X[1], initialized_center[1])

abs(X[1]- initialized_center[1])



