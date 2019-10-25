require("Object")

local camX = 0
local camY = 0

renderables = {}

function love.load()
    love.graphics.setDefaultFilter("nearest")
    stone = Tile:new({path = "Data/StoneBrick.png",scale = 10})
    
    pleb = Actor:new({speed = 100,path = "Data/Guard.png",name = "pleb",texWidth = 26})
    map = _Map:new({path = "Data/RGBMap.png",colorTranslate=
    {{[1] = 0,[2] = 0,[3] = 0,tile = stone.image}}
})
end


function love.update(dt)
   if love.keyboard.isDown("a") then
        pleb.x = pleb.x - pleb.speed * dt
   end
   if love.keyboard.isDown("d") then
    pleb.x = pleb.x + pleb.speed * dt
   end
   if love.keyboard.isDown("w") then
    pleb.y = pleb.y - pleb.speed * dt
   end
   if love.keyboard.isDown("s") then
    pleb.y = pleb.y + pleb.speed * dt
   end
end



function love.draw()
    love.graphics.translate(camX,camY)
    for k,i in pairs(renderables) do
        i:draw(1)
    end
    map:draw()
end