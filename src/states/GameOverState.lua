GameOverState = Class {__includes = BaseState}

-- ENTER FUNCTION
function GameOverState:enter(params)
    self.score = params.score;
end


-- UPDATE FUNCTION
function GameOverState:update( dt )
    -- Return to menu screen
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        game_State_Machine:change('start');
    end

    -- Check if escape
    if love.keyboard.wasPressed('escape') then
        love.event.quit();
    end
end


-- RENDER FUNCTION
function GameOverState:render()
    love.graphics.setColor(255 , 255, 255, 255);
    love.graphics.setFont(game_Fonts['largeFont']);
    
    love.graphics.printf("GAME OVER !", 0, VIRTUAL_HEIGHT /2 - 70, VIRTUAL_WIDTH, 'center');

    love.graphics.setFont(game_Fonts['mediumFont']);
    love.graphics.printf("SCORE: " .. tostring(self.score), 0, VIRTUAL_HEIGHT /2, VIRTUAL_WIDTH, 'center');
    love.graphics.printf("Press enter to play again", 0, VIRTUAL_HEIGHT /2 + 40, VIRTUAL_WIDTH, 'center');
end
