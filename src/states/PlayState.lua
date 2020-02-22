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
    self.ball.dy = math.random(-50, 60)
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

    -- Update ball
    self.ball:update(dt);

    -- Update paddle
    self.paddle:update(dt);
end

-- RENDER PLAY STATE FUNCTION
function PlayState:render()
    -- render paddle
    self.paddle:render(); 
    
    -- render ball
    self.ball:render();
    
    -- render paused text
    if self.pause then 
        love.graphics.setFont(mediumFont);
        love.graphics.printf("PAUSED", 0, 0, VIRTUAL_WIDTH, 'center');
    end
end