--[[
    @12/3/17
    @skipleb studios
    @core engine(?)
    @hexadecival & waffloid
--]]

--[[
	@notes: 
	-@hexadecival: use diff files instead of cramping everythin into main.lua
	-@hexadecival: handle drawlist and components more efficiently
	-@hexadecival: handle tilemap system differently (use voxel system wen waffle makes it)
	-@hexadecival: solve colissions and implement gravity + jumping for player
	-@hexadecival: ?work on networking backend?
	-@hexadecival: implement rotations and scaling
	-@hexadecival: UI backend / classes
	-@hexadecival: create some particle system for A E S T E T H I C S
	-@hexadecival: implement spritesheet system and more efficient image-related memory handling
	-@hexadecival: create animation framework and necessary classes for it
	-@hexadecival: create raycasting algorithm
--]]

--@hexadecival
--initialization
do
	dofile("jet-ski/mapdata.lua")
	love.graphics.setLineStyle( 'rough' ) 
	love.graphics.setDefaultFilter("nearest", "nearest")
end

local anim = require("animation")

--@hexadecival
--image creation
function newimage(dir)
	return love.graphics.newImage(dir)
end

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

--@hexadecival
--camera class
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
--render world (hacky shit)
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
function rigidbody.new(obj,velocity,drag,maxvelocity)
	local class = setmetatable({obj=obj,velocity=velocity,drag=drag,maxvelocity=maxvelocity},rigidbody)
	table.insert(obj.components,class)
	return class
end
function coldetect(a,b) --SIMPLISTIC AS HELL METHOD for now LOL
	if (a.pos-b.pos):mag() <= (a.size/2+b.size/2):mag() then
		return true
	end
end
function rigidbody:update()
	local dx, dy = self.drag.x,self.drag.y
	local vx, vy = self.velocity.x,self.velocity.y
	local mx, my = self.maxvelocity.x,self.maxvelocity.y
	vx = math.max(-mx,math.min(vx,mx))
	vy = math.max(-my,math.min(vy,mx))
	if vx > 0 then
		vx = math.max(0,vx-dx)
	elseif vx < 0 then
		vx = math.min(0,vx+dx)
	end
	if vy > 0 then
		vy = math.max(0,vy-dy)
	elseif vy < 0 then
		vy = math.min(0,vy+dy)
	end
	local colliding = false
	local correction = vec.new(0,0)
	for i, obj in pairs(drawlist) do
		if obj ~= self.obj then
			if coldetect(self.obj,obj) then
				print("col : "..self.obj.name.." : true : "..obj.name)
				print("col : "..self.obj.name.." : false : "..obj.name)
				colliding = true
			end
		end
	end
	if colliding then
		vx,vy = -vx,-vy
	else
		vy = vy + 0 --gravity dlc
	end
	self.velocity = vec.new(vx,vy)
	self.obj.pos = self.obj.pos + self.velocity 
end

--@hexadecival
--object class
obj = {}
obj.__index = obj 
function obj.new(image,pos,size,name) 
	local class = setmetatable({name=name or "object",image=image,pos=pos or vec.new(),size = size or vec.new(),components = {}},obj)
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
--crappy unity style component system
function obj:updatecomponents()
	for _, component in pairs (self.components) do
		component:update()
	end
end

--@hexadecival
--tilemap/voxel/map loader
function loadmap(mapdata)
	local tiledata = {
		[0] = nil, --air
		[1] = {image="box",size=vec.new(24,24)}, --solid
		[5] = {image=newimage("mandem_idle.png"),size=vec.new(2,2)} --roadman
	}
	local tiles = mapdata.tiles
	local tilesize = mapdata.tilesize
	local x = 0
	local y = 0
	for i = 1, #tiles do
		x = x + 1
		local tile = tiledata[tiles[i]]
		if tile ~= nil then
			obj.new(tile.image,vec.new(tilesize*x,tilesize*y),tile.size,"tile"..x.."|"..y)
		end
		if x == mapdata.width then
			x = 0
			y = y + 1
		end
	end
end

--@hexadecival
--world creation
local player
local player_animator
local player_controller
do
	player = obj.new(newimage("mandem_idle.png"),vec.new(5,5),vec.new(2,2),"player")
	player_controller = rigidbody.new(player,vec.new(0,0),vec.new(0.1,0.1),vec.new(4,4))
	player_animator = anim.new(player,"mandem_anims")
	player_animator:play()
	loadmap(skimap)
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
--move player from input 
local function updateinput()
	local w = love.keyboard.isDown("w")
	local a = love.keyboard.isDown("a")
	local s = love.keyboard.isDown("s")
	local d = love.keyboard.isDown("d")
	local mx = a and -0.5 or d and 0.5 or 0
	local my = w and -0.5 or s and 0.5 or 0
	local mv = vec.new(mx,my)
	player_controller.velocity = player_controller.velocity + mv
end

--@hexadecival
--cam render
local function rendercam()
	love.graphics.translate(-cam.pos.x,-cam.pos.y)
	local center = vec.new(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
	cam:setpos(player.pos-center) 
end

--render everything
function love.draw()
	rendercam()
	renderworld()
	updateinput()
	updatefullscreeninput()
end
