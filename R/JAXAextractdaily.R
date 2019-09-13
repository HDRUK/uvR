
JAXA_extract<-function(boundary){

  library(rgdal)
  library(raster)

  dir.create("rasterrepository")
  dir.create("extract")

  # add the polygon layer you want the statistics by
  inshp=paste0(boundary)

  rlist=list.files("raster", pattern=".img$", full.names=TRUE)
  rst<-raster(rlist[1])

  # Read polygon feature class shapefile
  p <- readOGR(dsn="boundary", layer=inshp)
  p <- spTransform(p,crs(rst))

  # what the output will be called
  out<- sub("extract/", "", rlist[1])
  out<- sub (".img","", out)
  # if only year is required run next bit of code
  # out<- substr(out,1,4)
  outshp=paste0("UV",out)

  for (i in rlist){
    rdata <- i
    name<- gsub("raster/", "", rdata)
    name<- sub (".img","", name)
    # Read raster
    r <- raster(rdata)
    # Extract raster values to list object
    # possibly use coordinates if this doesnt work
    r.vals <- extract(r, p, small=TRUE)
    #r.vals <- extract(r, coordinates(p), small=TRUE)
    # Use list apply to calculate mean for each polygon
    r.mean <- lapply(r.vals, FUN=mean)
    r.mean <- data.frame(matrix(unlist(r.mean)))
    # Join mean values to polygon data
    r.mean<-data.frame(r.mean)
    names(r.mean)<-name
    p@data <- data.frame(p@data, r.mean)
    q<-data.frame(p)
    write.csv(q, paste0("extract/", name,".csv"), row.names=F)
    file.copy(rlist, "rasterrepository")
    file.copy(paste0(rlist, ".aux.xml"), "rasterrepository")
    file.remove(rlist)
    file.remove(paste0(rlist, ".aux.xml"))
  }
}

