# subset to uk and set lat and long

JAXA_process<-function(latitudeN, latitudeS, longitudeW, longitudeE){

  library(ggplot2)
  library(ggmap)
  library(reshape2)

dir.create("subset")
infiles<-list.files("convert", ".txt*")
change.files <- function(file)
{
  original = read.csv(paste0("convert/",file),  header=FALSE)
  colnames(original)<-(seq(0, 360, by = 0.05))-0.05
  colnames(original)[1]<-"Latitude"
  original$Latitude<-(original$Latitude-90.05)*-1
  latsub<-subset(original, Latitude<=latitudeN & Latitude>=latitudeS, select=c(Latitude, 0:ncol(original)))
  latsub$Latitude.1<-NULL
  latsublong <- melt(latsub, id=c("Latitude"))
  latsublong$variable<-ifelse(latsublong$variable>180, -360+ latsublong$variable, latsublong$variable)
  colnames(latsublong) <- c("Latitude", "Longitude", "UV")
  latlongsublong<-subset(latlongsublong, Longitude>=longitudeW & Longitude<=longitudeE, select=c(Latitude, Longitude, UV))
  name<-sub(".txt$","-edit.txt", file)
  write.csv(latlongsublong, row.names=FALSE, quote=FALSE, paste0("subset/",name))
  file.remove(paste0("convert/",file))
}

######################################
lapply(infiles , change.files)
######################################

dir.create("raster")

# Add required libraries (interpolate)
library(sp)
library(raster)
library(gstat)

# single raster
infiles<-list.files("subset", "-edit.txt*")

# batch
interpolate<-function(file){
  latlongsublong <- read.csv(file = paste0("subset/",file), header = TRUE)
  latlongsublong <-na.omit(data)
  coordinates(latlongsublong) = ~Longitude + Latitude
  x.range <- as.numeric(c(longitudeW, longitudeE))
  y.range <- as.numeric(c(latitudeS,latitudeN))

  # Create an empty grid where n is the total number of cells
  grd              <- as.data.frame(spsample(data, "regular", n=90000))
  names(grd)       <- c("X", "Y")
  coordinates(grd) <- c("X", "Y")
  gridded(grd)     <- TRUE  # Create SpatialPixel object
  fullgrid(grd)    <- TRUE  # Create SpatialGrid object

  # Interpolate the surface using a power value of 2 (idp=2.0)
  dat.idw <- idw(UV~1,latlongsublong,newdata=grd,idp=2.0, na.action=na.omit)
  rasterDF <- raster(dat.idw)
  bb <- extent(longitudeW, longitudeE, latitudeS, latitudeN)
  extent(rasterDF) <- bb
  crs(rasterDF) <- CRS("+proj=longlat +datum=WGS84")
  name<-sub("Av1_v8111_7200_3601_uv__8b-edit.txt", ".img", file)
  writeRaster(rasterDF,paste0("raster/", name), format = "HFA", overwrite=TRUE)
  file.remove(paste0("subset/",file))
}

############################################
lapply(infiles, interpolate)
############################################


}
