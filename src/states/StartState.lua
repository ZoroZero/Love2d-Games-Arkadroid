StartState = Class {__includes = BaseState}

-- Initialize 
local highlighted = 1;

function StartState:update(dt)
    -- Change menu options 
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1;
        game_Sounds['paddle_hit']:play();
    end

    -- Enter new state when hit enter
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        if highlighted == 1 then 
            game_State_Machine:change('serve', { paddle = Paddle(1), 
                                                bricks = LevelMaker.createMap(), 
                                                health = 2, 
                                                score = 0
                                                });
        end
        game_Sounds['select']:play();
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit();
    end
end


function StartState:render() 
    -- Title
    love.graphics.setFont(game_Fonts['largeFont']);
    love.graphics.printf("ARKADROID", 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')


    -- Start game options
    love.graphics.setFont(game_Fonts['mediumFont']);
    if highlighted == 1 then 
        love.graphics.setColor(255, 255, 0, 255);
    end
    love.graphics.printf("Start", 0, VIRTUAL_HEIGHT/2 + 70, VIRTUAL_WIDTH, 'center');

    love.graphics.setColor(255,255,255,255);
    -- High score option
    love.graphics.setFont(game_Fonts['mediumFont']);
    if highlighted == 2 then 
        love.graphics.setColor(255, 255, 0, 255);
    end
    love.graphics.printf("High Score", 0, VIRTUAL_HEIGHT/2 + 100, VIRTUAL_WIDTH, 'center');

end