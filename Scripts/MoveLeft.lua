local Speed = 4

function update(dt)
    owner.transform.position.x = owner.transform.position.x - (Speed * dt)
end