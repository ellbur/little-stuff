
make.window = function(Col, Width) {
	Frame = data.frame()
	
	attr(Frame, 'window.col')   = Col
	attr(Frame, 'window.width') = Width
	
	Frame
}

add.row.window = function(Frame, Row) {
	Col   = attr(Frame, 'window.col')
	Width = attr(Frame, 'window.width')
	
	Frame = rbind(Frame, Row)
	attr(Frame, 'window.col')   = Col
	attr(Frame, 'window.width') = Width
	
	Post = Row[[Col]] - attr(Frame, 'window.width')
	Frame = Frame[Frame[[Col]] >= Post,]

	Frame
}

left.window = function(Frame) {
	Col = attr(Frame, 'window.col')
	max(Frame[[Col]]) - attr(Frame, 'window.width')
}

right.window = function(Frame) {
	max(Frame[[attr(Frame, 'window.col')]])
}
