function splash_screen.load()
    current_game = splash_screen
    
    splash_screen.tic = 0
    splash_screen.sens = 3
    
    splash_screen.avatar = love.graphics.newImage("/assets/splash-screen/avatar.png")
end

function splash_screen.update()
    splash_screen.tic = splash_screen.tic + splash_screen.sens
    
    if (splash_screen.tic >= 255) then
        splash_screen.tic = 255
        splash_screen.sens = -3
    elseif (splash_screen.tic < 0) then
        love.graphics.setColor(255, 255, 255)
        goute.load()
    end
end

function splash_screen.draw()
    local width, height = love.window.getDesktopDimensions()
    
    love.graphics.setColor(splash_screen.tic, splash_screen.tic, splash_screen.tic)
    love.graphics.draw(splash_screen.avatar, 387 * agr, 162 * agr, 0, agr/2)
end

function splash_screen.left() end
function splash_screen.right() end
function splash_screen.up() end
function splash_screen.down() end
function splash_screen.left_button() end
function splash_screen.right_button() end
function splash_screen.pause() end