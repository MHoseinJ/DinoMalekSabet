local JumpingForce = Vector2.new(0, 11)

---@type Rigidbody
local rigidbody

---@type Audio
local audio

---@type GameObject
local GroundGameObject

local isGrounded = false

local timer = 0
local ran = false

local STRETCH = Vector2.new(0.75, 1.50)
local NORMAL  = Vector2.new(1.0, 1.0)

local SQUASH_SPEED = 12.0

local scaleTarget = NORMAL
local baseScale   = Vector2.new(1, 1)

function start()
    
    local t = owner.transform.scale
    baseScale = Vector2.new(t.x, t.y)
    scaleTarget = baseScale

    AudioSystem.load("jump", "Assets/yipee.mp3", false)
    AudioSystem.load("engine-start", "Assets/engine-start.wav", true)
    AudioSystem.load("engine-idle", "Assets/engine-idle.wav", false)

    audio = owner:addComponent("audio")

    rigidbody = owner:getComponent("rigidbody")
    if not rigidbody then
        Log.error("Player.lua: rigidbody not found")
        return
    end

    GroundGameObject = Objects.find("Ground")
    if not GroundGameObject then
        Log.error("Player.lua: ground not found")
        return
    end

    owner.onCollisionEnter = function(other)
        if other.name == "BottomCollider" then
            Log.clear()
        end
        isGrounded = true
        setJumpSquash(false)
    end

    owner.onCollisionExit = function(other)
        isGrounded = false
    end

    audio:Play("engine-start", 0)
end

function update(dt)
    if timer > 1 and not ran then
        audio:Play("engine-idle", -1)
        ran = true
    else
        timer = timer + dt
    end
    if isGrounded and Input.keyPressed(Key.UP) then
        rigidbody:applyImpulse(JumpingForce)
        audio:Play("jump", 0)
        isGrounded = false
        setJumpSquash(true)
    end

    local s = owner.transform.scale
    local k = math.min(1.0, SQUASH_SPEED * dt)
    s.x = s.x + (scaleTarget.x - s.x) * k
    s.y = s.y + (scaleTarget.y - s.y) * k
end

function setJumpSquash(active)
    if active then
        scaleTarget = Vector2.new(baseScale.x * STRETCH.x,
                                  baseScale.y * STRETCH.y)
    else
        scaleTarget = baseScale
    end
end