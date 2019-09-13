#!/usr/bin/perl
use strict;
use warnings;

# Read 7200 bytes of header
my $buffer;
my $nBytes = 7200; 
my $bytesRead = read (STDIN, $buffer, $nBytes) ;
my ($npixel,$nline,$lon_min,$lat_max,$reso,$slope,$offset,$junk)=split(" ",$buffer);
$offset =~ s/,.*//; # strip trailing comma and junk

# Read actual lines of data
# j is latitude
my $line;
for(my $m=1;$m<=$nline;$m++){
   read(STDIN,$line,$npixel*1);
   my $x=$npixel*1;
   my @values=unpack("C$x",$line);
   printf "%f",0.05*$m;

for(my $j=0;$j<7200;$j++){
      printf ",%f",$values[$j]*$slope+$offset;
      
   }
   printf "\n"; # newline
}
