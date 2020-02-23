
LevelMaker = Class{}

function LevelMaker.createMap()
    local bricks = {};

    -- Init number of rows and cols
    local rows = math.random(4, 5);
    local cols = math.random(7,13);

    -- Genrate brick
    for x = 1, rows  do 
        for y = 1, cols do 
            b = Brick( (y - 1) * BRICK_WIDTH + 8 + (13 - cols) * 16, 
                        x * BRICK_HEIGHT );
            table.insert(bricks , b);
        end
    end

    return bricks;
end