push = require 'push'
Class = require 'class'
require 'Player'
require 'Enemies'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

local shoot_interval = 0.15
local time_between_shots = 0

--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- more "retro-looking" font object we can use for any text
    smallFont = love.graphics.newFont('font.ttf', 32)

    -- set LÖVE2D's active font to the smallFont obect
    love.graphics.setFont(smallFont)

    -- initialize window with virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    player = Player(VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2, 4,4)
    enemies = Enemies()
    gameState = 'start'
end

function love.update(dt)
    player:update(dt)

    if love.keyboard.isDown('space') then
        time_between_shots = time_between_shots + dt
        if time_between_shots >= shoot_interval/2 then
            player:shoot()
            time_between_shots = 0
        end
    else
        time_between_shots = 0
    end
    if gameState == 'play' then
        enemies:update(dt)
    end
    player:updatebullets(dt)
end

function love.keypressed(key)
    -- keys can be accessed by string name
    if key == 'escape' then
        -- function LÖVE gives us to terminate application
        love.event.quit()
    end
    if key == 'space' then
        player:shoot()
    end
    if key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(0.93/1, 0.85/1, 0.65/1, 1)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.printf(
        "FUCK YOU",
        0,                   -- starting X
        VIRTUAL_HEIGHT/5 - smallFont:getHeight() / 2, -- starting Y
        VIRTUAL_WIDTH,        -- number of pixels to center within
        'center'    
)
    player:draw()
    enemies:draw()
    push:apply('end')
end