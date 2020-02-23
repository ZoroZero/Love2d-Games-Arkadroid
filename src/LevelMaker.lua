
LevelMaker = Class{}

-- global pattern 
NONE = 0;
SINGLE_PYRAMID = 1;
MULTI_PYRADMID = 2;

-- row pattern
SOLID = 1;
ALTERNATIVE = 2;
SKIP = 3;
NO_PATTERN  = 4

function LevelMaker.createMap(level)
    local bricks = {};

    -- Init number of rows and cols
    local rows = math.random(1, math.min(level, 5));

    local cols = math.random(7,13);
    cols = cols == 2 and (cols + 1) or cols;

    -- Set up brick highest tier and color
    local highestTier = math.min(5, math.floor(level/5));
    local highestColor = math.min(4, level % 5 + 3);


    -- Genrate brick
    for y = 1, rows  do 
        -- Enable skipping or not
        local skip_pattern = math.random( 2 ) == 1 and true or false;

        -- Enable alternative or not
        local alternative_pattern = math.random( 2 ) == 1 and true or false;

        -- Choose 2 colors and 2 tier to alter between
        local alternative_color1 = math.random(1, highestColor);
        local alternative_color2 = math.random(1, highestColor);
        local alternative_tier1 = math.random(0, highestTier);
        local alternative_tier2 = math.random(0, highestTier);

        -- Skip flag for skipping a block
        local skip_flag = math.random( 2 ) == 1 and true or false;

        -- Alternative flag for alternate a block
        local alternative_flag = math.random( 2 ) == 1 and true or false;

        -- Solid color  and tier if not alternate
        local solid_color1 = math.random(1, highestColor);
        local solid_tier = math.random(0, highestTier);

        for x = 1, cols do 
            if skip_pattern and skip_flag then
                -- turn off skip flag
                skip_flag = not skip_flag;
                
                goto continue;
            else
                skip_flag = not skip_flag;
            end

            -- generate brick if not skip
            b = Brick( (x - 1) * BRICK_WIDTH + 8 + (13 - cols) * 16, 
                        y * BRICK_HEIGHT );

            
            -- Check alternative and change color 
            if alternative_pattern and alternative_flag then
                b.color = alternative_color1;
                b.tier = alternative_tier1;
                alternative_flag = not alternative_flag;
            else 
                b.color = alternative_color2;
                b.tier = alternative_tier2;
                alternative_flag = not alternative_flag;
            end
            
            table.insert(bricks , b);

            ::continue::
        end
    end

    if #bricks == 0 then 
        return self.createMap(level);
    else
        return bricks;
    end
end