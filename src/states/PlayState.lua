PlayState = Class {__includes = BaseState}

-- -- INIT PLAY STATE
-- function PlayState:init()
--     -- Init paddle
--     self.paddle = Paddle();

--     self.pause = false;
    
--     -- Init ball
--     self.ball = Ball(1);
    
--     -- Setup ball speed
--     self.ball.dx = math.random(-200,200);
--     self.ball.dy = math.random(-50, 60);

--     -- Set up level
--     self.bricks = LevelMaker.createMap();

--     -- Set up score
--     self.score = 0;

--     -- Set up player health
--     self.health = 3;
-- end


-- ENTER PLAY STATE FUNCTION
function PlayState:enter(params)
    self.paddle = params.paddle;
    self.bricks = params.bricks;
    self.health = params.health;
    self.score = params.score;
    self.ball = params.ball;

    -- Setup ball speed
    self.ball.dx = math.random(-200,200);
    self.ball.dy = math.random(-50, 60);
end


-- PLAY STATE UPDATE FUNCTION
function PlayState:update(dt)
    -- Cjeck if game is paused
    if self.pause then 
        if love.keyboard.wasPressed('space') then
            self.pause = false;
            game_Sounds['pause']:play();
        else
            return;
        end
    elseif love.keyboard.wasPressed('space') then
        self.pause = true;
        game_Sounds['pause']:play();
        return;    
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit();
    end

    -- Update ball
    self.ball:update(dt);

    -- Update paddle
    self.paddle:update(dt);

    -- check if ball collide with paddle
    local ball_center_x = self.ball.x + self.ball.width/2;
    local paddle_center_x = self.paddle.x + self.paddle.width/2;
    local ball_center_y = self.ball.y + self.ball.height/2;
    local paddle_center_y = self.paddle.y + self.paddle.height/2;
    if self.ball:collides(self.paddle) then
        -- Raise ball above the paddle
        self.ball.y = self.paddle.y - 8;
        self.ball.dy = -self.ball.dy;

        -- Check side collision
        if self.ball.x < paddle_center_x/2 and self.ball.dx < 0 then 
            self.ball.dx = -50 - 8*(paddle_center_x - self.ball.x);
        elseif self.ball.x > paddle_center_x/2 and self.ball.dx > 0 then
            self.ball.dx = 50 + 8*(self.ball.x - paddle_center_x);
        end
        game_Sounds['paddle_hit']:play()
    end 


    -- Check brick and ball collision
    -- Ball only collide with 1 brick at a time
    -- Check the distance to see which brick will be break
    local hasCollided = false;
    local index;
    local minDis;
    for k, brick in pairs(self.bricks) do 
        if brick.inPlay and self.ball:collides(brick) then 
            local curDis = (brick.x + brick.width/2 - ball_center_x)*(brick.x + brick.width/2 - ball_center_x)
                            + (brick.y + brick.height/2 - ball_center_y)*(brick.y + brick.height/2 - ball_center_y);
            if hasCollided then
                if minDis > curDis then
                    minDis = curDis;
                    index = k;
                end
            else
                minDis = curDis;
                index = k;
                hasCollided = true;
            end
        end
    end
    
    --If collision happen then execute it 
    if hasCollided then
        self.bricks[index]:hit(self.ball);
        self.score = self.score + 10;
    end

    -- If ball reach bottom
    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1;
        if self.health == 0 then
            game_State_Machine:change('game_over', {score = self.score});
        else
            game_State_Machine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score
            });
        end

        game_Sounds['hurt']:play();
    end
    
end


-- RENDER PLAY STATE FUNCTION
function PlayState:render()
    
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render();
    end

    -- render paddle
    self.paddle:render(); 
    
    -- render ball
    self.ball:render();

    -- render health
    renderHealth(self.health);

    -- render score
    renderScore(self.score);

    -- render paused text
    if self.pause then 
        love.graphics.setFont(game_Fonts['mediumFont']);
        love.graphics.printf("PAUSED", 0, 0, VIRTUAL_WIDTH, 'center');
    end
end