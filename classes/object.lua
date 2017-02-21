--[[
    @2/21/17
    @skipleb studios
    @object.lua
    @hexadecival
--]]

--@hexadecival
--object class
obj = {}
obj.__index = obj 
function obj.new(image,pos,size,name) 
	local class = setmetatable({name=name or "object",image=image,pos=pos or vec.new(),size = size or vec.new(),components = {}},obj)
	table.insert(_G.drawlist,class)
	return class
end
function obj:draw()
	if self.image == "box" then --idk
		love.graphics.rectangle("fill",self.pos.x,self.pos.y,self.size.x,self.size.y)
	else
		love.graphics.draw(self.image,self.pos.x,self.pos.y,0,self.size.x,self.size.y)
	end
end
function obj:setpos(pos)
	self.pos = pos
end
function obj:move(pos)
	self.pos = self.pos + pos
end
--crappy unity style component system
function obj:updatecomponents()
	for _, component in pairs (self.components) do
		component:update()
	end
end
return obj