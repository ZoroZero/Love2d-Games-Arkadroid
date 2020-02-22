Class = require 'lib/class'

push = require 'lib/push'

require 'src/constant'
require 'src/StateMachine'
require 'src/states/StartState'

function love.load()

    -- SETUP TEXTURE RENDER
    love.graphics.setDefaultFilter('nearest', 'nearest');
    
    -- NAME WINDOW
    love.window.setTitle('Arkadroid');

    -- SETUP SCREEN
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        fullscreen = false,
        vsyn = true
    })

    -- IMAGE SPRITE 
    game_Textures = {
        ['background'] = love.graphics.newImage('assets/images/background.png'),
        ['arrow'] = love.graphics.newImage('assets/images/arrows.png'),
        ['heart'] = love.graphics.newImage('assets/images/hearts.png'),
        ['particle'] = love.graphics.newImage('assets/images/particle.png'),
        ['main'] = love.graphics.newImage('assets/images/breakout.png')
    }

    -- FONT SETUP
    game_Fonts ={
        ['smallFont'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
        ['mediumFont'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
        ['largeFont'] = love.graphics.newFont('assets/fonts/font.ttf', 28),
        ['hugeFont'] = love.graphics.newFont('assets/fonts/font.ttf', 50),
    }

    -- SOUNDS SETUP
    game_Sounds = {
        ['brick-hit-1'] = love.audio.newSource("assets/sounds/brick-hit-1.wav", 'static'),
        ['brick-hit-2'] = love.audio.newSource('assets/sounds/brick-hit-2.wav', 'static'),
        ['confirm'] = love.audio.newSource('assets/sounds/confirm.wav', 'static'),
        ['high_score'] = love.audio.newSource('assets/sounds/high_score.wav', 'static'),
        ['music'] = love.audio.newSource('assets/sounds/music.wav', 'static'),
        ['hurt'] = love.audio.newSource('assets/sounds/hurt.wav', 'static'),
        ['no-select'] = love.audio.newSource('assets/sounds/no-select.wav', 'static'),
        ['paddle_hit'] = love.audio.newSource('assets/sounds/paddle_hit.wav', 'static'),
        ['pause'] = love.audio.newSource('assets/sounds/pause.wav', 'static'),
        ['recover'] = love.audio.newSource('assets/sounds/recover.wav', 'static'),
        ['score'] = love.audio.newSource('assets/sounds/score.wav', 'static'),
        ['select'] = love.audio.newSource('assets/sounds/select.wav', 'static'),
        ['victory'] = love.audio.newSource('assets/sounds/victory.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('assets/sounds/wall_hit.wav', 'static')
    }

    -- SETUP STATEMACHINE
    game_State_Machine = StateMachine{
        ['start'] = function() return StartState() end
    }

    love.keyboard.keysPressed = {}
end

-- UPDATE FUNCTION
function love.update(dt)
    game_State_Machine:update(dt)
end

-- RENDER FUNCTION
function love.draw()
    push:start()

    local BACKGROUND_WIDTH = game_Textures['background']:getWidth()
    local BACKGROUND_HEIGHT = game_Textures['background']:getHeight()

    love.graphics.draw(game_Textures['background'], 
                        0, 0,
                        0, 
                        VIRTUAL_WIDTH /(BACKGROUND_WIDTH -1 ), VIRTUAL_HEIGHT/ (BACKGROUND_HEIGHT -1 ));

    game_State_Machine:render()

    displayFPS()

    push:finish()
end
-- RESIZE FUNCTION WHEN WINDOW CHANGE SIZE
function love.resize(w, h)
    push:resize(w, h)
end
    
-- CHECK ANY KEYS WAS PRESSED FUNCITON AND SET ITS VALUE IN KEYSPRESSED = TRUE
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true;
    if key == 'escape' then
        love.event.quit();
    end
end

-- CHECK IF A SPECIFIC KEY WAS PRESSED
function love.mouse.wasPressed(key)
    return love.mouse.mousePressed[key];
end

-- DISPLAY FPS FUNCTION
function displayFPS()
    love.graphics.setFont(game_Fonts['smallFont'])
    love.graphics.setColor(0 , 255, 0, 255)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end