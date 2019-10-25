_class = {}
function _class:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.parent = self
    return o
end
Tile = {
    x = 0,
    y = 0,
    path = nil,
    image = nil,
    walkable = true
}
Tile = _class:new(Tile)
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