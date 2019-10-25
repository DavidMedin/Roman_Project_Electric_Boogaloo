_class = {}
function _class:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.parent = self
    return o
end
Tile = _class:new({
    x = 0,
    y = 0,
    path,
    image,
    name,
    walkable = true,
    draw = function(self)
        love.graphics.draw(self.image,self.x,self.y)
    end,
    new = function(self,o)
        o = o or {}
        o = Tile.parent.new(Tile,o)
        o.image = love.graphics.newImage(o.path)
        return o
        -- renderables[o.name] = o.name
    end
})

Actor = _class:new({
    name,
    imgWidth,
    imgHeight,
    texWidth,
    texHeight = 0,
    image,
    x = 0,y = 0,
    draw = function(self,index)
        quad = love.graphics.newQuad(self.texWidth*index,0,self.texWidth,self.imgHeight,self.imgWidth,self.imgHeight)
        love.graphics.draw(self.image,quad,self.x,self.y,0,2,2)
    end
})
--name is required
function Actor:new(o)
    o = Actor.parent.new(Actor,o)
    renderables[o.name] = o
    if o.path ~= nil then
        o.image = love.graphics.newImage(o.path)
    end
    o.imgWidth,o.imgHeight = o.image:getDimensions()
    return o
end

_Map = _class:new({
    x,y,
    imgWidth,
    imgHeight,
    colorTranslate, -- is a table
    path,
    mapImage, --the image to be loaded to read
    mapImageData,
    mapData, --end result data
    draw = function(self)
    end,
    new = function(self,o)
        o = _Map.parent.new(_Map,o)
        o.mapImage = love.graphics.newImage(o.path)
        o.mapImageData = love.image.newImageData(o.path)
        o.imgWidth,o.imgHeight = o.mapImage:getDimensions()
        for x = 0, o.imgWidth - 1 do
            for y = 0, o.imgHeight - 1 do
                local r,g,b,a = o.mapImageData:getPixel(x,y)
            end
        end
    end
})