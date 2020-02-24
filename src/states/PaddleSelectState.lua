PaddleSelectState = Class {__includes = BaseState}


local current_pad = 1;

-- ENTER STATE
function PaddleSelectState:enter(params)
    self.high_scores = params.high_scores;
end


-- UPDATE FUNCTION
function PaddleSelectState:update( dt )
    
    -- Check left right
    if love.keyboard.wasPressed('left') then
        if current_pad == 1 then
            game_Sounds['no-select']:play();
        else
            game_Sounds['select']:play();
            current_pad = current_pad - 1;
        end
    elseif love.keyboard.wasPressed('right') then
        if current_pad == 4 then
            game_Sounds['no-select']:play();
        else
            game_Sounds['select']:play();
            current_pad = current_pad + 1;
        end
    end
    
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        game_Sounds['confirm']:play();
        game_State_Machine:change('serve', {
                                        paddle = Paddle(current_pad), 
                                        bricks = LevelMaker.createMap(1), 
                                        health = 3, 
                                        score = 0,
                                        level = 1,
                                        high_scores = self.high_scores
                                    });
    end
end


-- RENDER FUNCTION
function PaddleSelectState:render()
    -- Instruction
    love.graphics.setColor(255,255,255,255);
    love.graphics.setFont(game_Fonts['mediumFont']);
    love.graphics.printf("Select your paddle", 0 , 5, VIRTUAL_WIDTH, 'center');
    love.graphics.printf("Press enter to confirm", 0 , 40, VIRTUAL_WIDTH, 'center');

    -- Draw arrow:
    -- Left arrow
    if current_pad == 1 then 
        love.graphics.setColor(40, 40, 40, 128);
    end
    love.graphics.draw(game_Textures['arrow'], game_Frames['arrows'][1], VIRTUAL_WIDTH/2 - 100, VIRTUAL_HEIGHT/2 + 40);

    love.graphics.setColor(255,255,255,255);
    -- right arrow
    if current_pad == 4 then 
        love.graphics.setColor(40, 40, 40, 128);
    end
    love.graphics.draw(game_Textures['arrow'], game_Frames['arrows'][2], VIRTUAL_WIDTH/2 + 100, VIRTUAL_HEIGHT/2 + 40);

    -- draw paddle
    love.graphics.setColor(255,255,255,255);

    love.graphics.draw(game_Textures['main'], game_Frames['paddles'][(current_pad-1)* 4 + 2],
            VIRTUAL_WIDTH/2 - MEDIUM_PADDLE_WIDTH/2, VIRTUAL_HEIGHT/2 + 40);
end