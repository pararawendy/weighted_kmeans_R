#haversine distance function

haversine_dist = function(point1, point2) { #each argument is a numeric vector with two elements (lon, lat)
  lon1 = point1[1] 
  lat1 = point1[2]
  lon2 = point2[1]
  lat2 = point2[2]
  
  R = 6371000 #earth radius in meters
  phi1 = lat1 * pi / 180 #convert to radian
  phi2 = lat2 * pi / 180 #convert to radian
  delta_phi = (lat2 - lat1) * pi / 180
  delta_lambda = (lon2 - lon1) * pi / 180
  
  a = (sin(delta_phi/2))^2 + cos(phi1) * cos(phi2) * ((sin(delta_lambda/2))^2)
  c = 2 * atan2(sqrt(a), sqrt(1-a))
  
  distance = R * c #haversine distance between point1 and point 2 in meters
  return(round(distance, 2))
}
