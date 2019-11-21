 TILESIZE = 8
 WINDOW_X,WINDOW_Y = love.graphics.getDimensions()
function love.resize(w,h)
    WINDOW_X,WINDOW_Y = love.graphics.getDimensions()
end

local GROUP_TILE = 1
local GROUP_WALKABLE = 2
local GROUP_ACTOR = 3
-- activeMap = map
activeWorld = world

function AddPhysics(o,bodyMode)
    o = o or {}
    if o.world ~= nil then
        o.body = love.physics.newBody(o.world,o.x,o.y,bodyMode)
        o.body:setFixedRotation(true)
        o.shape = love.physics.newRectangleShape(o.texWidth*o.scale/2+
                                                    (o.collisionOffsetX*o.scale/2),
                                                o.imgHeight*o.scale/2+
                                                    (o.collisionOffsetY*o.scale/2),
                                                o.texWidth*o.scale+
                                                    (o.collisionOffsetX*o.scale),
                                                o.imgHeight*o.scale+
                                                    (o.collisionOffsetY*o.scale))
        o.fixture = love.physics.newFixture(o.body,o.shape,1)
    end
    return o
end

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
    imgWidth=0,
    imgHeight=0, --img is full file image
    texWidth=0, --tex is visible width
    texHeight=0,
    path=nil,
    image=nil,
    name=nil,
    fixture=nil,
    shape=nil,
    scale=1,
    collisionOffsetX=0,
    collisionOffsetY=0,
    walkable = true,
    draw = function(self)
        self.x = self.body:getX()
        self.y = self.body:getY()
        love.graphics.draw(self.image,self.x,self.y,0,self.scale)
    end,
    new = function(self,o)
        o = o or {}
        o = _class.new(self,o)
        o.image = love.graphics.newImage(o.path)
        o.imgWidth,o.imgHeight = o.image.getDimensions(o.image)
        if o.texWidth == 0 then
            o.texWidth = o.imgWidth
            o.texHeight = o.imgHeight
        end
        o = AddPhysics(o,"static")
        if o.world ~= nil then
            o.fixture:setCategory(GROUP_TILE)
            if o.walkable then 
                o.fixture:setCategory(GROUP_TILE,GROUP_WALKABLE)
                o.fixture:setMask(GROUP_ACTOR)
            end
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
    collisionOffsetX=0,
    collisionOffsetY=0,
    rectangle=nil, --polygon Shape
    image=nil,
    scale=1,
    x=0,
    y=0,
    draw = function(self,index)
        -- local x,y = self.body:getPosition()
        self.x = self.body:getX()
        self.y = self.body:getY()
        quad = love.graphics.newQuad(self.texWidth*index,0,self.texWidth,self.imgHeight,self.imgWidth,self.imgHeight)
        -- love.graphics.draw(self.image,quad,x,y,0,activeMap:GetScale())
        love.graphics.draw(self.image,quad,self.x,self.y,0,self.scale)
    end,
    new = function(self,o)
        o = _class.new(self,o)
        -- renderables[o.name] = o
        if o.path ~= nil then
            o.image = love.graphics.newImage(o.path)
        end
        love.graphics:getDimensions(o.image)
        o.imgWidth,o.imgHeight = o.image.getDimensions(o.image)
        o = AddPhysics(o,"dynamic")
        o.fixture:setCategory(GROUP_ACTOR)
        o.fixture:setMask(GROUP_WALKABLE)
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
        o = _class.new(self,o) --was Map.parent.new
    
    return o
    end
})