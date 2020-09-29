
pacman::p_load(dplyr,tidyverse)

full= rbind(c(0,6), c(4,4), c(0,0), c(-5,2))
centers= rbind(c(-5,2), c(0,6))
colnames(full) <- c("x", "y")

# NOT RUN {
install.packages("amap")
## a 2-dimensional example
library(amap)
result <-  Kmeans(full, 2,centers = centers, method='manhattan')
result$centers

library(tidyverse)  # data manipulation
library(cluster)    # clustering algorithms
library(factoextra) # clustering algorithms & visualization
