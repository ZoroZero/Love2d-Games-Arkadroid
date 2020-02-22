PlayState = Class {__includes = BaseState}

-- INIT PLAY STATE
function PlayState:init()
    self.paddle = Paddle();
    self.pause = false;
end

-- PLAY STATE UPDATE FUNCTION
function PlayState:update(dt)
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
    
    self.paddle:update(dt);
end

-- RENDER PLAY STATE FUNCTION
function PlayState:render()
    -- render paddle
    self.paddle:render() 
    
    -- render paused text
    if self.pause then 
        love.graphics.setFont(mediumFont)
        love.graphics.printf("PAUSED", 0, 0, VIRTUAL_WIDTH, 'center')
    end
end