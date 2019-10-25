require("Object")

local camX = 0
local camY = 0

renderables = {}

function love.load()
    love.graphics.setDefaultFilter("nearest")
    -- renderables.stone = Tile:new({path = "Data/StoneBrick.png"})
    -- renderables.stone.image = love.graphics.newImage(renderables.stone.path)
    pleb = Actor:new({path = "Data/Guard.png",name = "pleb",texWidth = 26})
end


function love.update(dt)
   
end



function love.draw()
    love.graphics.translate(camX,camY)
    for k,i in pairs(renderables) do
        i:draw(1)
    end
end