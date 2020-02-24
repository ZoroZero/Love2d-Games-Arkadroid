GameOverState = Class {__includes = BaseState}

-- ENTER FUNCTION
function GameOverState:enter(params)
    self.score = params.score;
    self.high_scores = params.high_scores
end


-- UPDATE FUNCTION
function GameOverState:update( dt )
    -- check if score if in high score board
    local new_High_Score = false
    local high_score_index = 11;
    for i = 1, 10 do 
        if self.score > self.high_scores[i].score then 
            new_High_Score = true;
            high_score_index = i;
            break
        end
    end

    if new_High_Score then 
        game_Sounds['high_score']:play()
        game_State_Machine:change('enter_high', {
                                            score = self.score,
                                            high_scores = self.high_scores,
                                            score_index = high_score_index
        })
    end
    -- Return to menu screen
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        game_State_Machine:change('start', { high_scores = self.high_scores });
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
