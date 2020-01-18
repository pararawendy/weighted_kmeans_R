#find the optimal K using elbow method

#import library
library(ggplot2)

#initiate container
vect_see = vector()

#fill vect_see via looping
for (K in c(1:8)) {
  cluster_assignment = weighted_kmeans(df_city, K)
  vect_see[K] = SSE(df_city, cluster_assignment)
}

#create data frame to use ggplot
df_elbow = as.data.frame(cbind(number_cluster = c(2:8), SSE = vect_see[-1]))

#plotting SSE decline over K (number of clusters)
ggplot(data = df_elbow, aes(x = number_cluster, y = SSE)) + geom_line(color = 'skyblue') + geom_point(color = 'red', size = 3)
