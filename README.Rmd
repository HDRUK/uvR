---
title: "README.md"
author: "Mark Cherrie"
date: "18/09/2019"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(eval = FALSE, include = FALSE)
```

# Package is beta, only works on a mac

## Instructions for use

### Create a new project 
### Create a folder called 'boundary' with the geography that you want your estimates by

### Install the package
```{r install, include=F}
devtools::install_github("markocherrie/uvR")
```

### Load the package
```{r load, include=F}
library(uvR)
```

### Download the two days from last week
```{r download, include=F}
dates<-seq(as.Date("2019-09-11"), as.Date("2019-09-12"), by="days")
dates<-gsub("-", "", dates)
for(i in dates){
uvR::JAXA_download(i, "MYD", "uvb")
}
```

### Convert that data to something usable
```{r convert, include=F}
uvR::JAXA_convert()
```

### Process the data for your area of interest
```{r process, include=F}
uvR::JAXA_process(61,43,-11,2)
```

### Visualise the raster
```{r rstviz, include=F}
rst<-raster(list.files("raster/", full.names = T)[1])
plot(rst)
```

# Get summary statistics for your chosen geography
```{r extract, include=F}
uvR::JAXA_extract("LA")
```

# Visualise the output

```{r summaryvisualise, include=F}
multmerge = function(mypath){
  filenames=list.files(path=mypath, full.names=TRUE)
  datalist = lapply(filenames, function(x){read.csv(file=x,header=T)})
  Reduce(function(x,y) {merge(x,y)}, datalist)
}
# https://www.r-bloggers.com/merging-multiple-data-files-into-one-data-frame/

mymergeddata = multmerge("extract/")

mymergeddataLONG<-reshape(mymergeddata, varying=c(3:4), direction="long", idvar="NAME", sep="", timevar="date")
mymergeddataLONG$date<-as.Date(substr(mymergeddataLONG$date, 8,15), format="%Y%m%d")

library(ggplot2)
## simple line chart in ggplot
p<-ggplot(data=mymergeddataLONG, aes(x=date, y=MYD, group=NAME, color=NAME)) +
  geom_line() +
  geom_point() +
  labs(title="Mean daily UVB for Local Authorities in Scotland", x="Date" ,y="UVB (W/m2)") 
p
```






