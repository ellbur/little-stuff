
reduce.image.wh = function(Matrix, W, H) {
	Amount = mean(c(
		1 - W/ncol(Matrix),
		1 - H/nrow(Matrix)
	));
	
	if (Amount < 0) {
		Matrix
	}
	else {
		reduce.image(Matrix, Amount)
	}
}

reduce.image = function(Matrix, Amount) {
	FF = fft(Matrix)
	
	OmitI = floor(nrow(FF) * Amount / 2)
	OmitJ = floor(ncol(FF) * Amount / 2)
	
	CI = round(nrow(FF) / 2) + 1
	CJ = round(ncol(FF) / 2) + 1
	
	IS = c(1:(CI - OmitI), (CI + OmitI):nrow(FF));
	JS = c(1:(CJ - OmitJ), (CJ + OmitJ):ncol(FF));
	
	FF2 = FF[IS, JS];
	
	Matrix2 = Re(fft(FF2, inv=T))
	Matrix2 = Matrix2 - min(Matrix2)
	Matrix2 = Matrix2 / max(Matrix2) * max(Matrix)
    
	Matrix2
}

