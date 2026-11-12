local JumpingForce = Vector2.new(0, 8)

---@type Rigidbody
local rigidbody

---@type GameObject
local GroundGameObject

local isGrounded = false

function start()
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
        isGrounded = true
    end

    owner.onCollisionExit = function(other)
        isGrounded = false
    end
end

function update(dt)
    if isGrounded and Input.keyPressed(Key.UP) then
        rigidbody:applyImpulse(JumpingForce)
        isGrounded = false
    end
end