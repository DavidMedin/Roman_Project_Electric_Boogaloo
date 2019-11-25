 TILESIZE = 8
 WINDOW_X,WINDOW_Y = love.graphics.getDimensions()
function love.resize(w,h)
    WINDOW_X,WINDOW_Y = love.graphics.getDimensions()
end

local GROUP_TILE = 1
local GROUP_WALKABLE = 2
local GROUP_ACTOR = 3
GLOBAL_ITER = 4
activeWorld = world

function AddPhysics(o,bodyMode)
    o = o or {}
    if o.world ~= nil then
        o.body = love.physics.newBody(o.world,o.x*TILESIZE,o.y*TILESIZE,bodyMode)
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
        CentX,CentY = activeMap:CenterScreen()
        love.graphics.draw(self.image,self.x*activeMap.scale+CentX,self.y*activeMap.scale+CentY,0,self.scale*activeMap.scale)
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
        CentX,CentY = activeMap:CenterScreen()
        love.graphics.draw(self.image,quad,self.x*activeMap.scale+CentX,self.y*activeMap.scale+CentY,0,self.scale*activeMap.scale)
    
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
    image=nil, --the image to be loaded to read
    imageData=nil, --the MapImage's Data
    tileList={}, --list of Tiles
    FormatedScale = function(self)
        local setScale = 1
        if self.imgHeight >= self.imgWidth then
            setScale = WINDOW_Y/(self.imgHeight*8)
        else 
            setScale = WINDOW_X/(self.imgWidth*8)
        end
        return setScale
    end,
    CenterScreen = function(self)
        local DifX=0
        local DifY=0
        if self.imgHeight >= self.imgWidth then
            DifX=(WINDOW_X-self.imgWidth*TILESIZE*self:FormatedScale())/2
        else 
            DifY=(WINDOW_Y-self.imgHeight*TILESIZE*self:FormatedScale())/2
        end
        return DifX,DifY
    end,
    draw = function(self)
        self.imgWidth,self.imgHeight = self.image:getDimensions()
        for x=0,self.imgWidth-1 do
            for y=0,self.imgHeight-1 do
                -- self.tileList[x][y].scale = self.scale
                 self.tileList[x][y]:draw(1)
             end
        end
    end,
    GetScale = function(self)
        return self.scale
    end,
    new = function(self,o)
        o = o or {}
        o = _class.new(self,o) --was Map.parent.new
        o.image = love.graphics.newImage(o.path)
        o.imgWidth,o.imgHeight = o.image:getDimensions()
        -- o.imgWidth,o.imgHeight = o.image.getDimensions(o.image)
        o.imageData = love.image.newImageData(o.path)
        for x=0,o.imgWidth-1 do
            o.tileList[x] = {}
            for y=0,o.imgHeight-1 do
                local r,g,b,a = o.imageData:getPixel(x,y)
                for i,v in ipairs(o.colorTranslate) do
                    if v[1]==r and v[2]==g and v[3]==b and v[4]==a then
                        o.tileList[x][y] = o.colorTranslate[i].tile:new({x=x,y=y,world=o.world})
                        o.scale = o:FormatedScale()
                    end
                end
            end
        end
    return o
    end
})