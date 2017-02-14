--[[
    @12/3/17
    @skipleb studios
    @client(?)
    @hexadecival & waffloid
--]]




--ik i put everything into do ends sorry i have OCD even

--@hexadecival
--@Vector2 class
do
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
end



--@hexadecival
--cam class
do
    cam = {
        pos = vec.new(0,0)
    }
    function cam:move(pos)
        self.pos = self.pos + pos
    end
    function cam:setpos(pos)
        self.pos = pos
    end
end




--@hexadecival
--object class
do
    obj = {}
    obj.__index = obj 
    function obj.new(pos)
        return setmetatable({pos=pos},obj)
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
end



local ski = obj.new(vec.new(5,5))
function love.draw()
    --cam render
    love.graphics.translate(cam.pos.x,cam.pos.y)
    --dlc
    ski:draw()
    cam:setpos(ski.pos)
    --movement
    local w = love.keyboard.isDown("w")
    local a = love.keyboard.isDown("a")
    local s = love.keyboard.isDown("s")
    local d = love.keyboard.isDown("d")
    local mx = a and -1 or d and 1 or 0
    local my = w and -1 or s and 1 or 0
    local mv = vec.new(mx,my)
    ski:move(mv)
end