Brick = Class {}

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
end


-- Function to call when brick is hit
function Brick:hit(ball)
    assert(ball:collides(self));
    ball_center_x = ball.x + ball.width / 2;
    brick_center_x = self.x + self.width / 2;
    if ball.dx / (ball_center_x - brick_center_x) > 0 then
        ball.dy = - ball.dy; 
    elseif (ball_center_x > self.x) and (ball_center_x < self.x + self.width) then
        ball.dy = -ball.dy;
    else
        ball.dx = -ball.dx; 
    end
    game_Sounds['brick-hit-2']:play();
    self.inPlay = false;
end


-- render function
function Brick:render()
    if self.inPlay then
        love.graphics.draw(game_Textures['main'], game_Frames['bricks'][self.color + (self.tier - 1) * 4], self.x, self.y);
    end
end