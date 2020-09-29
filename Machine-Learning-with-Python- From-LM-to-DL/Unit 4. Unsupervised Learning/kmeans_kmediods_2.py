import numpy as np
import pandas as pd
from copy import deepcopy
from scipy.spatial import distance

X= np.array([
    [0, -6],
    [4,4],
    [0,0],
    [-5,2]])



# Euclidean Distance Caculator
def dist(a, b, ax=1):
    return np.linalg.norm(a - b, axis=ax)


# Number of clusters
k = 2
C= np.array([[-5,2], [0,-6]])

distance.cdist(C, C_old, 'cityblock')
dist(C, C_old)

# To store the value of centroids when it updates
C_old = np.zeros(C.shape)
# Cluster Lables(0, 1, 2)
clusters = np.zeros(len(X))
# Error func. - Distance between new centroids and old centroids
error = dist(C, C_old, None)
# Loop will run till the error becomes zero
while error != 0:
    # Assigning each value to its closest cluster
    for i in range(len(X)):
        distances = dist(X[i], C)
        cluster = np.argmin(distances)
        clusters[i] = cluster
    # Storing the old centroid values
        C_old = deepcopy(C)
    # Finding the new centroids by taking the average value
    for i in range(k):
        points = [X[j] for j in range(len(X)) if clusters[j] == i]
        C[i] = np.mean(points)
    error = dist(C, C_old, None)




