Enemies = Class{}

function Enemies:init()
    self.enemies = {} -- table to hold all of the spawned enemies
    self.spawnInterval = math.random(0.5, 3) -- randomish spawn time between enemies
    self.spawnTimer = 0 -- timer to track when to spawn the next enemy
end

function Enemies:update(dt, player, score)
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer >= self.spawnInterval then
        self:spawnEnemy() --  need to make this class down below
        self.spawnTimer = 0
        self.spawnTimer = math.random(0.5,3)
    end
    -- now update the position of each enemy like the bullets
    for i = #self.enemies, 1, -1 do -- iterate over the enemies in reverse order
        local enemy = self.enemies[i]
        -- calculate direction vector towards the player. do this here since it being updated after every frame
        local directionX = player.x - enemy.x
        local directionY = player.y - enemy.y
        -- can still use the distance formula here
        local length = math.sqrt(directionX^2+directionY^2)
        -- normalize the vectors
        directionX = directionX/length
        directionY = directionY/length
        -- update enemy position
        enemy.x = enemy.x + directionX * enemy.speed * dt
        enemy.y = enemy.y + directionY * enemy.speed * dt
        -- remove the enemy if it leaves the screen
        if enemy.y < 0 or enemy.y > VIRTUAL_HEIGHT or enemy.x < 0 or enemy.x > VIRTUAL_WIDTH then
            table.remove(self.enemies, i)
        end
        -- remove enemy if it collides with a bullet
        if player:checkbulletCollision(enemy) then
            table.remove(self.enemies, i)
            score = score + 1
        end
        if player:checkenemyCollision(enemy) then
            table.remove(self.enemies, i)
        end
    end
    return score
end

function Enemies:spawnEnemy()
    local side = math.random(4)
    local x, y

    if side == 1 then -- let's say this is the top
        x = math.random(0, VIRTUAL_WIDTH) -- will span from 0 to the width of the screen
        y = 0
    elseif side == 2 then -- bottom we can say
        x = math.random(0, VIRTUAL_WIDTH)
        y = VIRTUAL_HEIGHT
    elseif side == 3 then
        x = 0
        y = math.random(0, VIRTUAL_HEIGHT)
    elseif side == 4 then
        x = VIRTUAL_WIDTH
        y = math.random(0, VIRTUAL_HEIGHT)
    end

    -- speed of enemies
    local speed = math.random(50, 150)
    -- now we can create the enemy
    local enemy = {x = x, y = y, speed = speed, width = 3, height = 3}
    -- add enemy to table
    table.insert(self.enemies, enemy)
end

function Enemies:draw()
    love.graphics.setColor(0, 0, 0, 1)
    for _, enemy in ipairs(self.enemies) do
        love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.width, enemy.height)
    end
end