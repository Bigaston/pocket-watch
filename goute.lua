function goute.load()
    current_game = goute
    math.randomseed(os.time())
    love.window.setTitle("Pocket Watch ▶ Water")
    
    goute.sprite = {}
    goute.sprite.back = love.graphics.newImage("/assets/goute/Console.png")
    goute.sprite.goute = love.graphics.newImage("/assets/goute/Goute.png")
    goute.sprite.chaudron = love.graphics.newImage("/assets/goute/Chaudron.png")
    goute.sprite.number = {love.graphics.newImage("/assets/goute/Chiffres1.png"),love.graphics.newImage("/assets/goute/Chiffres2.png"),love.graphics.newImage("/assets/goute/Chiffres3.png"),love.graphics.newImage("/assets/goute/Chiffres4.png"),love.graphics.newImage("/assets/goute/Chiffres5.png"),love.graphics.newImage("/assets/goute/Chiffres6.png"),love.graphics.newImage("/assets/goute/Chiffres7.png"),love.graphics.newImage("/assets/goute/Chiffres8.png"),love.graphics.newImage("/assets/goute/Chiffres9.png"),love.graphics.newImage("/assets/goute/Chiffres10.png")}
    goute.sprite.coeur = love.graphics.newImage("/assets/goute/Coeur.png")
    goute.sprite.pause = love.graphics.newImage("/assets/goute/Pause.png")
    goute.sprite.loose = love.graphics.newImage("/assets/goute/Loose.png")
    
    goute.sfx = {}
    goute.sfx.moove = love.audio.newSource("/assets/goute/moove.wav", "static")
    goute.sfx.death = love.audio.newSource("/assets/goute/death.wav", "static")
    goute.sfx.loose = love.audio.newSource("/assets/goute/loose.wav", "static")
    goute.sfx.point = love.audio.newSource("/assets/goute/point.wav", "static")
    goute.sfx.pause = love.audio.newSource("/assets/goute/pause.wav", "static")
    
    goute.score = 0
    goute.vie = 3
    goute.tic = 0
    goute.max_tic = 60
    goute.wait = 2
    
    goute.chaudron_place = 2
    goute.goute_place = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}
    goute.goute_colone = {0,0,0,0,0}
    
    goute.on_pause = false
    goute.loose = false
    
    goute.gen_goute()
end

function goute.update()
    if (goute.score == 99) then
        goute.score = 0
        if (goute.vie < 3) then
            goute.vie = goute.vie + 1 
        end
    end
    
    if (goute.on_pause == false) then
        
        goute.tic = goute.tic + 1
    
        if (goute.tic >= goute.max_tic) then
            goute.moove_goute()
            goute.tic = 0
        end
    
        if (goute.vie == 0) then
            goute.loose = true
            goute.on_pause = true
            love.audio.play(goute.sfx.death)
            love.system.vibrate(0.5)
        end
    end
end

function goute.draw()
    love.graphics.draw(goute.sprite.back, 0, 0, 0, agr)
    
    if (goute.on_pause == false) then
        love.graphics.draw(goute.sprite.chaudron, (288 + goute.chaudron_place * 96) * agr, 504 * agr, 0, agr)
    
        for i = 1, 5 do
            local table = goute.goute_place[i]
        
            for l = 1, 5 do
                if (table[l] == 1) then
                love.graphics.draw(goute.sprite.goute, (208 + i * 96) * agr, (40 + l * 80) * agr, 0, agr)
                end
            end
        end
    else
        love.graphics.draw(goute.sprite.pause, 416 * agr, 272 * agr, 0, agr)
        if (goute.loose == true) then
            love.graphics.draw(goute.sprite.loose, 416 * agr, 272 * agr, 0, agr)
        end
    end
        
    for i = 1, goute.vie do
        love.graphics.draw(goute.sprite.coeur, (552 + 56 * i) * agr, 64 * agr, 0, agr)
    end
    
    goute.draw_score()
end

function goute.gen_goute()
    while true do
        local random = math.random(5)
        if (goute.goute_colone[random] == 0) then
            local table = goute.goute_place[random]
            table[1] = 1
            break
        end
    end
end

function goute.moove_goute()
    for i = 1, 5 do
        local table = goute.goute_place[i]
        if (table[5] == 1) then
            goute.goute_colone[i] = 0
            if (goute.chaudron_place + 1 == i) then
                goute.score = goute.score + 1
                if not (goute.max_tic <= 20) then
                    goute.max_tic = goute.max_tic - 0.6
                end
                love.audio.play(goute.sfx.point)
                table[5] = 0
            else
                love.audio.play(goute.sfx.loose)
                goute.vie = goute.vie - 1
                table[5] = 0
            end
        end
        
        for l = -4, -1 do
            if (table[-l] == 1) then
                table[-l+1] = 1
                table[-l] = 0
            end
        end
        
        goute.goute_place[i] = table
    end
    
    goute.wait = goute.wait - 1
    if (goute.wait == 0) then
        goute.gen_goute()
        goute.wait = 2
    end
end

function goute.draw_score()
    local s = ""..goute.score
    if (string.len(s) == 1) then
        if (tonumber(s) > 0) then
            love.graphics.draw(goute.sprite.number[tonumber(s)], 296 * agr, 64 * agr, 0, agr)
        elseif (tonumber(0) == 0) then
            love.graphics.draw(goute.sprite.number[10], 296 * agr, 64 * agr, 0, agr)
        end
    elseif (string.len(s) == 2) then
        if (tonumber(string.sub(s,2)) > 0) then
            love.graphics.draw(goute.sprite.number[tonumber(string.sub(s,2))], 296 * agr, 64 * agr, 0, agr)
        elseif (tonumber(string.sub(s,2)) == 0) then
            love.graphics.draw(goute.sprite.number[10], 296 * agr, 64 * agr, 0, agr)
        end
        
        if (tonumber(string.sub(s,1,1)) > 0) then
            love.graphics.draw(goute.sprite.number[tonumber(string.sub(s,1,1))], 264 * agr, 64 * agr, 0, agr)
        elseif (tonumber(string.sub(s,1,1)) == 0) then
            love.graphics.draw(goute.sprite.number[10], 264 * agr, 64 * agr, 0, agr)
        end
    end
end

function goute.right()
    if (goute.on_pause == false) then
        goute.chaudron_place = goute.chaudron_place + 1
        love.audio.play(goute.sfx.moove)
        if (goute.chaudron_place > 4) then
            goute.chaudron_place = 4
        end
    end
end

function goute.left()
    if (goute.on_pause == false) then
        goute.chaudron_place = goute.chaudron_place - 1
        love.audio.play(goute.sfx.moove)
        if (goute.chaudron_place < 0) then
            goute.chaudron_place = 0    
        end
    end
end

function goute.pause()
    love.audio.play(goute.sfx.pause)
    if (goute.loose == true) then
        goute.load()
    else
        if (goute.on_pause == false) then
            goute.on_pause = true 
        elseif (goute.on_pause == true) then
            goute.on_pause = false 
            goute.tic = 0
        end
    end
end

function goute.down() end
function goute.up() end
function goute.left_button() end
function goute.right_button() end