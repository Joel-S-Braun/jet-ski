--[[
    @12/3/17
    @skipleb studios
    @core engine
    @hexadecival & waffloid
--]]

--classes
local render = require("classes/render")
local vec = require("classes/vector")
local cam = require("classes/camera")
local obj = require("classes/object")
local rigidbody = require("classes/rigidbody")
local anim = require("classes/animation")
local tilemap = require("classes/tilemap")
local datahandler = require("classes/datahandler")
local network = require("classes/network")

--data
local mapdata = require("maps/test")

--game code
do

	--@hexadecival
	--world creation
	local player
	local player_animator
	local player_controller
	do
		player = obj.new(love.graphics.newImage("images/mandem_idle.png"),vec.new(5,5),vec.new(2,2),"player")
		cam.target = player
		player_controller = rigidbody.new(player,vec.new(0,0),vec.new(0.1,0.1),vec.new(4,4))
		player_animator = anim.new(player,"mandem_anims")
		player_animator:play()
		tilemap:load(mapdata)
	end

	--@hexadecival
	--handle input
	function updateinput()
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
	--handle networking
	network:relay("updatepos",function()
		print("success! ")
	end)
	math.randomseed(os.time())
	if math.random(1,2) == 2 then
		server = true
	else
		server = false
	end
	print(server)
	network:connect(server,"localhost",5000)
	local t = 0
	function updateclient()
		if not server then
			t = t + 1/60
			if t > 0.04 then
				network:send("updatepos")
				t = 0
			end
		end
	end
end

--core loop
function love.draw()
	cam:update()
	render:update()
	updateinput()
	updateclient()
	network:update()
end