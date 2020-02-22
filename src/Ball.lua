Ball = Class{}

function Ball:init(skin)
    self.width = BALL_WIDTH;
    self.height = BALL_HEIGHT;

    -- Init ball position
    self.x = VIRTUAL_WIDTH/2;
    self.y = VIRTUAL_HEIGHT/2;

    -- Init ball color
    self.skin = skin

    -- Init speed
    self.dx = 0;
    self.dy = 0;
end


-- Reset ball function
function Ball:reset()
    self.x = VIRTUAL_WIDTH/2;
    self.y = VIRTUAL_HEIGHT/2;

    self.dx = 0;
    self.dy = 0;
end


-- Update ball function
function Ball:update( dt )
    -- If ball collide with left or right walls
    if self.x <= 0 then
        self.x = 0;
        self.dx = -self.dx;
        game_Sounds['wall_hit']:play();
    elseif self.x >= VIRTUAL_WIDTH - self.width then
        self.x = VIRTUAL_WIDTH - self.width;
        self.dx = -self.dx;
        game_Sounds['wall_hit']:play();
    end

    -- If ball collide with top or bottom walls
    if self.y <= 0 then
        self.y = 0;
        self.dy = -self.dy;
        game_Sounds['wall_hit']:play();
    elseif self.y >= VIRTUAL_HEIGHT - self.height then
        self.y = VIRTUAL_HEIGHT - self.height;
        self.dy = -self.dy;
        game_Sounds['wall_hit']:play();
    end

    -- Update ball position
    self.x = self.x + self.dx * dt;
    self.y = self.y + self.dy * dt;
end


-- Check if ball collide with anything
function Ball:collides(object)
    return not((self.x > object.x + object.width) or (self.x + self.width < object.x)
        or (self.y > object.y + object.height) or (self.y + self.height < object.y));
end


-- Render function
function Ball:render()
    love.graphics.draw(game_Textures['main'], game_Frames['balls'][self.skin], self.x, self.y);
end