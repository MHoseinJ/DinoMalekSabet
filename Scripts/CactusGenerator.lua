
---@type Color
local CactusColor

local spawnTimer = 0
local nextSpawnTime = 0

local MIN_SPAWN_TIME = 1.2
local MAX_SPAWN_TIME = 2.4

local CACTUS_GROUP_SPACING = 0.3

local CactusNumber = 0

function start()
    CactusColor = Color.new(20, 200, 255)

    nextSpawnTime = math.random() *
        (MAX_SPAWN_TIME - MIN_SPAWN_TIME) + MIN_SPAWN_TIME
end

function update(deltaTime)
    spawnTimer = spawnTimer + deltaTime

    if spawnTimer >= nextSpawnTime then
        spawnCactusGroup()

        spawnTimer = 0

        nextSpawnTime = math.random() *
            (MAX_SPAWN_TIME - MIN_SPAWN_TIME) + MIN_SPAWN_TIME
    end
end

function spawnCactusGroup()
    local roll = math.random(1, 100)
    local groupSize

    if roll <= 65 then
        groupSize = 1
    elseif roll <= 90 then
        groupSize = 2
    else
        groupSize = 3
    end

    for i = 0, groupSize - 1 do
        spawnCactus(i * CACTUS_GROUP_SPACING)
    end
end

function spawnCactus(offset)
    local cactus = Objects.create("Cactus" .. CactusNumber)
    CactusNumber = CactusNumber + 1

    local cactusHeight = math.random(30, 55) / 10

    cactus.transform.position:set(10 + offset, -1.4)
    cactus.transform.scale:set(1, cactusHeight)

    local sprite = cactus:addComponent("sprite")
    sprite.color = CactusColor

    cactus:addComponent("lua:Scripts/MoveLeft.lua")
end