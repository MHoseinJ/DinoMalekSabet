local Speed = 5

local PATH = {
    { x = 5, y = -5 },
    { x = 5, y =  -1.2 },
    { x = -5, y = -1.2 },
    { x = -5, y = -10 },
}

-- Rotation (degrees) for each segment: up, left, down.
-- If it turns the wrong way, negate the values (0, -90, -180).
local ROTATIONS = { -90, 0, 90 }

local segment = 1

local function applyRotation()
    owner.transform.rotation = ROTATIONS[math.min(segment, #ROTATIONS)]
end

local function advanceToNextSegment()
    segment = segment + 1
    if segment > #PATH then
        segment = 1
    end
    applyRotation()
end

function start()
    -- The generator passes the group spacing in position.x
    local lag = owner.transform.position.x

    segment = 1
    owner.transform.position.x = PATH[1].x
    owner.transform.position.y = PATH[1].y - lag  -- behind the start of segment 1
    applyRotation()
end

function update(dt)
    local budget = Speed * dt
    local guard = 0

    while budget > 0 and guard < 8 do
        guard = guard + 1

        local from = PATH[segment]
        local to   = PATH[(segment % #PATH) + 1]

        local dx = to.x - from.x
        local dy = to.y - from.y
        local len = math.sqrt(dx * dx + dy * dy)

        if len < 1e-6 then
            advanceToNextSegment()
        else
            local px = owner.transform.position.x
            local py = owner.transform.position.y
            local remain = math.sqrt((to.x - px) * (to.x - px) + (to.y - py) * (to.y - py))

            if budget >= remain then
                owner.transform.position.x = to.x
                owner.transform.position.y = to.y
                budget = budget - remain

                -- Reached the last point: keep sliding down in the same direction.
                if segment == #PATH - 1 then
                    owner.transform.position.y = owner.transform.position.y - budget
                    return
                end

                advanceToNextSegment()
            else
                owner.transform.position.x = px + (dx / len) * budget
                owner.transform.position.y = py + (dy / len) * budget
                budget = 0
            end
        end
    end
end