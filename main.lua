require("Object")


rectangle = nil
function love.load()
    love.graphics.setPointSize(5)
    love.physics.setMeter(1)
    love.window.setTitle("Revenge of the Pleb")
    love.window.setMode(800,500,{resizable=true})
    love.graphics.setDefaultFilter("nearest")
    world = love.physics.newWorld(0,0,true);


    _stone = Tile:new({path = "Data/StoneBrick.png",scale=1,name="_stone"})
    _grass = Tile:new({path="Data/Dirt.png",walkable=false,scale=1,name="_grass"})
    colorTranslate = {{[1] = 0,[2] = 0,[3] = 0,[4]=1,tile=_stone},
                     {[1]=1,[2]=0,[3]=0,[4]=1,tile=_grass}}
                     
                     -- level_1 = _Map:new({name="level_1",path = "Data/RGBMap.png",world=world,colorTranslate=colorTranslate,x=0,y=0})
    -- level1 = _Map:new({name="level1",path="Data/level-1.png",world=world,colorTranslate=colorTranslate,realitiveY=level_1,modifyY="-height",y=0})
    level_1 = _Map:new({name="Level_1",path="Data/Hallway.png",world=world,colorTranslate=colorTranslate,x=0,y=0})
    level_2 = _Map:new({name="Level_2",path="Data/Level-1.png",world=world,colorTranslate=colorTranslate,realitiveY=level_1,y=level_1.imgHeight*8,realitiveX=level_1,x=-12*8})
    -- level_2 = _Map:new({name="Level_2",path="Data/Level-1.png",world=world,colorTranslate=colorTranslate,y=0,x=0})
    level_1:load(true)
    level_1:SetActive(true)
    pleb = Actor:new({speed = 100,path = "Data/Guard.png",name = "pleb",texWidth = 26,x=6,y=1,world=world,collisionOffsetX=-9,scale=1})
    AddActorRenderables(pleb)
end


function love.update(dt)
    world:update(dt)
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
    moved = false
    if love.keyboard.isDown("a") then
        x = x + -pleb.speed
        moved = true
    end
    if love.keyboard.isDown("d") then
        x = x + pleb.speed
        moved = true
    end
    if love.keyboard.isDown("w") then
        y = y -pleb.speed
        moved = true
    end
    if love.keyboard.isDown("s") then
        y = y + pleb.speed
        moved = true
    end
    pleb.body:setLinearVelocity(x,y)
    if moved then 
        PlebRectangle = love.graphics.newQuad(pleb.x*activeMap.scale,pleb.y*activeMap.scale,)
    end
    

    -- print("Memory Used in KB:" .. collectgarbage("count"))
    love.graphics.setCanvas(GlobalCanvas)
    

        love.graphics.clear()
        love.graphics.translate(camX,camY)
        love.graphics.setColor(1,1,1)
        if renderables.activeMap ~= nil then
            renderables.activeMap:draw(1)
        end
        for k,i in pairs(renderables.actors) do
            i:draw(1)
        end

    love.graphics.setCanvas()
end

function love.resize(w,h)
    WINDOW_X = w
    WINDOW_Y = h
    activeMap.scale = activeMap:FormatedScale()
    GlobalCanvas = love.graphics.newCanvas(WINDOW_X,WINDOW_Y)
end


function love.draw()
    -- love.graphics.translate(camX,camY)
    -- love.graphics.setColor(1,1,1)
    -- if renderables.activeMap ~= nil then
    --     renderables.activeMap:draw(1)
    -- end
    -- for k,i in pairs(renderables.actors) do
    --     i:draw(1)
    -- end
    love.graphics.draw(GlobalCanvas)

    -- love.graphics.translate(-camX,-camY-50)
    -- for k,v in pairs(world:getBodies()) do
    --     love.graphics.polygon("line",v:getWorldPoints(v:getFixtures()[1]:getShape():getPoints()))
    -- end
    -- love.graphics.polygon("line",level_1.body:getWorldPoints(level_1.shape:getPoints()))
    -- love.graphics.polygon("line",pleb.body:getWorldPoints(pleb.shape:getPoints()))
    -- love.graphics.polygon("line",level_2.body:getWorldPoints(level_2.shape:getPoints()))
end