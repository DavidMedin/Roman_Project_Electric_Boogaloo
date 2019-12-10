require("Object")


rectangle = nil
function love.load()
    love.graphics.setPointSize(5)
    love.physics.setMeter(1)
    love.window.setMode(800,500,{resizable=true})
    love.graphics.setDefaultFilter("nearest")
    world = love.physics.newWorld(0,0,true);


    _stone = Tile:new({path = "Data/StoneBrick.png",scale=1,name="_stone"})
    _grass = Tile:new({path="Data/Dirt.png",walkable=false,scale=1,name="_grass"})
    colorTranslate = {{[1] = 0,[2] = 0,[3] = 0,[4]=1,tile=_stone},
                     {[1]=1,[2]=0,[3]=0,[4]=1,tile=_grass}}
                     
                     -- map = _Map:new({name="map",path = "Data/RGBMap.png",world=world,colorTranslate=colorTranslate,x=0,y=0})
    -- level1 = _Map:new({name="level1",path="Data/level-1.png",world=world,colorTranslate=colorTranslate,realitiveY=map,modifyY="-height",y=0})
    map = _Map:new({name="Rooms",path="Data/Rooms.png",world=world,colorTranslate=colorTranslate,x=0,y=0})
    map:load(true)
    map:SetActive(true)
    pleb = Actor:new({speed = 100,path = "Data/Guard.png",name = "pleb",texWidth = 26,x=6,y=1,world=world,collisionOffsetX=-9,scale=1})
    AddActorRenderables(pleb)
end


function love.update(dt)
    print("{")
    world:update(dt)
    print("}")
    print("...")
    for k,v in pairs(mapList) do
        if pleb.body:isTouching(v.body) then
            v:load(true)
        else
            v:load(false)
        end
    end
    
    if #GetLoaded() == 1 then
        GetLoaded()[1]:SetActive(true)
    end
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
    -- print("Memory Used in KB:" .. collectgarbage("count"))
end

function love.resize(w,h)
    WINDOW_X = w
    WINDOW_Y = h
    activeMap.scale = activeMap:FormatedScale()
end


function love.draw()
    love.graphics.translate(camX,camY)
    love.graphics.setColor(1,1,1)
    if renderables.activeMap ~= nil then
        renderables.activeMap:draw(1)
    end
    for k,i in pairs(renderables.actors) do
        i:draw(1)
    end

    -- for _,body in pairs(world:getBodies()) do
        
    --     for _,fixture in pairs(body:getFixtures()) do
    --         local shape = fixture:getShape()
    --         love.graphics.polygon("line",body:getWorldPoints(shape:getPoints()))
    --     end
    -- end
    -- love.graphics.setColor(1,0,0)
    -- love.graphics.points(pleb.body:getX(),pleb.body:getY())
    -- love.graphics.setColor(1,1,1)
    
    
    -- love.graphics.translate(camX,camY)
    -- love.graphics.setColor(1,0,0)
    -- if pleb.body:isTouching(map.body) then love.graphics.setColor(1,1,1) end
    -- love.graphics.polygon("line",map.body:getWorldPoints(map.shape:getPoints()))
    -- love.graphics.polygon("line",pleb.body:getWorldPoints(pleb.shape:getPoints()))
    -- love.graphics.setColor(1,0,1)
    -- if pleb.body:isTouching(level1.body) then love.graphics.setColor(1,1,1) end

    -- love.graphics.polygon("line",level1.body:getWorldPoints(level1.shape:getPoints()))
    -- love.graphics.setColor(1,1,1)
    -- love.graphics.translate(-camX,-camY)
end