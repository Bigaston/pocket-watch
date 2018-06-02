function love.load()
    game_init()
    splash_screen.load()
    love.window.setMode(1024, 624)
    
    change_sfx = love.audio.newSource("/assets/change.wav", "static")
    
    agr = 1
    
    if (love.system.getOS() == "Android") then
        local width, height = love.window.getDesktopDimensions()
        width = width / 1024
        height = height / 624
        if (width < height) then agr = width else agr = height end
    end
    
    current_game.load()
end

function love.update()
    current_game.update()
end

function love.draw()
    current_game.draw()
end

function game_init()
    goute = {}
    fire = {}
    splash_screen = {}
    require("goute")
    require("fire")
    require("splash-screen")
end

function love.keypressed(key, scancode, isrepeat)
    if (key == "up") then
        current_game.up()
    elseif (key == "left") then
        current_game.left()
    elseif (key == "down") then
        current_game.down()
    elseif (key == "right") then
        current_game.right()
    elseif (scancode == "q") then
        current_game.left_button()
    elseif (scancode == "e") then
        current_game.right_button()
    elseif (key == "escape") then
        current_game.pause()
    elseif (key == "return") then
        love.audio.play(change_sfx)
        if (current_game == goute) then
            fire.load()
        elseif (current_game == fire) then
            goute.load() 
        end
    end
end

function love.touchpressed( id, x, y)
    if (y >= 144 * agr and y <= 224 * agr) then
        if (x >= 32 * agr and x <= 88 * agr) then
            current_game.left()
        end
        
        if (x >= 160 * agr and x <= 216 * agr) then
            current_game.right()
        end
    end
    
    if (x >= 88 * agr and x <= 160 * agr) then
        if (y >= 88 * agr and y <= 144 * agr) then
            current_game.up() 
        end
        
        if (y >= 224 * agr and y <= 280 * agr) then
            current_game.down() 
        end
    end
    
    if (y >= 136 * agr and y <= 248 * agr) then
        if (x >= 784 * agr and x <= 888 * agr) then
            current_game.left_button() 
        end
        
        if (x >= 904 * agr and x <= 1008 * agr) then
            current_game.right_button() 
        end
    end
    
    if (x >= 824 * agr and x <= 976 * agr) then
        if (y >= 368 * agr and y <= 408 * agr) then
            current_game.pause() 
        end
        
        if (y >= 472 * agr and y <= 512 * agr) then
            love.audio.play(change_sfx)
            if (current_game == goute) then
                fire.load()
            elseif (current_game == fire) then
                goute.load() 
            end
        end
    end
end