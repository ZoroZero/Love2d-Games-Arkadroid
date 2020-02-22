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
function Brick:hit()
    game_Sounds['brick-hit-2']:play();
    self.inPlay = false;
end


-- render function
function Brick:render()
    if self.inPlay then
        love.graphics.draw(game_Textures['main'], game_Frames['bricks'][self.color + (self.tier - 1) * 4], self.x, self.y);
    end
end