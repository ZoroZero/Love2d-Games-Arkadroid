VictoryState = Class {__includes = BaseState}

-- ENTER FUNCTION
function VictoryState:enter(params)
    self.paddle = params.paddle;
    self.health = params.health;
    self.score = params.score;
    self.ball = params.ball;
    self.level = params.level;
    self.high_scores = params.high_scores
end

-- UPDATE FUNCTION
function VictoryState:update( dt )
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        game_State_Machine:change('serve', { 
                            paddle = self.paddle,
                            bricks = LevelMaker.createMap(self.level + 1),
                            health = self.health,
                            score = self.score,
                            level = self.level,
                            high_scores = self.high_scores
        });
    end

    -- Check if escape
    if love.keyboard.wasPressed('escape') then
        love.event.quit();
    end
end

-- RENDER FUNCTION
function VictoryState:render( ... )
    love.graphics.setColor(255 , 255, 255, 255);
    love.graphics.setFont(game_Fonts['largeFont']);
    
    love.graphics.printf("STAGE " .. tostring(self.level) .. " COMPLETE !" , 0, VIRTUAL_HEIGHT /2 - 70, VIRTUAL_WIDTH, 'center');

    love.graphics.setFont(game_Fonts['mediumFont']);
    love.graphics.printf("SCORE: " .. tostring(self.score), 0, VIRTUAL_HEIGHT /2, VIRTUAL_WIDTH, 'center');
    love.graphics.printf("Press enter to enter next level", 0, VIRTUAL_HEIGHT /2 + 40, VIRTUAL_WIDTH, 'center');
end