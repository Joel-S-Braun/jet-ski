--[[
    @2/21/17
    @skipleb studios
    @vector.lua
    @hexadecival
--]]

--@hexadecival
--vector class
vec = {}
vec.__index = vec 
function vec.new(x,y)
	return setmetatable({x=x or 0,y=y or 0},vec)
end
function vec:dot(that)
	return self.x*that.x+self.y*that.y
end
function vec:mag()
	return math.sqrt(self:dot(self))
end
function vec:__add(that)
	return vec.new(self.x+that.x,self.y+that.y)
end
function vec:__sub(that)
	return vec.new(self.x-that.x,self.y-that.y)
end
function vec:__div(that)
	return vec.new(self.x/that,self.y/that)
end
return vec