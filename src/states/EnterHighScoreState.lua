EnterHighScoreState = Class {__includes = BaseState}


local chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65
}

-- CURRENT HIGHLIGHTED CHAR
local highlighted_char = 1;

-- ENTER FUNCTION
function EnterHighScoreState:enter(params)
    self.score = params.score;
    self.high_scores = params.high_scores;
    self.score_index = params.score_index;
end

-- UPDATE FUNCITON
function EnterHighScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- Update high score
        local name = string.char( chars[1] ) .. string.char( chars[1] ) .. string.char( chars[1] );
        for i = 10, self.score_index, -1 do
            self.high_scores[i + 1] = {
                name = self.high_scores[i].name,
                score = self.high_scores[i].score
            }
        end

        self.high_scores[self.score_index].name = name;
        self.high_scores[self.score_index].score = self.score;

        -- Update to file
        local updated_score = ''
        for i = 1,10 do
            updated_score = updated_score ..  self.high_scores[self.score_index].name .. '\n';
            updated_score = updated_score .. tostring( self.high_scores[self.score_index].score) ..'\n';
        end

        love.filesystem.write('arkadroid', updated_score);

        game_State_Machine:change('high_score', {
                                                high_scores = self.high_scores
                                                });
    end

    if love.keyboard.wasPressed('right') then 
        highlighted_char = highlighted_char < 3 and highlighted_char + 1 or 1;
        game_Sounds['select']:play();
    elseif love.keyboard.wasPressed('left') then
        highlighted_char = highlighted_char > 1 and highlighted_char - 1 or 3;
        game_Sounds['select']:play();
    elseif love.keyboard.wasPressed('up') then 
        chars[highlighted_char] = chars[highlighted_char] < 90 and chars[highlighted_char] + 1 or 65;
    elseif love.keyboard.wasPressed('down') then 
        chars[highlighted_char] = chars[highlighted_char] > 65 and chars[highlighted_char] - 1 or 90;
    end
    
end

-- RENDER FUNCTION
function EnterHighScoreState:render()
    -- render score
    love.graphics.setFont(game_Fonts['mediumFont']);
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.printf("Your score: " .. tostring(self.score), 0, 0, VIRTUAL_WIDTH, 'center');

    -- render chars
    love.graphics.setFont(game_Fonts['mediumFont']);
    -- First char
    if highlighted_char == 1 then 
        love.graphics.setColor(255, 255, 0, 255);
    end
    love.graphics.print(string.char(chars[1]), VIRTUAL_WIDTH / 2 - 28, VIRTUAL_HEIGHT/2);

    love.graphics.setColor(255,255,255,255);
    -- Second char
    if highlighted_char == 2 then 
        love.graphics.setColor(255, 255, 0, 255);
    end
    love.graphics.print(string.char( chars[2] ), VIRTUAL_WIDTH / 2 - 6, VIRTUAL_HEIGHT/2);

    love.graphics.setColor(255,255,255,255);
    -- Third char
    if highlighted_char == 3 then 
        love.graphics.setColor(255, 255, 0, 255);
    end
    love.graphics.print(string.char( chars[3] ), VIRTUAL_WIDTH / 2 + 20, VIRTUAL_HEIGHT/2);


    -- Press enter
    love.graphics.setColor(255,255,255,255);
    love.graphics.setFont(game_Fonts['mediumFont']);
    love.graphics.printf("Press enter to enter next level", 0, VIRTUAL_HEIGHT - 40, VIRTUAL_WIDTH, 'center');
end
