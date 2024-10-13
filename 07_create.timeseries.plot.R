### CLEAR WORKSPACE ###
rm(list=ls())
gc()

### GET THE DATES ###
today <- format(Sys.Date(), "%Y%m%d")
tomorrow <- format(Sys.Date()+1, "%d-%m-%Y")
folder <- paste0("~/Documents/BMKG/ku_indonesia/otomatisasi_pm2p5/results/",today)

### SET WORKING DIRECTORY ###
setwd(folder)

### LOAD LIBRARIES ###
library(ncdf4)
library(raster)
library(ggplot2)
library(png)

### INPUT FILES ###
fname <- "../../process/land.idn.nc"
csv <- read.csv("../../process/cities.csv")
logo <- readPNG("../../process/logo_bmkg.png")

### SELECT VARIABLES FROM INPUT FILES ###
pm2p5.brick <- brick(fname)
lon.pts <- csv$lon
lat.pts <- csv$lat
names <- csv$loc

### EXTRACT VALUES ###
extract.pts <- cbind(lon.pts,lat.pts)
ext <- extract(pm2p5.brick, extract.pts, method = "bilinear")

### BUILD DATAFRAME & STORE AS CSV ###
df <- data.frame(Kota = names,
                 H00 = ext[,1], H01 = ext[,2], H02 = ext[,3], H03 = ext[,4], 
                 H04 = ext[,5], H05 = ext[,6], H06 = ext[,7], H07 = ext[,8],
                 H08 = ext[,9], H09 = ext[,10], H10 = ext[,11], H11 = ext[,12],
                 H12 = ext[,13], H13 = ext[,14], H14 = ext[,15], H15 = ext[,16],
                 H16 = ext[,17], H17 = ext[,18], H18 = ext[,19], H19 = ext[,20],
                 H20 = ext[,21], H21 = ext[,22], H22 = ext[,23], H23 = ext[,24])
csvname <- paste0(today, ".csv")
write.csv(df, csvname, row.names = FALSE)

### CREATE PNG FILES ###
for (i in 1:34) {
    x <- seq(0,23,1)
    y <- ext[i,]

    max <- format(round(max(y), 2), nsmall = 2)
    min <- format(round(min(y), 2), nsmall = 2)
    avg <- format(round(mean(y), 2), nsmall = 2)
    
    filename <- paste0("ts.",today,".",names[i],".png")
    png(filename, width = 1200, height = 844)
    
    par(mar=c(5.5,5,4,1) + .8)
    
    plot(x, 
         y, 
         cex.lab = 1.6, 
         type = "n", 
         xlab = "WIB", 
         ylab = expression(PM[2.5]  (μg/m^3)),
         yaxs = "i", 
         xaxs = "i", 
         ylim = c(0, 100),
         axes = FALSE, 
         lwd = 1.5)
    
    abline(h = seq(0, 100, 10), v = seq(0, 23, 1), lty = 6, col = "cornsilk2")
    abline(h = 15.5, col = "orange", lty = 2)
    text(0.5, 3, "SEHAT", adj = c(0, 0), col = "green3", cex = 1.5, srt = 90)
    abline(h = 55.5, col = "orange", lty = 2)
    text(0.5, 30, "SEDANG", adj = c(0, 0), col = "orange", cex = 1.5, srt = 90)
    text(0.5, 72, "TIDAK SEHAT", adj = c(0, 0), col = "red", cex = 1.5, srt = 90)
    rasterImage(logo, 20.7, 82, 22.7, 98)
    lines(x, y, col = "black", lwd = 2)
    points(x, y, col = "black", lwd = 2)
    axis(1, labels = FALSE, tck = 0.005, at = seq(0,23,1))
    axis(1, labels = TRUE, tck = 0.01, at = seq(0,23,3), lwd = 0.8, cex.axis = 1.2)
    axis(2, labels = TRUE, tck = 0.01, at = seq(0, 100, by = 10), las = 2, cex.axis = 1.2)
    axis(3, labels = FALSE, tck = 0.01, at = seq(0,23,3), pos = 100, lwd = 0.8)
    axis(3, labels = FALSE, tck = 0.005, at = seq(0,23,1), pos = 100)
    axis(4, labels = FALSE, tck = 0.005, at = seq(0, 100, by = 10), pos = 23)
    
    city <- paste0(names[i]," [",lat.pts[i],"°, ",lon.pts[i],"°]")
    subtitle <- paste0("Tanggal: ", tomorrow," | Maks.: ", max," Min.: ", min," Rerata: ", avg)
    mtext(city, side = 3, line = 1.5, adj = 0, cex = 2, font = 2)
    mtext(subtitle, side = 3, line = 0, adj = 0, cex = 1.3)
    mtext("CAMS/ECMWF", side = 3, line = 0, adj = 1, cex = 1.3, font = 3)
    
    dev.off()

    # datum <- data.frame(x, y)
    # p <- ggplot(datum, aes(x = x, y = y)) +
    #   geom_line() + 
    #   geom_point() +
    #   labs(x = "WIB", y = expression(PM[2.5]  (μg/m^3))) +
    #   ggtitle(paste0(names[i]," [",lat.pts[i],"°, ",lon.pts[i],"°]"), 
    #          paste0("Tanggal: ", tomorrow," | Maks.: ", max," Min.: ", min," Rerata: ", avg)) +
    #   scale_x_continuous(expand = c(0,0), breaks = seq(0, 23, by = 1)) +
    #   scale_y_continuous(expand = c(0,0), limits = c(0, as.numeric(max)*1.2))
    # p + theme(plot.title=element_text(size=15), axis.title=element_text(size=10))
    # filename <- paste0("ts.",today,".",names[i],".png")
    # ggsave(filename = filename, dpi = 300)
}
