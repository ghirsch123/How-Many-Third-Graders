push = require 'push'
Class = require 'class'
require 'Player'
require 'Enemies'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

local punch_interval = 0.15
local kick_interval = 0.5
local time_between_shots = 0

--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle("How Many Third Graders?")

    -- more "retro-looking" font object we can use for any text
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 32)

    Score = 0

    -- set LÖVE2D's active font to the smallFont obect
    love.graphics.setFont(largeFont)

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

    if love.keyboard.isDown('z') then
        time_between_shots = time_between_shots + dt
        if time_between_shots >= punch_interval/2 then
            player:punch()
            time_between_shots = 0
        end
    else
        time_between_shots = 0
    end
    if gameState == 'play' then
        Score = enemies:update(dt, player, Score)
    end
    player:updatebullets(dt)
end

function love.keypressed(key)
    -- keys can be accessed by string name
    if key == 'escape' then
        -- function LÖVE gives us to terminate application
        love.event.quit()
    end
    if key == 'z' then
        player:punch()
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
    love.graphics.setColor(0,0,0,1)
    love.graphics.printf(tostring(Score), 5, VIRTUAL_HEIGHT/20 - smallFont:getHeight() / 2,
                        VIRTUAL_WIDTH, 'center')

    player:draw()
    enemies:draw()
    push:apply('end')
end