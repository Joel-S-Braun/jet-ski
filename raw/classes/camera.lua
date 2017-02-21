--[[
    @2/21/17
    @skipleb studios
    @camera.lua
    @hexadecival
--]]

--@hexadecival
--camera class
cam = {
	target = nil,
	pos = vec.new(0,0)
}
function cam:move(pos)
	self.pos = self.pos + pos
end
function cam:setpos(pos)
	self.pos = pos
end
function cam:update()
	love.graphics.translate(-cam.pos.x,-cam.pos.y)
	local center = vec.new(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
	cam:setpos(self.target.pos-center) 
end
return cam