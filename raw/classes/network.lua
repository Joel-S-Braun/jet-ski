--[[
    @12/3/17
    @skipleb studios
    @network.lua
    @hexadecival
--]]

local socket = require("socket")
local udp = socket.udp()
local datahandler = require("classes/datahandler")

--@hexadecival
--network class
local network = {}
function network:relay(name,func)
	self[name] = func
end
function network:connect(host,address,port)
	if host then
		udp:setsockname(address,port)
	else
		udp:setpeername(address,port)			
	end
	udp:settimeout(0)
end
function network:send(msg)
	udp:send(msg)
end
function network:update()
	data, msg = udp:receive()
	if msg ~= nil and msg ~= "timeout" and msg ~= "refused" then
		print("udp error: "..msg)
	end
	if data then
		if self[data] then
			self[data]()
		else
			print("udp error: corrupt or invalid packet")
		end
	end
end
return network