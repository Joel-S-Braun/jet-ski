--[[
    @12/3/17
    @skipleb studios
    @datahandler.lua
    @hexadecival
--]]

--@hexadecival
--datahandler class
local datahandler = {}
function datahandler:encrypt(t)	
	local s = ""
	for k, v in pairs (t) do
		s = s..k.."="..v.." "
	end
	return s
end
function datahandler:decrypt(s)
	local t = {}
	for key, var in s:gmatch("(%a+)%s?=%s?(%d+)") do 
	    t[key] = var
	end	
	return t
end
return datahandler