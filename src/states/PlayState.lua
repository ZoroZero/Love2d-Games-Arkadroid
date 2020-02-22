PlayState = Class {__includes = BaseState}

-- INIT PLAY STATE
function PlayState:init()
    -- Init paddle
    self.paddle = Paddle();

    self.pause = false;
    
    -- Init ball
    self.ball = Ball(1);
    
    -- Setup ball speed
    self.ball.dx = math.random(-200,200);
    self.ball.dy = math.random(-50, 60);

    -- Set up level
    self.bricks = LevelMaker.createMap();
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


    local hasCollided = false;
    local index;
    local minDis;
    -- Check brick and ball collision
    for k, brick in pairs(self.bricks) do 
        if brick.inPlay and self.ball:collides(brick) then 
            if ball_center > brick.x and ball_center < brick.x + brick.width then
                self.ball.dy = -self.ball.dy;
            else
                self.ball.dx = -self.ball.dx; 
            end
            brick:hit();
        end
    end

    -- Update ball
    self.ball:update(dt);

    -- Update paddle
    self.paddle:update(dt);
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

    

    -- render paused text
    if self.pause then 
        love.graphics.setFont(game_Fonts['mediumFont']);
        love.graphics.printf("PAUSED", 0, 0, VIRTUAL_WIDTH, 'center');
    end
end