Player = Class{}

function Player:init(x, y, width, height, direction)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 4
    self.height = height or 4
    self.speed = 150
    self.bullets = {}
    self.direction = direction or 'up'
end

function Player:update(dt)
    if love.keyboard.isDown('up') then
        player.y = math.max(0, player.y + -player.speed * dt)
        player.direction = 'up'
    elseif love.keyboard.isDown('left') then
        player.x = math.max(0, player.x + -player.speed * dt)
        player.direction = 'left'
    elseif love.keyboard.isDown('right') then
        player.x = math.min(VIRTUAL_WIDTH-4, player.x + player.speed * dt)
        player.direction = 'right'
    elseif love.keyboard.isDown('down') then
        player.y = math.min(VIRTUAL_HEIGHT-4, player.y + player.speed * dt)
        player.direction = 'down'
    end
end

function Player:shoot()
    local bullet = {x = player.x+2, y = player.y+2, direction = player.direction}
    table.insert(player.bullets, bullet)
end

function Player:updatebullets(dt)
    for i = #player.bullets, 1, -1 do
        local bullet = player.bullets[i]
        if bullet.direction == 'up' then
            bullet.y = bullet.y-300*dt
        elseif bullet.direction == 'down' then
            bullet.y = bullet.y+300*dt
        elseif bullet.direction == 'left' then
            bullet.x = bullet.x-300*dt
        elseif bullet.direction == 'right' then
            bullet.x = bullet.x+300*dt
        end
    
        -- remove bullet if it goes off screen
        if bullet.y < 0 or bullet.y > VIRTUAL_HEIGHT or bullet.x < 0 or bullet.x > VIRTUAL_WIDTH then
            table.remove(player.bullets, i)
        end
    end
end

function Player:draw()
    love.graphics.setColor(1, 0.3, 0.3, 1)
    love.graphics.rectangle("fill", player.x, player.y, 4, 4)
    for _, bullet in ipairs(player.bullets) do
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle("fill", bullet.x, bullet.y, 2, 2)
    end
end