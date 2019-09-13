## download JAXA daily file

JAXAdownloadmonthly <-function(yearmonth, satellite, UVRtype){
  dir.create("rawdata")
  tryCatch(
    {
      FTP <- paste0("ftp://apollo.eorc.jaxa.jp/pub/JASMES/Global_05km/", UVRtype, "/monthly/", substring(yearmonth,1,4), "/")
      searchFTP<-paste0(FTP, sat, "02SSH_A", yearmonth, "16Avh_v811_7200_3601_",UVRtype,"__8b.gz")
      download.file(searchFTP, destfile=paste0(getwd(), "/rawdata/", sub(FTP, "", searchFTP)))
    } , error=function(e){
      cat("ERROR :",conditionMessage(e), "\n")
      FTP <- paste0("ftp://apollo.eorc.jaxa.jp/pub/JASMES/Global_05km/", UVRtype, "/monthly/", substring(yearmonth,1,4), "/")
      file<-paste0("MOD", "02SSH_A", yearmonth , "Av1_v601_7200_3601_",UVRtype,"__8b.gz")
      searchFTP<-paste0(FTP, "MOD", "02SSH_A", yearmonth, "16Avh_v811_7200_3601_",UVRtype,"__8b.gz")
      download.file(searchFTP, destfile=paste0(getwd(), "/rawdata/", sub(FTP, "", searchFTP)))
    } , error=function(e){
      cat("ERROR :",conditionMessage(e), "\n")
      FTP <- paste0("ftp://apollo.eorc.jaxa.jp/pub/JASMES/Global_05km/", UVRtype, "/monthly/", substring(yearmonth,1,4), "/")
      file<-paste0("MOD", "02SSH_A", yearmonth , "Av1_v601_7200_3601_",UVRtype,"__le.gz")
      searchFTP<-paste0(FTP, "MOD", "02SSH_A", yearmonth, "16Avh_v811_7200_3601_",UVRtype,"__le.gz")
      download.file(searchFTP, destfile=paste0(getwd(), "/rawdata/", sub(FTP, "", searchFTP)))
    } , error=function(e){
      cat("ERROR :",conditionMessage(e), "\n")
      FTP <- paste0("ftp://apollo.eorc.jaxa.jp/pub/JASMES/Global_05km/", UVRtype, "/monthly/", substring(yearmonth,1,4), "/")
      file<-paste0("MYD", "02SSH_A", yearmonth , "Av1_v601_7200_3601_",UVRtype,"__le.gz")
      searchFTP<-paste0(FTP, "MOD", "02SSH_A", yearmonth, "16Avh_v811_7200_3601_",UVRtype,"__le.gz")
      download.file(searchFTP, destfile=paste0(getwd(), "/rawdata/", sub(FTP, "", searchFTP)))
    })
}

