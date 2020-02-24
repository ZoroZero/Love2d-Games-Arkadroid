HighScoreState = Class{__includes = BaseState}

-- Enter function
function HighScoreState:enter(params)
    self.high_scores = params.high_scores;
end

-- Update
function HighScoreState:update(dt)
    if love.keyboard.wasPressed('escape') then 
        game_Sounds['select']:play()
        game_State_Machine:change('start', {
                            high_scores = self.high_scores} );
    end
end

-- render
function HighScoreState:render()
    love.graphics.setFont(game_Fonts['largeFont']);
    love.graphics.printf('High Scores', 0, 10, VIRTUAL_WIDTH, 'center')

    local y = 40
    -- Print high scores
    for i = 1, 10 do
        name = self.high_scores[i].name or '---';
        score = self.high_scores[i].score or '---';
        
        -- score number (1-10)
        love.graphics.printf(tostring(i) .. '.', VIRTUAL_WIDTH / 4, 
            y, 50, 'left');

        -- score name
        love.graphics.printf(name, VIRTUAL_WIDTH / 4 + 38, 
            y, 50, 'right');
        
        -- score itself
        love.graphics.printf(tostring(score), VIRTUAL_WIDTH / 2,
            y, 100, 'right');
        
        y = y + 17;
    end

    love.graphics.setFont(game_Fonts['smallFont']);
    love.graphics.printf('Press escape to return to menu', 0, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, 'center');

end