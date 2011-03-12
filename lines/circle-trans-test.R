
library(png)

source('circle-trans.R')

im = readPNG('lanes.png')

L  = circle.trans.image(im)
M  = do.call(rbind, L$Trans$ThetaPoints)
Pr = L$Trans$ProxMatrix

