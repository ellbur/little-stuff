
library(Matrix)
library(expm)

make.small.rot = function(DThetaX, DThetaY, DThetaZ) {
	DM = matrix(c(
		    1,     -dThetaZ,  dThetaY,
		 dThetaZ,      1,    -dThetaX,
		-dThetaY,   dThetaX,     1
		),
		byrow=T,
		ncol=3
	)

}

make.ortho = function(M) {
	
}
