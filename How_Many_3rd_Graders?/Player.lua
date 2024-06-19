Player = Class{}

-- initial parameters for player
function Player:init(x, y, width, height, direction)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 4
    self.height = height or 4
    self.speed = 150
    self.bullets = {}
    self.direction = direction or 'up'
end

-- update player position
function Player:update(dt)
    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        self.y = math.max(0, player.y + -player.speed * dt)
        self.direction = 'up'
    elseif love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.x = math.max(0, player.x + -player.speed * dt)
        self.direction = 'left'
    elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self.x = math.min(VIRTUAL_WIDTH-4, player.x + player.speed * dt)
        self.direction = 'right'
    elseif love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        self.y = math.min(VIRTUAL_HEIGHT-4, player.y + player.speed * dt)
        self.direction = 'down'
    end
end

-- how the bullets will be represented
function Player:shoot()
    local bullet = {x = self.x+2, y = self.y+2, direction = self.direction}
    -- stored in a table
    table.insert(self.bullets, bullet)
end

-- update the bullets position over time
function Player:updatebullets(dt)
    for i = #player.bullets, 1, -1 do
        local bullet = self.bullets[i]
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
            table.remove(self.bullets, i)
        end
    end
end

function Player:draw()
    love.graphics.setColor(1, 0.3, 0.3, 1)
    love.graphics.rectangle("fill", self.x, self.y, 4, 4)
    for _, bullet in ipairs(self.bullets) do
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle("fill", bullet.x, bullet.y, 2, 2)
    end
end

function Player:checkbulletCollision(enemy)
    for i = #self.bullets, 1, -1 do
        local bullet = self.bullets[i]
        local bulletSize = 12 -- collision box
        if bullet.x < enemy.x + enemy.width and bullet.x + bulletSize > enemy.x and 
        bullet.y < enemy.y + enemy.height and bullet.y + bulletSize > enemy.y then
            table.remove(self.bullets, i)
            return true
        end
    end
    return false
end

function Player:checkenemyCollision(enemy)
    local enemySize = 5
    if self.x < enemy.x + enemy.width and self.x + enemySize> enemy.x and self.y < enemy.y + enemy.height and self.y + enemySize > enemy.y then
        return true
    end
    return false
end