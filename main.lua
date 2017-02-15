--[[
    @12/3/17
    @skipleb studios
    @client(?)
    @hexadecival & waffloid
--]]

--apparently you need this to render pixelated gfx properly lol
love.graphics.setLineStyle( 'rough' ) 
love.graphics.setDefaultFilter("nearest", "nearest")

--@hexadecival
--Image creation
function newimage(dir)
	return love.graphics.newImage(dir)
end

--@hexadecival
--Vector class
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
			obj:updatecomponents()
			if ((obj.pos-vec.new(400,300))-cam.pos):mag() < rendist then
				obj:draw()
			end
		end		
	end
end

--@hexadecival
--rigidbody class
rigidbody = {}
rigidbody.__index = rigidbody
function rigidbody.new(obj,velocity,drag)
	local class = setmetatable({obj=obj,velocity=velocity,drag=drag},rigidbody)
	table.insert(obj.components,class)
	return class
end
function rigidbody:update()
	self.obj.pos = self.obj.pos + self.velocity
	local dx, dy = self.drag.x,self.drag.y
	local vx, vy = self.velocity.x,self.velocity.y
	if vx > 0 then
		vx = vx - dx
	elseif vx < 0 then
		vx = vx + dx
	end
	if vy > 0 then
		vy = vy - dy
	elseif vx < 0 then
		vy = vy + dy
	end
	self.velocity = vec.new(vx,vy)
end

--@hexadecival
--object class
obj = {}
obj.__index = obj 
function obj.new(image,pos,size) 
	local class = setmetatable({image=image,pos=pos or vec.new(),size = size or vec.new(),components = {}},obj)
	table.insert(drawlist,class)
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
--unity style component system
function obj:updatecomponents()
	for _, component in pairs (self.components) do
		component:update()
	end
end

--@hexadecival
--World creation
local player
local player_controller
do
	player = obj.new(newimage("mandem_idle.png"),vec.new(5,5),vec.new(2,2))
	player_controller = rigidbody.new(player,vec.new(0,0),vec.new(1,1))
	--generate random shit
	for i = 1, 10000 do
		obj.new("box",vec.new(math.random(-2500,2500),math.random(-2500,2500)),vec.new(24,24))
	end
end

--@hexadecival
--fullscreen
--gross
local function updatefullscreeninput()
	if love.keyboard.isDown("x") then
		love.window.setFullscreen(not love.window.getFullscreen())
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
	player_controller.velocity = player_controller.velocity + mv
end

--@hexadecival
--Cam render
local function rendercam()
	love.graphics.translate(-cam.pos.x,-cam.pos.y)
	local center = vec.new(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
	cam:setpos(player.pos-center) 
end

--Render everything
function love.draw()
	rendercam()
	renderworld()
	updateinput()
	updatefullscreeninput()
end
