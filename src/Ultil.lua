

-- FUNCTION TO GENERATE QUAD BASED ON ALTAS, TILE WIDTH, TILE HEIGHT
function generateQuad(atlas, tile_width, tile_height)
    local sprites = {};
    local sprite_counter = 1;

    local sheet_width = atlas:getWidth() / tile_width;
    local sheet_height = atlas:getHeight() / tile_height;

    for y = 0, sheet_height - 1 do
        for x = 0, sheet_width -1 do 
            sprites[sprite_counter] = love.graphics.newQuad(x* tile_width, y* tile_height, 
                                                    tile_width, tile_height, 
                                                    atlas:getDimension());
            sprite_counter = sprite_counter + 1
        end
    end

    return sprites
end


-- SLICE FUNCTION LIKE IN PYTHON
function table.slice(tbl, start, stop, step)
    local sliced = {};

    for i = start or 1, stop or #tbl - 1, step or 1 do
        sliced[#sliced+1] = tbl[i]
    end
    
    return sliced
end

-- FUNCTION TO GET PADDLE SPRITES
function generatePaddles(atlas)
    local y = 64;
    local x = 0;
    local counter = 1;

    local quads = {}

    for i = 0, NUM_OF_PADDLE do 
        -- small paddle
        quads[counter] = love.graphics.newQuad(x, y, 
                                        SMALL_PADDLE_WIDTH, PADDLE_HEIGHT, atlas:getDimensions());
        counter = counter + 1;

        -- medium paddle
        quads[counter] = love.graphics.newQuad(x + SMALL_PADDLE_WIDTH, y, 
                                        MEDIUM_PADDLE_WIDTH, PADDLE_HEIGHT, atlas:getDimensions());
        counter = counter + 1;

        -- large paddle
        quads[counter] = love.graphics.newQuad(x + SMALL_PADDLE_WIDTH + MEDIUM_PADDLE_WIDTH, y, 
                                        LARGE_PADDLE_WIDTH, PADDLE_HEIGHT, atlas:getDimensions());
        counter = counter + 1;

        -- mega paddle
        quads[counter] = love.graphics.newQuad(x, y + PADDLE_HEIGHT,
                                        MEGA_PADDLE_WIDTH, PADDLE_HEIGHT, atlas:getDimensions());
        counter = counter + 1;

        y  = y + PADDLE_HEIGHT * 2;
    end
    return quads
end