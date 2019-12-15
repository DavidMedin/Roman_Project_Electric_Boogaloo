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
    _dirt = Tile:new({path="Data/Dirt.png",name="_dirt"})
    _woodBoard = Tile:new({path="Data/woodBoard.png",walkable=false,name="_woodBoard"})
    _darkStone = Tile:new({path="data/Darkstone.png",walkable=true,name="DarkStone"})
    colorTranslate = {{[1] = 0,[2] = 0,[3] = 0,[4]=1,tile=_stone},
                     {[1]=1,[2]=0,[3]=0,[4]=1,tile=_grass},
                     {[1]=0,[2]=0,[3]=1,[4]=1,tile=_wood},
                     {[1]=0,[2]=1,[3]=0,[4]=1,tile=_dirt},
                     {[1]=0.4,[2]=0.4,[3]=0.4,[4]=1,tile=_woodBoard},
                     {[1]=0.7,[2]=0.7,[3]=0.7,[4]=1,tile=_darkStone}}
    _Map.world = world
    _Map.colorTranslate = colorTranslate
    colosseum = _Map:new({name="Colosseum",path="Data/Colosseum.png",x=0,y=0})
    vespesian = _Map:new({name="Vespesian",path="Data/Vespesian.png",realitiveY=colosseum,y=23*TILESIZE,modifyX="-width",x=0})
    shortcut = _Map:new({name="Shortcut",path="Data/Shortcut.png",realitiveY=vespesian,realitiveX=vespesian,x=vespesian.imgWidth*TILESIZE,y=42*TILESIZE})
    shortcutExit = _Map:new({name="ShortcutExit",path="Data/ShortcutExit.png",realitiveX=shortcut,realitiveY=shortcut,x=43*TILESIZE,y=shortcut.imgHeight*TILESIZE})
    brokenWall = _Map:new({name="BrokenWall",path="Data/BrokenWall.png",realitiveX=shortcutExit,realitiveY=shortcutExit,x=1*TILESIZE,y=shortcutExit.imgHeight*TILESIZE})
    hallway = _Map:new({name="Hallway",path="Data/Hallway.png",realitiveY=brokenWall,realitiveX=brokenWall,x=32*TILESIZE,y=brokenWall.imgHeight*TILESIZE})
    senate = _Map:new({name="Senate",path="Data/Senate.png",realitiveY=hallway,realitiveX=hallway,x=hallway.imgWidth*TILESIZE,y=31*TILESIZE})
    pleb = Actor:new({speed = 100,path = "Data/Guard.png",name = "pleb",texWidth = 26,x=colosseum.imgWidth/2,y=colosseum.imgHeight/2,world=world,collisionOffsetX=-9,scale=1})
    -- caesar = Actor:new({path="Data/Caesar.png",name="Caesar",texwidth=24,x=senate.finalX+senate.imgWidth/3*2,y=senate.finalY+senate.imgHeight/3*2,world=world})

    caesar = Actor:new({path="Data/Caesar.png",name="Caesar",walkable=false,x=colosseum.imgWidth/2*TILESIZE,y=colosseum.imgHeight/2*TILESIZE,noPhysics=true,texWidth=24})
    caesarBox = NewPhysicsObject(caesar.x,caesar.y,24/TILESIZE,24/TILESIZE,"static",world)
    TogglePhysicsObject(caesarBox,true)
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
        if pleb.body:isTouching(caesarBox.body) then
            love.graphics.setcolor(1,0,0)            
            print("Boi")
        end
        caesar:draw(1)
        -- love.graphics.translate(-camX,-camY+50)
        love.graphics.polygon("line",caesarBox.body:getWorldPoints(caesarBox.shape:getPoints()))
        -- for k,v in pairs(mapList) do
        --     love.graphics.polygon("line",v.body:getWorldPoints(v.shape:getPoints()))
        -- end
        -- love.graphics.translate(camX,camY-50)


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