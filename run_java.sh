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
cdo sellonlatbox,104.8,116.5,-3.6,-10.1 indonesia.nc test2.nc
cdo div test2.nc test.nc land.java.nc
#cdo div indo.nc mask.idn.nc indonesia.nc
#cdo remapbil,template.jkt.nc indonesia.nc jkt.nc


### Process files thru GrADS
grads -blcx 04_aq_category_java.gs # processing indonesia.nc 
#grads -blcx 04_jkt.gs  # processing jkt.nc


## Some renaming
mv pm2p5.aq.java.1.png pm2p5.aq.java.01.png
mv pm2p5.aq.java.2.png pm2p5.aq.java.02.png
mv pm2p5.aq.java.3.png pm2p5.aq.java.03.png
mv pm2p5.aq.java.4.png pm2p5.aq.java.04.png
mv pm2p5.aq.java.5.png pm2p5.aq.java.05.png
mv pm2p5.aq.java.6.png pm2p5.aq.java.06.png
mv pm2p5.aq.java.7.png pm2p5.aq.java.07.png
mv pm2p5.aq.java.8.png pm2p5.aq.java.08.png
mv pm2p5.aq.java.9.png pm2p5.aq.java.09.png


### Reformat PNG files for final layout using ImageMagick
for i in {01..72}
do
   composite -geometry 250x75+692+80 logo_bmkg.png pm2p5.aq.java.$i.png pm2p5.aq.java.comp.$i.png
   composite -geometry 700x75+50+510 Legend-PM-rev.png pm2p5.aq.java.comp.$i.png pm2p5.aq.java.legend.$i.png
   convert pm2p5.aq.java.legend.$i.png -crop 790x570+0+20+0+0 +repage pm2p5.aq.java.crop.$i.png
   rm pm2p5.aq.java.comp.*.png pm2p5.aq.java.legend.*.png
   mv pm2p5.aq.java.crop.$i.png pm2p5.aq.java.$i.png
done


### Create GIF file from PNG files
convert -delay 50 pm2p5.aq.java.*.png $today.pm2p5.aq.java.gif


rm data.nc remap.nc indonesia.nc download.netcdf_zip test2.nc pm2p5.aq.java*png
