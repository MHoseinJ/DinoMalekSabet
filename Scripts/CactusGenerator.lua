---@type Color
local CactusColor

function start()
    CactusColor = Color.new(20, 200, 255)

    spawnCactus()
end

function spawnCactus()
    local cactus = Objects.create("Cactus")

    cactus.transform.position:set(10,-1)
    cactus.transform.scale:set(1, 20)

    local sprite = cactus:addComponent("sprite")
    sprite.color = CactusColor

    if cactus:addComponent("lua:Scripts/MoveLeft.lua") then
        Log.error("what the hell")
    end
end