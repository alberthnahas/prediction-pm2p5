#!/bin/bash

# Implemented on 2023-01-15

# Collect log file
echo "$(date "+%Y-%m-%d %H:%M:%S") start" >& ~/opm.log
echo "  " >& ~/opm.log

today=$(date +%Y%m%d)


### Generate python script to download PM2.5 data from CAMS/ECMWF
Rscript 01_generate.python.R


### Download PM2.5 data from CAMS/EMCWF
#/home/bik/anaconda3/bin/python 02_download.pm2p5.py
python 02_download.pm2p5.py


### Unzip downloaded data
unzip download.netcdf_zip


### Pre-process data.nc file to produce input files for GrADS using CDO
cdo remapbil,template.idn.nc data.nc remap.nc
cdo -shifttime,7hour -setattribute,pm2p5@units=ug/m3 -expr,pm2p5=pm2p5*1e9 remap.nc indonesia.nc
#cdo div indo.nc mask.idn.nc indonesia.nc
#cdo remapbil,template.jkt.nc indonesia.nc jkt.nc


### Process files thru GrADS
grads -blcx 03_indonesia.gs # processing indonesia.nc 
#grads -blcx 04_jkt.gs  # processing jkt.nc


## Some renaming
mv pm2p5.indonesia.1.png pm2p5.indonesia.01.png
mv pm2p5.indonesia.2.png pm2p5.indonesia.02.png
mv pm2p5.indonesia.3.png pm2p5.indonesia.03.png
mv pm2p5.indonesia.4.png pm2p5.indonesia.04.png
mv pm2p5.indonesia.5.png pm2p5.indonesia.05.png
mv pm2p5.indonesia.6.png pm2p5.indonesia.06.png
mv pm2p5.indonesia.7.png pm2p5.indonesia.07.png
mv pm2p5.indonesia.8.png pm2p5.indonesia.08.png
mv pm2p5.indonesia.9.png pm2p5.indonesia.09.png


### Reformat PNG files for final layout using ImageMagick
for i in {01..72}
do
   composite -geometry 250x75+690+100 logo_bmkg.png pm2p5.indonesia.$i.png pm2p5.indonesia.comp.$i.png
   convert pm2p5.indonesia.comp.$i.png -crop 800x550+0+50+0+0 +repage pm2p5.indonesia.crop.$i.png
   rm pm2p5.indonesia.comp.*.png
   mv pm2p5.indonesia.crop.$i.png pm2p5.indonesia.$i.png
done


### Create GIF file from PNG files
convert -delay 50 pm2p5.indonesia.*.png $today.pm2p5.indonesia.gif


rm data.nc remap.nc indonesia.nc download.netcdf_zip
