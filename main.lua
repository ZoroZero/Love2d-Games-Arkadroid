require 'src/Dependencies'

function love.load()

    -- SETUP TEXTURE RENDER
    love.graphics.setDefaultFilter('nearest', 'nearest');
    
    -- NAME WINDOW
    love.window.setTitle('Arkadroid');

    -- SETUP RANDOM SEED
    math.randomseed(os.time());

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
        ['largeFont'] = love.graphics.newFont('assets/fonts/font.ttf', 24),
        ['hugeFont'] = love.graphics.newFont('assets/fonts/font.ttf', 30),
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
    --  SETUP FRAMES SPRITES
    game_Frames = {
        ['paddles'] = generatePaddles(game_Textures['main']),
        ['balls'] = generateBalls(game_Textures['main']),
        ['bricks'] = generateBricks(game_Textures['main']),
        ['hearts'] = generateHearts(game_Textures['heart']),
        ['arrows'] = generateQuad(game_Textures['arrow'], ARROW_WIDTH, ARROW_HEIGHT)
    } 

    -- SETUP STATEMACHINE
    game_State_Machine = StateMachine{
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['serve'] = function () return ServingState() end,
        ['game_over'] = function () return GameOverState() end,
        ['victory'] = function () return VictoryState() end,
        ['enter_high'] = function () return EnterHighScoreState() end,
        ['high_score'] = function () return HighScoreState() end,
        ['select_paddle'] = function () return PaddleSelectState() end
    }
    game_State_Machine:change('start', {
                            high_scores = loadHighScores() } );

    -- PLAY BACKGROUND MUSIC
    game_Sounds['music']:play();
    game_Sounds['music']:setLooping(true);

    -- SET UP TABLE TO CHECK KEY PRESSED
    love.keyboard.keysPressed = {};
end

-- UPDATE FUNCTION
function love.update(dt)
    game_State_Machine:update(dt);

    love.keyboard.keysPressed = {};
end

-- RENDER FUNCTION
function love.draw()
    push:start();

    local BACKGROUND_WIDTH = game_Textures['background']:getWidth();
    local BACKGROUND_HEIGHT = game_Textures['background']:getHeight();

    love.graphics.draw(game_Textures['background'], 
                        0, 0,
                        0, 
                        VIRTUAL_WIDTH /(BACKGROUND_WIDTH -1 ), VIRTUAL_HEIGHT/ (BACKGROUND_HEIGHT -1 ));

    game_State_Machine:render();

    displayFPS();

    push:finish();
end
-- RESIZE FUNCTION WHEN WINDOW CHANGE SIZE
function love.resize(w, h)
    push:resize(w, h);
end
    
-- CHECK ANY KEYS WAS PRESSED FUNCITON AND SET ITS VALUE IN KEYSPRESSED = TRUE
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true;
end

-- CHECK IF A SPECIFIC KEY WAS PRESSED
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key];
end


-- DISPLAY FPS FUNCTION
function displayFPS()
    love.graphics.setFont(game_Fonts['smallFont']);
    love.graphics.setColor(0 , 255, 0, 255);
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10);
end


-- RENDER HEALTH FUNCTION 
function renderHealth(health)
    local health_x = VIRTUAL_WIDTH - 100;
    local health_y = 2;
    -- Render current health
    for i = 1, health do 
        love.graphics.draw(game_Textures['heart'], game_Frames['hearts'][1], (i-1) * HEART_WIDTH + health_x , health_y)
    end

    -- Render losing health
    health_x = health_x + health * HEART_WIDTH;
    for i = 1, 3 - health do 
        love.graphics.draw(game_Textures['heart'], game_Frames['hearts'][2], (i-1) * HEART_WIDTH + health_x , health_y)
    end
end

-- RENDER SCORE
function renderScore(score)
    love.graphics.setFont(game_Fonts['smallFont']);
    love.graphics.setColor(0 , 255, 0, 255);
    love.graphics.print("Score: " .. tostring(score), VIRTUAL_WIDTH - 60, 2);
end

-- FUNCTION TO LOAD HIGHSCORE
function loadHighScores()
    love.filesystem.setIdentity('arkadroid');

    -- If file not exist the create and init 10 value
    if not love.filesystem.getInfo('arkadroid.lst') then
        local init_score = ''
        for i = 1,10 do
            init_score = init_score .. 'CTO\n';
            init_score = init_score .. tostring(i*100) ..'\n';
        end
        
        love.filesystem.write('arkadroid.lst', init_score);
    end


    -- Flag for reading name
    local name = true;
    local curName = nil;
    local counter = 1;

    -- Set up store array
    local scores = {}
    for i = 1, 10 do 
        scores[i] = {
            name = nil,
            score = nil
        };
    end

    -- Read file
    for line in love.filesystem.lines('arkadroid.lst') do
        if name then 
            scores[counter].name = string.sub( line, 1, 3);
        else
            scores[counter].score = tonumber(line);
            counter = counter + 1;
        end
        name = not name;
    end
    return scores
end