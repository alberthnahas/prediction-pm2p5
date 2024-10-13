### CLEAR WORKSPACE ###
rm(list = ls())
gc()

### INCLUDE LIBRARIES ###
library(magick)
library(gtools)
library(animation)

### ASSIGN DIRECTORY NAME ###
today <- format(Sys.Date(), "%Y%m%d")
folder <- paste0("~/Documents/BMKG/ku_indonesia/otomatisasi_pm2p5/results/",today)

### SET WORKING DIRECTORY ###
setwd(folder)

png <- c("west", "east")

### CREATE GIF FILE ###
for (i in png){
  pattern <- paste0("pm2p5.",i,"*")
  imgs01 <- list.files("./", pattern = pattern, full.names = FALSE)
  imgs <- mixedsort(imgs01)
  img_list <- lapply(imgs, image_read)
  ## join the images together
  img_joined <- image_join(img_list)
  ## animate at 2 frames per second
  img_animated <- image_animate(img_joined, fps = 1)
  ## save to disk
  image_write(image = img_animated,
              path = paste0(today,".",i,".gif"))
  run <- paste0("ffmpeg -f gif -i ",today,".",i,".gif ",today,".",i,".mp4")
  system(run)
}
