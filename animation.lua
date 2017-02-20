--[[
    @2/20/17
    @skipleb studios
    @animation.lua
    @hexadecival
--]]

--[[
	@notes: 
	-@hexadecival: handle states in a less gross way
	-@hexadecival: spritesheet system (improve performance)
	-@hexadecival: image caching (improve performance)
--]]

--@hexadecival
--anim class
anim = {}
anim.__index = anim 
function anim.new(obj,name)
	local class = setmetatable({obj=obj,data=require(name),state=0,frame=1,time=0},anim)
	table.insert(obj.components,class)
	return class
end
function anim:update()
	if self.state == 1 then
		if self.frame <= #self.data then
			local data = self.data[self.frame]
			self.obj.image = newimage(data[1])
			self.time = self.time + 1/60
			if self.time >= data[2] then
				self.time = 0
				self.frame = self.frame + 1
			end
		else
			self.time = 0
			self.frame = 1
		end
	end
end
function anim:play()
	self.state = 1
end
function anim:stop()
	self.state = 0
end
return anim