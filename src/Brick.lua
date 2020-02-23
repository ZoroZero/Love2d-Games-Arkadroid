Brick = Class {}

-- Brick color according to tier
paletteColors = {
    -- blue
    [1] = {
        r = 99,
        g = 155,
        b = 255
    },
    -- green
    [2] = {
        r = 106,
        g = 190,
        b = 47
    },
    -- red
    [3] = {
        r = 217,
        g = 87,
        b = 99
    },
    -- purple
    [4] = {
        r = 215,
        g = 123,
        b = 186
    },
    -- gold
    [5] = {
        r = 251,
        g = 242,
        b = 54
    }
}


function Brick:init(x, y)
    -- Position top left
    self.x = x;
    self.y = y;
    
    -- Dimesions
    self.width = BRICK_WIDTH;
    self.height = BRICK_HEIGHT;

    -- Check if brick is exist
    self.inPlay = true;

    -- Color
    self.color = 1;

    -- Tier
    self.tier = 1;

    -- Particle system
    self.psystem = love.graphics.newParticleSystem(game_Textures['particle'], 64)

    -- lasts between 0.5-1 seconds seconds
    self.psystem:setParticleLifetime(0.5, 1)

    -- give it an acceleration of anywhere between X1,Y1 and X2,Y2 (0, 0) and (80, 80) here
    -- gives generally downward 
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)

    -- spread of particles; normal looks more natural than uniform
    self.psystem:setEmissionArea('normal', 10, 10)
end


-- Function to call when brick is hit
function Brick:hit(ball)
    assert(ball:collides(self));
    ball_center_x = ball.x + ball.width / 2;
    brick_center_x = self.x + self.width / 2;

     -- Emit particle
     self.psystem:setColors(
        paletteColors[self.tier + 1].r/255,
        paletteColors[self.tier + 1].g/255,
        paletteColors[self.tier + 1].b/255,
        55 * (self.color + 1),
        paletteColors[self.tier + 1].r/255,
        paletteColors[self.tier + 1].g/255,
        paletteColors[self.tier + 1].b/255,
        0
    )
    self.psystem:emit(64);

    -- Update ball velocity
    if ball.dx / (ball_center_x - brick_center_x) > 0 then
        ball.dy = - ball.dy; 
    elseif (ball_center_x > self.x) and (ball_center_x < self.x + self.width) then
        ball.dy = -ball.dy;
    else
        ball.dx = -ball.dx; 
    end

    -- Update brick colors
    if self.tier > 0 then 
        self.tier = self.tier - 1;
    elseif self.color > 1 then
        self.color = self.color - 1;
    else 
        self.inPlay = false;
    end

   


    -- Sound play
    if not self.inPlay then
        game_Sounds['brick-hit-1']:stop();
        game_Sounds['brick-hit-1']:play();
        
    else 
        game_Sounds['brick-hit-2']:stop();
        game_Sounds['brick-hit-2']:play();
       
    end
end


-- Brick update
function Brick:update(dt)
    self.psystem:update(dt)
end

-- render function
function Brick:render()
    if self.inPlay then
        love.graphics.draw(game_Textures['main'], game_Frames['bricks'][self.color + self.tier * 4], self.x, self.y);
    end
end

-- render particle
function Brick:renderPariticle()
    love.graphics.draw(self.psystem, self.x + 16, self.y - 8);
end