
Paddle = Class {}

function Paddle:init()
    self.x = VIRTUAL_WIDTH /2 -32;
    self.y = VIRTUAL_HEIGHT - 32;

    -- Speed
    self.dx = 0;

    -- Starting dimesions
    self.width = MEDIUM_PADDLE_WIDTH;
    self.height = PADDLE_HEIGHT;

    -- Skin
    self.skin = 1;

    -- Size 1: small, 2:medium, 3: large, 4:mega
    self.size = 2;

end

function Paddle:update(dt)
    if love.keyboard.isDown('left') then 
        self.dx = -PADDLE_SPEED;
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED;
    else 
        self.dx = 0;
    end

    if self.dx< 0 then 
        self.x = math.max(0, self.x + self.dx * dt);
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt);
    end

end

function Paddle:render()
    love.graphics.draw(game_Textures['main'], game_Frames['paddles'][(self.skin - 1) * 4 + self.size],
                        self.x, self.y);
end