--[[
    @12/3/17
    @skipleb studios
    @client(?)
    @hexadecival & waffloid
--]]

--@hexadecival
--Vector class
vec = {}
vec.__index = vec 
function vec.new(x,y)
	return setmetatable({x=x,y=y},vec)
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

--@hexadecival
--Camera class
cam = {
	pos = vec.new(0,0)
}
function cam:move(pos)
	self.pos = self.pos + pos
end
function cam:setpos(pos)
	self.pos = pos
end

--@hexadecival
--Render world (hacky shit)
local drawlist = {}
do
	local rendist = 1000 --rendering distance 
	function renderworld()
		for i, obj in pairs (drawlist) do
			if ((obj.pos-vec.new(400,300))-cam.pos):mag() < rendist then
				obj:draw()
			end
		end		
	end
end

--@hexadecival
--object class
obj = {}
obj.__index = obj 
function obj.new(pos)
	--hacky, idk what im doing really, i just want to call draw on all objs
	local d = setmetatable({pos=pos},obj)
	table.insert(drawlist,d)
	return d
end
function obj:draw()
	love.graphics.rectangle("fill",self.pos.x,self.pos.y,8,8)
end
function obj:setpos(pos)
	self.pos = pos
end
function obj:move(pos)
	self.pos = self.pos + pos
end

--@hexadecival
--World creation
local player
do
	player = obj.new(vec.new(5,5))
	--generate random shit
	for i = 1, 10000 do
		obj.new(vec.new(math.random(-2500,2500),math.random(-2500,2500)))
	end
end

--@hexadecival
--Move player from input 
local function updateinput()
	local w = love.keyboard.isDown("w")
	local a = love.keyboard.isDown("a")
	local s = love.keyboard.isDown("s")
	local d = love.keyboard.isDown("d")
	local mx = a and -1 or d and 1 or 0
	local my = w and -1 or s and 1 or 0
	local mv = vec.new(mx,my)
	player:move(mv)
end

--@hexadecival
--Cam render
local function rendercam()
	love.graphics.translate(-cam.pos.x,-cam.pos.y)
	cam:setpos(player.pos-vec.new(400,300)) --BULLSHIT OFFSET FROM CHAR, CHANGE TO PROPER COORDS TO CENTER
end

--Render everything
function love.draw()
	rendercam()
	renderworld()
	updateinput()
end
