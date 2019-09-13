# subset to uk and set lat and long

JAXA_process<-function(latitudeN, latitudeS, longitudeW, longitudeE){

  library(ggplot2)
  library(ggmap)
  library(reshape2)

dir.create("subset")
infiles<-list.files("convert", ".txt*")
change.files <- function(file)
{
  mydata = read.csv(paste0("convert/",file),  header=FALSE)
  colnames(mydata)<-(seq(0, 360, by = 0.05))-0.05
  colnames(mydata)[1]<-"Latitude"
  mydata$Latitude<-(mydata$Latitude-90.05)*-1
  mydata2<-subset(mydata, Latitude<=latitudeN & Latitude>=latitudeS, select=c(Latitude, 0:ncol(mydata)))
  mydata2$Latitude.1<-NULL
  mdata <- melt(mydata2, id=c("Latitude"))
  write.csv(mdata, row.names=FALSE, "convert/plot2.csv")
  mydata3<-read.csv("convert/temp.csv")
  mydata3$variable<-ifelse(mydata3$variable>180, -360+ mydata3$variable, mydata3$variable)
  colnames(mydata3) <- c("Latitude", "Longitude", "UV")
  mydata4<-subset(mydata3, Longitude>=longitudeE & Longitude<=longitudeW, select=c(Latitude, Longitude, UV))
  name<-sub(".txt$","-edit.txt", file)
  write.csv(mydata4, row.names=FALSE, quote=FALSE, paste0("subset/",name))
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
  data<- read.csv(file = paste0("subset/",file), header = TRUE)
  data<-na.omit(data)
  coordinates(data) = ~Longitude + Latitude
  x.range <- as.numeric(c(longitudeW, longitudeE))
  y.range <- as.numeric(c(latitudeS,latitudeN))
  # Create an empty grid where n is the total number of cells
  grd              <- as.data.frame(spsample(data, "regular", n=90000))
  names(grd)       <- c("X", "Y")
  coordinates(grd) <- c("X", "Y")
  gridded(grd)     <- TRUE  # Create SpatialPixel object
  fullgrid(grd)    <- TRUE  # Create SpatialGrid object

  # Interpolate the surface using a power value of 2 (idp=2.0)
  dat.idw <- idw(UV~1,data,newdata=grd,idp=2.0, na.action=na.omit)
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
