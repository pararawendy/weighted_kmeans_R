#weighted_kmeans function

weighted_kmeans = function(df, K) {
  #df is a dataframe with columns: city name, longitude, latitude, population (as weight)
  #K is number of clusters desired
  #initialize containers
  list_cluster = list()
  vect_sse = vector()
  #iterate algorithm 3 times (due to local minima)
  for (iter in c(1:3)) {
    #initialization
    init_centroids_index = sample(nrow(df),K)
    distance_matrix = matrix(data = NA, nrow = nrow(df), ncol = K)
    cluster = vector()
    centroid_long = vector()
    centroid_lat = vector()
    #compute distance between cities and initial centroids (haversine distance)
    for (k in c(1:K)) {
      for (i in c(1:nrow(df))) {
        city_i = as.numeric(df[i,2:3])
        centroid_k = as.numeric(df[init_centroids_index[k],2:3])
        distance_matrix[i,k] = haversine_dist(city_i,centroid_k)
      }
    }
    #initial cluster assignment for each city
    for (i in c(1:nrow(df))) {
      cluster[i] = which.min(distance_matrix[i,])
    }
    #iteration baseline
    old_cluster = vector(length = length(cluster))
    new_cluster = cluster
    #iterations
    while (!all(old_cluster == new_cluster)) {
      #update old cluster assignment
      old_cluster = new_cluster
      #calculate centroids (weighted average)
      for (k in c(1:K)) {
        cluster_k = which(old_cluster == k) #city index of cluster k
        centroid_long[k] = weighted.mean(df$longitude[cluster_k], df$population[cluster_k])
        centroid_lat[k] = weighted.mean(df$latitude[cluster_k], df$population[cluster_k])
      }
      df_centroid = as.data.frame(cbind(centroid_long, centroid_lat))
      #compute distance between cities and centroids
      for (k in c(1:K)) {
        for (i in c(1:nrow(df))) {
          city_i = as.numeric(df[i,2:3])
          centroid_k = as.numeric(df_centroid[k,])
          distance_matrix[i,k] = haversine_dist(city_i,centroid_k)
        }
      }
      #update cluster assignment for each city
      for (i in c(1:nrow(df))) {
        cluster[i] = which.min(distance_matrix[i,])
      }
      #update new_cluster
      new_cluster = cluster
    }
    #algor iterations result
    list_cluster[[iter]] = cluster #cluster assignment
    vect_sse[iter] = SSE(df, cluster) #sum of squares error
  }
  #function result
  best_iter = which.min(vect_sse)
  return(list_cluster[[best_iter]]) #best cluster assignment (smallest SSE)
}
