
source('line-cluster.R')
source('points.R')

ggload()

library(png)
Image = readPNG('lanes.png')

Points = get.points(Image, Size=30, Quant=0.90)
Dist.Thresh = 30
Area.Scale  = 50 * 50

X = line.cluster(Points, Dist.Thresh, Area.Scale)

