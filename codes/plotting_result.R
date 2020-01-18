#plotting clustering result

K = 5 #optimal K from elbow method
cluster_assignment = weighted_kmeans(df_city, K)
df_city_cluster = as.data.frame(cbind(longitude = df_city$longitude, latitude = df_city$latitude, cluster = cluster_assignment))

#calculate centroids (weighted average)
centroid_long = vector()
centroid_lat = vector()

for (k in c(1:K)) {
  cluster_k = which(cluster_assignment == k) #city index of cluster k
  centroid_long[k] = weighted.mean(df_city$longitude[cluster_k], df_city$population[cluster_k])
  centroid_lat[k] = weighted.mean(df_city$latitude[cluster_k], df_city$population[cluster_k])
}

#create data frame for centroid with dummy cluster number 
df_centroid = as.data.frame(cbind(longitude = centroid_long, latitude = centroid_lat, cluster = rep(K+1, length(centroid_lat))))

#append df_city_cluster and df_centroid for ggplot
df_kmeans_result = rbind.data.frame(df_city_cluster, df_centroid)

#the plot
#clusters
plot(df_kmeans_result$longitude[which(df_kmeans_result$cluster==1)],
     df_kmeans_result$latitude[which(df_kmeans_result$cluster==1)],
     col="violetred3",pch=19,
     xlim = c(min(df_kmeans_result$longitude)-0.75,max(df_kmeans_result$longitude)+0.75), 
     ylim=c(-11,-3),xlab = "longitude", ylab = "latitude",main = "Warehouse Locations based on Weighted K-means")
points(df_kmeans_result$longitude[which(df_kmeans_result$cluster==2)],df_kmeans_result$latitude[which(df_kmeans_result$cluster==2)],col="cadetblue",pch=19)
points(df_kmeans_result$longitude[which(df_kmeans_result$cluster==3)],df_kmeans_result$latitude[which(df_kmeans_result$cluster==3)],col="antiquewhite",pch=19)
points(df_kmeans_result$longitude[which(df_kmeans_result$cluster==4)],df_kmeans_result$latitude[which(df_kmeans_result$cluster==4)],col="cadetblue1",pch=19)
points(df_kmeans_result$longitude[which(df_kmeans_result$cluster==5)],df_kmeans_result$latitude[which(df_kmeans_result$cluster==5)],col="antiquewhite3",pch=19)

#centroids
points(df_kmeans_result$longitude[which(df_kmeans_result$cluster==6)],df_kmeans_result$latitude[which(df_kmeans_result$cluster==6)],col="black",pch=7)


