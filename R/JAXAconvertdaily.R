
JAXA_convert<-function(){

dir.create("perl")
URL      <- "https://raw.githubusercontent.com/markocherrie/uvR/master/perl/JAXAconvertdaily.pl"
destfile <- "perl/JAXAconvertdaily.pl"
download.file(URL, destfile)


system('

mkdir convert
cd rawdata
FILES=*
gzip -d *.gz
rm *.gz


for f in $FILES;
do
perl ../perl/JAXAconvertdaily.pl < "$f" > ../convert/$f.txt
echo "Extracting $f..."
rm "$f"
done')

}
