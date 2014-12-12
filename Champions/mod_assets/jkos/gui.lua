function drawOption(g,text,x,y,w)
	_,h = g.drawParagraph(text,x+7,y+19,w)
	if isPointInBox(g.mouseX,g.mouseY,x,y,w,h+4) then
		g.color(60,60,60,100)
		g.drawParagraph(text,x+7,y+19,w)
	end
	g.color(255,255,255,255)
	return _,h
end

function drawPanel(g,text,x,y,w)
	local rw,h = g.drawParagraph(text,x+5,y+17,w)
	return rw,h+8,y-2+h+8
end

function isPointInBox(px, py, bx, by, bw, bh)
	return (px >= bx) and (px <= bx + bw) and (py >= by) and (py <= by + bh)
end