--[[
    @2/21/17
    @skipleb studios
    @tilemap.lua
    @hexadecival
--]]

--@hexadecival
--tilemap class
local tilemap = {
	tiledata = {
		[0] = nil, --air
		[1] = {image="box",size=vec.new(24,24)}, --solid
		[5] = {image=love.graphics.newImage("images/mandem_idle.png"),size=vec.new(2,2)} --roadman
	}
}
function tilemap:load(mapdata)
	local tiles = mapdata.tiles
	local tilesize = mapdata.tilesize
	local x = 0
	local y = 0
	for i = 1, #tiles do
		x = x + 1
		local tile = self.tiledata[tiles[i]]
		if tile ~= nil then
			obj.new(tile.image,vec.new(tilesize*x,tilesize*y),tile.size,"tile"..x.."|"..y)
		end
		if x == mapdata.width then
			x = 0
			y = y + 1
		end
	end
end
return tilemap