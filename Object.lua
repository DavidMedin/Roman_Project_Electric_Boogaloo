 TILESIZE = 8
 WINDOW_X,WINDOW_Y = love.graphics.getDimensions()
function love.resize(w,h)
    WINDOW_X,WINDOW_Y = love.graphics.getDimensions()
end

local CAT_TILE = 1
local CAT_WALKABLE = 2
local CAT_ACTOR = 3
-- activeMap = map
activeWorld = world

_class = {}
function _class:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    -- o.__index = self
    -- o.parent = self
    return o
end
Tile = _class:new({
    x = 0,
    y = 0,
    path=nil,
    image=nil,
    name=nil,
    fixture=nil,
    shape=nil,
    scale=0,
    walkable = true,
    draw = function(self)
        self.x,self.y = self.image:getDimensions()
        love.graphics.draw(self.image,self.x,self.y,0,self.scale,self.scale)
    end,
    new = function(self,o)
        o = o or {} --stack overflow?
        o = _class.new(self,o)
        o.image = love.graphics.newImage(o.path)
        if o.world ~= nil then
            width,height = o.image:getDimensions()
            o.body = love.physics.newBody(o.world,o.x,o.y,"static")
            o.shape = love.physics.newRectangleShape(width,height)
            o.fixture = love.physics.newFixture(o.body,o.shape,1)
        end
        return o
        -- renderables[o.name] = o.name
    end
})

Actor = _class:new({
    name=nil,
    speed=0,
    imgWidth=0,
    imgHeight=0, --img is full file image
    texWidth=0, --tex is visible width
    texHeight=0,
    rectangle=nil, --polygon Shape
    image=nil,
    x=0,
    y=0,
    draw = function(self,index)
        -- local x,y = self.body:getPosition()
        self.x = self.body:getX()
        self.y = self.body:getY()
        quad = love.graphics.newQuad(self.texWidth*index,0,self.texWidth,self.imgHeight,self.imgWidth,self.imgHeight)
        -- love.graphics.draw(self.image,quad,x,y,0,activeMap:GetScale())
        love.graphics.draw(self.image,quad,self.x,self.y)
    end,
    new = function(self,o)
        o = _class.new(Actor,o)
        -- renderables[o.name] = o
        if o.path ~= nil then
            o.image = love.graphics.newImage(o.path)
        end
        love.graphics:getDimensions(o.image)
        o.imgWidth,o.imgHeight = o.image.getDimensions(o.image)
        if o.world ~= nil then
            o.body = love.physics.newBody(o.world,o.x,o.y,"dynamic")
            o.shape = love.physics.newRectangleShape(o.texWidth,o.imgHeight)
            o.fixture = love.physics.newFixture(o.body,o.shape,1)
        end
        return o
    end
})

_Map = _class:new({
    x=0,
    y=0,
    scale=0,
    imgWidth=0,
    imgHeight=0,
    colorTranslate = {{0,0,0,1,tile=nil}}, -- is a table
    world=nil,
    path=nil,
    mapImage=nil, --the image to be loaded to read
    mapImageData=nil, --the MapImage's Data
    tileList=nil, --list of Tiles
    CalculateScale = function(self)
        if self.imgWidth == nil then return nil end
        local scaleX = WINDOW_X/(self.imgWidth*TILESIZE)
        local scaleY = WINDOW_Y/(self.imgHeight*TILESIZE)
        local setScale
        if scaleX<scaleY then setScale=scaleX else setScale=scaleY end
        return setScale
    end,
    draw = function(self)
        self.imgWidth,self.imgHeight = self.mapImage:getDimensions()
        setScale = _Map.CalculateScale(self)
        for i,v in ipairs(self.tileList) do 
            -- love.graphics.draw(v.image,v.x,v.y,setScale)
            for i,v in ipairs(v) do
                v:draw()
            end
        end
    end,
    GetScale = function(self)
        return self.scale
    end,
    new = function(self,o)
        o = o or {}
        o = _class.new(_Map,o) --was Map.parent.new
    
    return o
    end
})