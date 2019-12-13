require("Object")


rectangle = nil
function love.load()
    love.graphics.setPointSize(5)
    love.physics.setMeter(1)
    love.window.setTitle("Revenge of the Pleb")
    love.window.setMode(800,500,{resizable=true})
    love.graphics.setDefaultFilter("nearest")
    world = love.physics.newWorld(0,0,true);


    _stone = Tile:new({path = "Data/StoneBrick.png",name="_stone"})
    _grass = Tile:new({path="Data/Grass.png",walkable=false,name="_grass"})
    _wood = Tile:new({path="Data/Wood.png",walkable=false,name="_wood"})
    _dirt = Tile:new({path="Data/Dirt.png",walkable=true,name="_dirt"})
    _woodBoard = Tile:new({path="Data/woodBoard.png",walkable=false,name="_woodBoard"})
    colorTranslate = {{[1] = 0,[2] = 0,[3] = 0,[4]=1,tile=_stone},
                     {[1]=1,[2]=0,[3]=0,[4]=1,tile=_grass},
                     {[1]=0,[2]=0,[3]=1,[4]=1,tile=_wood},
                     {[1]=0,[2]=1,[3]=0,[4]=1,tile=_dirt},
                     {[1]=0.4,[2]=0.4,[3]=0.4,[4]=1,tile=_woodBoard}}
                     
    colosseum = _Map:new({name="Colosseum",path="Data/Colosseum.png",world=world,colorTranslate=colorTranslate,x=0,y=0})
    vespesian = _Map:new({name="Vespesian",path="Data/Vespesian.png",world=world,colorTranslate=colorTranslate,realitiveY=colosseum,y=23*TILESIZE,modifyX="-width",x=0})
    shortcut = _Map:new({name="Shortcut",path="Data/Shortcut.png",world=world,colorTranslate=colorTranslate,realitiveY=vespesian,realitiveX=vespesian,x=vespesian.imgWidth*TILESIZE,y=42*TILESIZE})
    shortcutExit = _Map:new({name="ShortcutExit",path="Data/ShortcutExit.png",world=world,colorTranslate=colorTranslate,realitiveX=shortcut,realitiveY=shortcut,x=43*TILESIZE,y=shortcut.imgHeight*TILESIZE})

    vespesian:load(true)
    vespesian:SetActive(true)
    pleb = Actor:new({speed = 100,path = "Data/Guard.png",name = "pleb",texWidth = 26,x=colosseum.imgWidth/2,y=colosseum.imgHeight/2,world=world,collisionOffsetX=-9,scale=1})
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
    -- if moved then 
    --     PlebRectangle = love.graphics.newQuad(pleb.x*activeMap.scale,pleb.y*activeMap.scale,)
    -- end
    

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

        for k,v in pairs(mapList) do
            love.graphics.polygon("line",v.body:getWorldPoints(v.shape:getPoints()))
        end


    love.graphics.setCanvas()
end

function love.resize(w,h)
    WINDOW_X = w
    WINDOW_Y = h
    activeMap.scale = activeMap:FormatedScale()
    GlobalCanvas = love.graphics.newCanvas(WINDOW_X,WINDOW_Y)
    local centX,CentY = activeMap:CenterScreen()
    camX = -activeMap.finalX*activeMap:FormatedScale()+centX
    camY = -activeMap.finalY*activeMap:FormatedScale()+CentY
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