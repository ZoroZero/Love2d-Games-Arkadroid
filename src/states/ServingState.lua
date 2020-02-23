ServingState = Class {__includes = BaseState}

-- ENTER SERVING STATE FUNCTION
function ServingState:enter(params)
    self.paddle = params.paddle;
    self.bricks = params.bricks;
    self.health = params.health;
    self.score = params.score;

    -- init ball
    self.ball = Ball(math.random(7));
end

-- UPDATE FUNCTION FOR SERVING STATE
function ServingState:update(dt)
    self.ball.x = self.paddle.x + self.paddle.width/2 - 4;
    self.ball.y = self.paddle.y - 10;

    -- Check if enter was pressed and enter play state
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        game_State_Machine:change('play', { paddle = self.paddle,
                            bricks = self.bricks,
                            ball = self.ball,
                            health = self.health,
                            score = self.score
        });
    end

    -- Check if escape
    if love.keyboard.wasPressed('escape') then
        love.event.quit();
    end

end



-- RENDER FUNCTION FOR SERVING STATE
function ServingState:render()
       -- render bricks
       for k, brick in pairs(self.bricks) do
        brick:render();
    end

    -- render paddle
    self.paddle:render(); 
    
    -- render ball
    self.ball:render();

    -- render heart
    renderHealth(self.health)

    -- render paused text
    love.graphics.setFont(game_Fonts['mediumFont']);
    love.graphics.printf("Pressed enter to start", 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center');
end