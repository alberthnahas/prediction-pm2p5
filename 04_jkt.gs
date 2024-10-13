**********************************************************************************************
* This is a GrADS script to visualize PM2.5 prediction for Jakarta Metro Area                *
* Outputs of this script are 1-hourly maps with temporal resolution of 0.05deg               *
* Created by: Alberth Nahas (alberth.nahas@bmkg.go.id)                                       *
* Version 1.0.0 (2021-12-26 08:30 am WIB)                                                    *
* Changes from previous versions:                                                            *
*    - The colors cover land only                                                            *
*    - Legends are modified                                                                  *
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
'sdfopen jkt.nc'
****** end opening file


****** set boundaries 
*** lat-lon given covers western part of Indonesia
'set lon 106.3 107.35'
'set lat -6.9 -5.9'
'set xlopts 1 2 0.10'
'set ylopts 1 2 0.10'
****** end setting boundaries


****** start while looping
*** reflects the timestep of the file
*** number of t should be adjusted accordingly
t = 1
while (t <= 24)


****** set map attributes
'clear'
'set rgb  16    0  255    0'
'set rgb  17    0   51  255'
'set rgb  18  255  220    0'
'set rgb  19  255    0    0'
'set rgb  20  255    0    0'
'set rgb  21    0    0    0'
'set rgb  22  255   40   40'
'set rgb  23  255    0    0'
'set rgb  24  200  200  200 100'
'set rgb  25   50   50   50 100'
'set clevs 0 15.5 55.5 150.5 250.5'
'set ccols 0 16 17 18 19 20 21'
****** end setting map attributes


****** display PM2.5 concentrations and titles
'set t 't 
'set gxout shaded'
'set mpt 1 off'
'd pm2p5'
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
'set strsiz 0.12'
'set string 1 l 2 0'
'draw string 6. 7.9 'day' 'month' 'year' | ' time':00 WIB'
'set strsiz 0.15'
'set string 1 l 4 0'
'draw string 2.48 7.9 Konsentrasi PM`b2.5 `n(`3m`0g/m`a3`n)'
'set strsiz 0.11'
'set string 1 l 2 90'
'draw string 8.68 0.8 CAMS/ECMWF'
** highlight areas of interest
'set gxout shp'
'set line 1 1 5'
'set shpopts -1'
'draw shp non_jabodetabek.shp'
'set line 1 1 1'
'set shpopts 24'
'draw shp jabodetabek.shp'
**
****** end displaying PM2.5 concentrations and titles


****** set legends
'set string 8 l 5 0'
'set strsiz 0.11'
'set line 1 1 10'
'draw line 2.45 1.1 8.56 1.1'
'draw string 2.47 1.25 Keterangan:'
'set strsiz 0.09'
**
'set line 16'
'draw polyf 2.45 1.1 3.68 1.1 3.68 0.75 2.45 0.75 2.45 1.1'
'set string 1 c 3 0'
'draw string 3.065 1. <15.5'
'draw string 3.065 0.85 BAIK'
**
'set line 17'
'draw polyf 3.68 1.1 4.91 1.1 4.91 0.75 3.68 0.75 3.68 1.1'
'set string 0 c 3 0'
'draw string 4.295 1. 15.5-55.4'
'draw string 4.295 0.85 SEDANG'
**
'set line 18'
'draw polyf 4.91 1.1 6.14 1.1 6.14 0.75 4.91 0.75 4.91 1.1'
'set string 1 c 3 0'
'draw string 5.525 1. 55.5-150.4'
'draw string 5.525 0.85 TIDAK SEHAT'
**
'set line 19'
'draw polyf 6.14 1.1 7.37 1.1 7.37 0.75 6.14 0.75 6.14 1.1'
'set string 1 c 3 0'
'draw string 6.755 1. 150.5-250.4'
'set strsiz 0.07'
'draw string 6.755 0.85 SANGAT TIDAK SEHAT'
**
'set line 21'
'set strsiz 0.09'
'draw polyf 7.37 1.1 8.58 1.1 8.58 0.75 7.37 0.75 7.37 1.1'
'set string 0 c 3 0'
'draw string 7.985 1. >250.4'
'draw string 7.985 0.85 BERBAHAYA'
****** end setting legends


****** produce figures
'printim pm2p5.jkt't'.png'
****** end producing figures


t = t + 1
endwhile
****** end while looping
