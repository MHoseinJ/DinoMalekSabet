---@type Color
local CactusColor

local spawnTimer = 0
local nextSpawnTime = 0

local MIN_SPAWN_TIME = 1.2
local MAX_SPAWN_TIME = 2.4

local CACTUS_GROUP_SPACING = 0.4

local CactusNumber = 0

local CACTUS_SIZES = {
    ["Assets/cactus-small.png"] = {
        minX = 0.55,
        maxX = 0.8,
        minY = 0.7,
        maxY = 1.0
    },

    ["Assets/cactus-medium.png"] = {
        minX = 0.8,
        maxX = 1.1,
        minY = 1.0,
        maxY = 1.4
    },

    ["Assets/cactus-big.png"] = {
        minX = 1.1,
        maxX = 1.5,
        minY = 1.4,
        maxY = 1.6
    }
}

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

    local textures = {
        "Assets/cactus-small.png",
        "Assets/cactus-medium.png",
        "Assets/cactus-big.png"
    }

    local texture = textures[math.random(1, #textures)]
    local size = CACTUS_SIZES[texture]

    local scaleX = math.random(
        math.floor(size.minX * 100),
        math.floor(size.maxX * 100)
    ) / 100

    local scaleY = math.random(
        math.floor(size.minY * 100),
        math.floor(size.maxY * 100)
    ) / 100

    cactus.transform.position:set(10 + offset, -1.4)
    cactus.transform.scale:set(scaleX, scaleY)

    ---@type Sprite
    local sprite = cactus:addComponent("sprite")
    sprite.path = texture
    sprite:reload()

    ---@type BoxCollider
    local collider = cactus:addComponent("boxCollider")
    collider.size = Vector2.new(
        0.8 * scaleX,
        1.2 * scaleY
    )
    collider:rebuildBody()

    print(
        "[Cactus]",
        cactus.name,
        "Texture:", texture,
        "Scale:", scaleX, scaleY,
        "Collider:", collider.size.x, collider.size.y
    )

    cactus.transform.position:set(offset, 0)

    cactus:addComponent("lua:Scripts/MoveLeft.lua")

    cactus.onCollisionEnter = function(other)
        if other.name == "MainPlayer" then
            Log.info("Cactus hit the player!")
        end
    end
end