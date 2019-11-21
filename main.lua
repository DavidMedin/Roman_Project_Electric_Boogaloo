require("Object")

local camX = 0
local camY = 0

renderables = {}

function love.load()
    love.graphics.setPointSize(5)
    love.physics.setMeter(1)
    love.window.setMode(800,500,{resizable=true})
    love.graphics.setDefaultFilter("nearest")

    world = love.physics.newWorld(0,0,false);
    _stone = Tile:new({path = "Data/StoneBrick.png",scale=5})
    _grass = Tile:new({path="Data/Grass.png",walkable=false,scale=5})
--     map = _Map:new({path = "Data/RGBMap.png",colorTranslate=
--     {{[1] = 0,[2] = 0,[3] = 0,[4]=1,tile = stone},
--     {[1]=1,[2]=0,[3]=0,[4]=1,tile=grass}}
-- })
    -- activeMap = map
    pleb = Actor:new({speed = 100,path = "Data/Guard.png",name = "pleb",texWidth = 26,x=80,y=80,world=world,scale=4,collisionOffsetX=-9})
    renderables.pleb = pleb
    -- renderables.map = map
    testGrass = _grass:new({x=100,y=90,world=world})
    renderables.testGrass = testGrass
    testStone = _stone:new({x=50,y=50,world=world})
    renderables.testStone = testStone
end


function love.update(dt)
    world:update(dt)


    local x,y = 0,0
   if love.keyboard.isDown("a") then
        x = x + -pleb.speed
    end
   if love.keyboard.isDown("d") then
        x = x + pleb.speed
    end
    if love.keyboard.isDown("w") then
        y = y -pleb.speed
    end
    if love.keyboard.isDown("s") then
        y = y + pleb.speed
    end
    pleb.body:setLinearVelocity(x,y)
    -- pleb.x = pleb.x + x;
    -- pleb.y = pleb.y + y;
end



function love.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.translate(camX,camY)
    for k,i in pairs(renderables) do
        i:draw(1)
    end

    for _,body in pairs(world:getBodies()) do
        for _,fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()
            love.graphics.polygon("line",body:getWorldPoints(shape:getPoints()))
        end
    end
    love.graphics.setColor(1,0,0)
    love.graphics.points(pleb.body:getX(),pleb.body:getY())
    love.graphics.setColor(1,1,1)

end