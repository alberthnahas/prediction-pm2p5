**********************************************************************************************
* This is a GrADS script to visualize PM2.5 prediction for Indonesia                         *
* Outputs of this script are 1-hourly maps with temporal resolution of 0.05deg               *
* Created by: Alberth Nahas (alberth.nahas@bmkg.go.id)                                       *
* Version 1.0.0 (2023-01-14 09:00 am WIB)                                                    *
* Changes from previous versions:                                                            *
**********************************************************************************************

reinit


****** set map area
*** setting background color and clearing the area	
*** gridlines are disabled
'set display white'
'clear'
'set grid off'
****** end mapping area


****** open file
*** preferred file is pre-processed file via CDO commands (https://code.mpimet.mpg.de/projects/cdo)
'sdfopen eac4.pm2p5.2004-2022.12.nc'
****** end opening file


****** set boundaries 
*** lat-lon given covers western part of Indonesia
'set lon 108 119'
'set lat -4 5'
'set xlopts 1 2 0.10'
'set ylopts 1 2 0.10'
****** end setting boundaries


****** start while looping
*** reflects the timestep of the file
*** number of t should be adjusted accordingly
t = 1
while (t <= 1)


****** set map attributes
'clear'
'set rgb  501  200  200  200 100'
'set rgb  502   50   50   50 100'
'set rgb  499  100  100  100 100'
'color 0 100 10 -kind white->chocolate->black'
****** end setting map attributes


****** display PM2.5 concentrations and titles
'set t 't 
'set gxout shaded'
'set mpt 1 off'
'd pm2p5*0'
'q time'
  day = substr(result,11,2)
  month = substr(result,13,3)
  year = substr(result,16,4)
  time = substr(result,8,2)
** convert English to Indonesian spelling
 if (month="MAY"); month="MEI"; endif
 if (month="AUG"); month="AGT"; endif
 if (month="OCT"); month="OKT"; endif
 if (month="DEC"); month="DES"; endif
**       
'set strsiz 0.18'
'set string 1 r 2 0'
'draw string 9. 8. DESEMBER'
'set strsiz 0.18'
'set string 1 l 4 0'
'draw string 1.9 8. SEBARAN PM`b2.5 `n(`3m`0g/m`a3`n)'
*'set font 2'
*'set strsiz 0.125'
*'set string 4 l 1 0'
*'draw string .75 3. SAMUDERA'
*'draw string .85 2.8 HINDIA'
*'draw string 8.1 6. SAMUDERA'
*'draw string 8.1 5.8 PASIFIK'
*'set font 0'
'set strsiz 0.11'
'set string 1 l 2 90'
*'draw string 9.2 0.8 CAMS/ECMWF'
** highlight areas of interest
'set gxout shp'
'set line 502 1 1'
'set shpopts 501'
'draw shp world_without_idn.shp'
'set line 1 1 1'
'set shpopts -1'
'draw shp Indonesia_38_Provinsi_IKN.shp'
'set t 1'
'q time'
  initday = substr(result,11,2)
  initmonth = substr(result,13,3)
  inityear = substr(result,16,4)
  initday = initday - 1
** convert English to Indonesian spelling
 if (month="MAY"); month="MEI"; endif
 if (month="AUG"); month="AGT"; endif
 if (month="OCT"); month="OKT"; endif
 if (month="DEC"); month="DES"; endif
**   
'set strsiz 0.12'
'set string 1 l 2 0'
*'draw string 0.55 1.45 Waktu validasi: 'initday' 'initmonth' 'inityear' 08:00 WIB'
**
****** end displaying PM2.5 concentrations and titles


****** set legends
'set strsiz 0.14'
'color 0 100 10 -kind white->chocolate->black -xcbar 9.9 10.1 0.1 7.7 -fs 1 -fh 0.1 -fw 0.1 -edge triangle'
****** end setting legends


****** produce figures
'printim pm2p5.indonesia.00.png'
****** end producing figures


t = t + 1
endwhile
****** end while looping
