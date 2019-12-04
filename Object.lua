 TILESIZE = 8
 WINDOW_X,WINDOW_Y = love.graphics.getDimensions()
function love.resize(w,h)
    WINDOW_X,WINDOW_Y = love.graphics.getDimensions()
end

camX=0
camY=0

local CATA_TILE = 1
local CATA_WALKABLE = 2
local CATA_ACTOR = 3
local GROUP_ALL = -1
local GROUP_NONE = 0
activeWorld = world
activeMap = nil
renderables = {activeMap=nil,actors={}}
mapList = {}

function NormalizeTable(o)

end

function AddMap(map)
    mapList[#mapList+1] = map
end
function GetLoaded()
    -- count=0
    -- theOne=nil
    -- for k,v in pairs(mapList) do
    --     if v.isLoaded then
    --         count=count+1
    --         theOne=v
    --     end
    -- end
    -- if count == 1 then
    --     return theOne
    -- end
    loaded={}
    count=1
    for i,v in ipairs(mapList) do
        if v.loaded then
            loaded[count] = v
            count = count+1
        end
    end
    return loaded
end
function AddActorRenderables(o)
    if o.name ~= nil then
        renderables.actors[o.name]=o
    else
        print("no name field in AddActorRenderables table")
    end
end

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
--x,y,width,and height are in tiles
function NewPhysicsObject(x,y,width,height,type,world)
    object = {}
    object.body = love.physics.newBody(world,x*TILESIZE,y*TILESIZE,type)
    object.shape = love.physics.newPolygonShape(0,0,width*TILESIZE,0,width*TILESIZE,height*TILESIZE,0,height*TILESIZE,0,0)
    object.fixture = love.physics.newFixture(object.body,object.shape,1)
    return object
end



_class = {
    new = function(self,o)
        o = o or {}
        setmetatable(o, self)
        self.__index = self
        -- o.__index = self
        -- o.parent = self
        return o
    end
}
-- function _class:new(o)
--     o = o or {}
--     setmetatable(o, self)
--     self.__index = self
--     -- o.__index = self
--     -- o.parent = self
--     return o
-- end



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
        self.x = self.body~=nil and self.body:getX()/TILESIZE or self.x
        self.y = self.body~=nil and self.body:getY()/TILESIZE or self.y
        CentX,CentY = activeMap:CenterScreen()
        love.graphics.draw(self.image,self.x*TILESIZE*activeMap.scale+CentX,self.y*TILESIZE*activeMap.scale+CentY,0,self.scale*activeMap.scale)
    end,
    Enable = function(self,enable)
        if self.fixture~=nil then
            if enable then
                self.fixture:setGroupIndex(GROUP_NONE)
            else 
                self.fixture:setGroupIndex(GROUP_ALL)
            end
        end
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
        -- o = AddPhysics(o,"static")
        -- if o.world ~= nil then
        --     o.fixture:setCategory(CATA_TILE)
        --     o.fixture:setGroupIndex(GROUP_ALL)
        --     if o.walkable then 
        --         o.fixture:setCategory(CATA_TILE,CATA_WALKABLE)
        --         o.fixture:setMask(CATA_ACTOR)
        --     end
        -- end
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
        o.sensorShape = love.physics.newPolygonShape(o.shape:getPoints())
        o.sensor = love.physics.newFixture(o.body,o.sensorShape,1)
        o.sensor:setSensor(true)
        o.fixture:setCategory(CATA_ACTOR)
        o.fixture:setMask(CATA_WALKABLE)
        o.fixture:setGroupIndex(GROUP_ALL)
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
    tileList=nil, --list of Tiles
    finalX=0,
    finalY=0,
    body=nil,
    fixture=nil,
    shape=nil,
    realitiveY=nil, --is a map
    realitiveX=nil, --is a map
    modifyX=nil, --is a string
    modifyY=nil, --is a string
    loaded=false,
    FormatedScale = function(self)
        local WINDOW_X,WINDOW_Y = love.window.getMode()
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

                -- love.graphics.setColor(1,1,1)
                -- if pleb.body:isTouching(self.tileList[x][y].body) then
                --     love.graphics.setColor(1,0,0)
                -- end

                self.tileList[x][y]:draw(1)
             end
        end
    end,
    SetActive = function(self,active)
        if self.loaded == true then
            if activeMap==self then return end
            if activeMap ~= nil then
                for x=0,activeMap.imgWidth-1 do
                    for y=0,activeMap.imgHeight-1 do
                        activeMap.tileList[x][y]:Enable(false)
                    end
                end
            end
            for x=0,self.imgWidth-1 do
                for y=0,self.imgHeight-1 do
                    self.tileList[x][y]:Enable(true)
                end
            end
            activeMap=self
            renderables.activeMap = self
            camX=-self.finalX*self:FormatedScale()
            camY=-self.finalY*self:FormatedScale()
            -- camX=-self.finalX
            -- camY=-self.finalY
        else
            print("Don't try to activate a map before loading it!!")
        end
    end,
    SetAwake = function(self,awake)
        self.imgWidth,self.imgHeight = self.image:getDimensions()
        for x=0,self.imgWidth-1 do
            for y=0,self.imgHeight-1 do
                self.tileList[x][y].body:setAwake(awake)
            end
        end
    end,
    load = function(self,toggle)
        if toggle then
            if self.loaded == true then
                -- print("map already loaded!")
            else
                self.imageData = love.image.newImageData(self.path)
                for x=0,self.imgWidth-1 do
                    self.tileList[x] = {}
                    for y=0,self.imgHeight-1 do
                        local r,g,b,a = self.imageData:getPixel(x,y)
                        for i,v in ipairs(self.colorTranslate) do
                            if v[1]==r and v[2]==g and v[3]==b and v[4]==a then
                                self.tileList[x][y] = self.colorTranslate[i].tile:new({x=x+(self.finalX/TILESIZE),y=y+(self.finalY/TILESIZE),world=self.world})
                                self.scale = self:FormatedScale()
                            end
                        end
                    end
                end
            end
            self.loaded = true
        else
            self.loaded=false
        end
    end,
    OptimizeTile = function(self)
        self.imageDate = love.image.newImageDat(self.path)
        
        groups = {}
        finalGroups = {}
        for y=0,self.imgHeight-1 do
            groups[y]={}
            for x=0,self.imgWidth-1 do
                local r,g,b,a = self.imageData:getPixel(x,y)
                for i,v in ipairs(self.colorTranslate) do
                    if v[1]==r and v[2]==g and v[3]==b and v[4]==a then
                        local tile = v
                        local RecentGroup = groups[y][#groups[y]]
                        local RecentTile = groups[y][#groups[y]][#groups[y][#groups[y]]]
                        --phase 1
                            -- if previous tile is not the same, new group
                            --if is the same, join group
                        --phase 2
                            --start at y2, for through y2 and y1
                                --check if is same type,xstart, and length. if so, then join group in FinalGroup using belong pointer
                        if #groups[y] == 0 or groups[y][#groups[x]][1]~=tile then
                            groups[y][#groups[x]+1] = {tile}
                        else
                            groups[y][#groups[x]][#groups[y][#groups[x]]]=tile
                        end
                    end
                end
            end
        end
    end,
    new = function(self,o)
        o = o or {}
        o.tileList={}
        o = _class.new(self,o) --was Map.parent.new
        o.image = love.graphics.newImage(o.path)
        o.imgWidth,o.imgHeight = o.image:getDimensions()
        -- o.imgWidth,o.imgHeight = o.image.getDimensions(o.image)
        
        local realitiveX=0
        local realitiveY=0
        if o.realitiveX~=nil then realitiveX=o.realitiveX.x end
        if o.realitiveY~=nil then realitiveY=o.realitiveY.y end
        local applyModifyX=0
        local applyModifyY=0
        if o.modifyX ~= nil and string.find(o.modifyX,"width")~=nil then applyModifyX=o.imgWidth*TILESIZE if string.find(o.modifyX,"-")~=nil then applyModifyX=applyModifyX*-1 end end
        if o.modifyY ~= nil and string.find(o.modifyY,"height")~=nil then applyModifyY=o.imgHeight*TILESIZE if string.find(o.modifyY,"-")~=nil then applyModifyY=applyModifyY*-1 end end
        o.body = love.physics.newBody(o.world,o.x+applyModifyX+realitiveX,o.y+applyModifyY+realitiveY,"static")
        o.shape=love.physics.newRectangleShape((o.imgWidth*TILESIZE)/2,(o.imgHeight*TILESIZE)/2,o.imgWidth*TILESIZE,o.imgHeight*TILESIZE)
        o.fixture = love.physics.newFixture(o.body,o.shape,1)
        o.fixture:setSensor(true)
        o.finalX=o.x+applyModifyX+realitiveX
        o.finalY=o.y+applyModifyY+realitiveY

       AddMap(o)
    return o
    end
})