import numpy as np

X= np.array([
    [0, -6],
    [4,4],
    [0,0],
    [-5,2]])

#Initial points 
medoids_initial =np.array([[-5,2], [0,-6]]) 

##K- Medioids Algorithm 
costs = list()
# Step 1
z = np.array([[-5,2], [0,-6]]) 
zs = list([z])

##K Mediods Algorithm
while True:
  clusters = np.array([np.argmin([np.linalg.norm(X[i] - z[j]) for j in range(len(z))]) for i in range(len(X))])
  clusters = np.array([X[np.where(clusters == label)[0]] for label in set(clusters)])
  z = X[[np.argmin([sum([np.linalg.norm(X[i] - X[j]) for i in range(len(cluster))]) for j in range(len(X))]) for cluster in clusters]]
  zs.append(z)
  cost = sum([sum([np.linalg.norm(clusters[j][i] - z[j]) for i in range(len(clusters[j]))]) for j in range(len(z))])
  print ("Cost:", cost)
  costs.append(cost)
  if len(costs) >= 2 and costs[-1] > costs[-2]:
    break

detailed_clusters= clusters
final_centroids= z


