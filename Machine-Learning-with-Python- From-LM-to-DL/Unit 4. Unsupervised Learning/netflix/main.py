import numpy as np
import kmeans
import common
import naive_em
import em

X = np.loadtxt("toy_data.txt")

# TODO: Your code here
seed= np.array([0,1,2,3,4])

##Implementation of the graph
K= np.array([1,2,3,4])
common.init(X, 2, 2)



##Initialization of components to then run the Kmean Algorithm
mixture_means_total= []
mixture_posts= []
mixture_components= []

for i in K:
    implementation= common.init(X, i, 4)
    mixture_component= implementation[0]
    mixture_post = implementation[1]
    mixture_components.append(mixture_component)
    mixture_posts.append(mixture_post)
    mixture_means_total.append(implementation)


# =============================================================================
# for i in K: 
#     common.plot(X, mixture_components[i-1], mixture_posts[i-1], "Implementation")
# 
# =============================================================================

costs= []
for i in K: 
    kruns= kmeans.run(X, mixture_components[i-1], mixture_posts[i-1])
    cost= kruns[2]
    costs.append(cost)

costs




