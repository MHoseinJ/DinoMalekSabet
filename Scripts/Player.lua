local JumpingForce = Vector2.new(0, 2)
---@type Rigidbody
local rigidbody
---@type GameObject
local GroundGameObject

function start()
    rigidbody = owner:getComponent("rigidbody")
    if not rigidbody then
        Log.error("Player.lua: rigidbody not found")
    end

    GroundGameObject = Objects.find("Ground")
    if not GroundGameObject then
        Log.error("Player.lua: ground not found")
    end
end