## download JAXA daily file

JAXA_download <-function(date, satellite, UVRtype){
  dir.create("rawdata")
  date<-gsub("-","", date)
      FTP <- paste0("ftp://apollo.eorc.jaxa.jp/pub/JASMES/Global_05km/", UVRtype, "/daily/", substring(date,1,6), "/")
      file<-paste0("MOD", "02SSH_A", date , "Av1_v601_7200_3601_",UVRtype,"__le.gz")
      searchFTP<-paste0(FTP, satellite, "02SSH_A", date, "Av1_v811_7200_3601_",UVRtype,"__le.gz")
      download.file(searchFTP, destfile=paste0(getwd(), "/rawdata/", sub(FTP, "", searchFTP)))
}



