function fire.load()
    current_game = fire
    math.randomseed(os.time())
    love.window.setTitle("Pocket Watch ▶ Fire")
    
    --Import sprites
    fire.sprite = {}
    fire.sprite.back = love.graphics.newImage("/assets/fire/Console.png")
    fire.sprite.number = {love.graphics.newImage("/assets/fire/Chiffres1.png"),love.graphics.newImage("/assets/fire/Chiffres2.png"),love.graphics.newImage("/assets/fire/Chiffres3.png"),love.graphics.newImage("/assets/fire/Chiffres4.png"),love.graphics.newImage("/assets/fire/Chiffres5.png"),love.graphics.newImage("/assets/fire/Chiffres6.png"),love.graphics.newImage("/assets/fire/Chiffres7.png"),love.graphics.newImage("/assets/fire/Chiffres8.png"),love.graphics.newImage("/assets/fire/Chiffres9.png"),love.graphics.newImage("/assets/fire/Chiffres10.png")}
    fire.sprite.coeur = love.graphics.newImage("/assets/fire/Coeur.png")
    fire.sprite.pause = love.graphics.newImage("/assets/fire/Pause.png")
    fire.sprite.loose = love.graphics.newImage("/assets/fire/Loose.png")
    fire.sprite.car = love.graphics.newImage("/assets/fire/Car.png")
    fire.sprite.water_left = love.graphics.newImage("/assets/fire/Water_Left.png")
    fire.sprite.water_right = love.graphics.newImage("/assets/fire/Water_Right.png")
    fire.sprite.fire = love.graphics.newImage("/assets/fire/Flamme.png")
    
    --Import SFX
    fire.sfx = {}
    fire.sfx.moove = love.audio.newSource("/assets/fire/moove.wav", "static")
    fire.sfx.death = love.audio.newSource("/assets/fire/death.wav", "static")
    fire.sfx.loose = love.audio.newSource("/assets/fire/loose.wav", "static")
    fire.sfx.point = love.audio.newSource("/assets/fire/point.wav", "static")
    fire.sfx.pause = love.audio.newSource("/assets/fire/pause.wav", "static")
    
    fire.score = 0
    fire.vie = 3  
    fire.tic = 60
    fire.max_tic = 140
    
    fire.car_position = 1
    fire.water_shoot = {{false,false,false}, {false,false,false}}
    fire.fire_state = {{0,0,0}, {0,0,0}}
    
    fire.on_pause = false
    fire.loose = false
end

function fire.update()
    if (fire.score == 99) then
        fire.score = 0
        if (fire.vie < 3) then
            fire.vie = fire.vie + 1 
        end
    end
    
    if (fire.on_pause == false) then
        fire.update_fire()
    
        fire.tic = fire.tic + 1
    
        if (fire.tic >= fire.max_tic) then
            fire.gen_fire()
            fire.tic = 0
        end
    
        if (fire.vie == 0) then
            fire.loose = true
            fire.on_pause = true
            love.audio.play(fire.sfx.death)
            love.system.vibrate(0.5)
        end
    end
end

function fire.draw()
    love.graphics.draw(fire.sprite.back, 0, 0, 0, agr)
    
    if (fire.on_pause == false) then
        love.graphics.draw(fire.sprite.car, 456 * agr, (120 + 152 * fire.car_position) * agr, 0, agr)
        
        --Tire eau gauche
        local table_water = fire.water_shoot[1]
        for i = 1, 3 do
            if (table_water[i] == true) then
                love.graphics.draw(fire.sprite.water_left, 416 * agr, (16 + 152 * i) * agr, 0, agr) 
            end
        end
        
        --Tire eau droite
        local table_water = fire.water_shoot[2]
        for i = 1, 3 do
            if (table_water[i] == true) then
                love.graphics.draw(fire.sprite.water_right, 560 * agr, (16 + 152 * i) * agr, 0, agr) 
            end
        end
        
        --Gestion feu gauche
        local table_fire = fire.fire_state[1]
        for i = 1, 3 do
            if (table_fire[i] > 0) then
                 love.graphics.draw(fire.sprite.fire, 304 * agr, (-40 + 152 * i) * agr, 0, agr)
            end
        end
        
        --Gestion feu droite
        local table_fire = fire.fire_state[2]
        for i = 1, 3 do
            if (table_fire[i] > 0) then
                 love.graphics.draw(fire.sprite.fire, 608 * agr, (-40 + 152 * i) * agr, 0, agr)
            end
        end
    else
        love.graphics.draw(fire.sprite.pause, 416 * agr, 272 * agr, 0, agr)
        if (fire.loose == true) then
            love.graphics.draw(fire.sprite.loose, 416 * agr, 272 * agr, 0, agr)
        end
    end
        
    for i = 1, fire.vie do
        love.graphics.draw(fire.sprite.coeur, (552 + 56 * i) * agr, 64 * agr, 0, agr)
    end
    
    fire.draw_score()
end

function fire.draw_score()
    local s = ""..fire.score
    if (string.len(s) == 1) then
        if (tonumber(s) > 0) then
            love.graphics.draw(fire.sprite.number[tonumber(s)], 296 * agr, 64 * agr, 0, agr)
        elseif (tonumber(0) == 0) then
            love.graphics.draw(fire.sprite.number[10], 296 * agr, 64 * agr, 0, agr)
        end
    elseif (string.len(s) == 2) then
        if (tonumber(string.sub(s,2)) > 0) then
            love.graphics.draw(fire.sprite.number[tonumber(string.sub(s,2))], 296 * agr, 64 * agr, 0, agr)
        elseif (tonumber(string.sub(s,2)) == 0) then
            love.graphics.draw(fire.sprite.number[10], 296 * agr, 64 * agr, 0, agr)
        end
        
        if (tonumber(string.sub(s,1,1)) > 0) then
            love.graphics.draw(fire.sprite.number[tonumber(string.sub(s,1,1))], 264 * agr, 64 * agr, 0, agr)
        elseif (tonumber(string.sub(s,1,1)) == 0) then
            love.graphics.draw(fire.sprite.number[10], 264 * agr, 64 * agr, 0, agr)
        end
    end
end

function fire.update_fire()
    for i = 1, 2 do
        local table = fire.fire_state[i]
        local table2 = fire.water_shoot[i]
        
        for l = 1, 3 do
            if (table[l] > 0) then
                table[l] = table[l] + 0.4
                
                if (table2[l] == true) then
                    table[l] = table[l] - 1.4
                    
                    if (table[l] <= 0) then
                        table[l] = 0
                        table2[l] = false
                        fire.score = fire.score + 1
                        love.audio.play(fire.sfx.point)
                    end
                end
                
                if (table[l] >= 120) then
                    table[l] = 0
                    fire.vie = fire.vie - 1
                    love.audio.play(fire.sfx.loose)
                end
            end
        end
        
        fire.fire_state[i] = table
        fire.water_shoot[i] = table2
    end
end

function fire.gen_fire()
    local random1 = math.random(2)
    local table_gen = fire.fire_state[random1]
    local random2 = math.random(3)
    if (table_gen[random2] == 0) then
        table_gen[random2] = 60 
        fire.fire_state[random1] = table_gen
        fire.max_tic = fire.max_tic - 2
        
        if (fire.max_tic <= 130) then fire.max_tic = 130 end
    else
        fire.gen_fire()
    end
end

function fire.up()
    if (fire.car_position > 0) then
        fire.car_position = fire.car_position - 1
        love.audio.play(fire.sfx.moove)
        
        for i = 1,2 do
            local table = fire.water_shoot[i]
            
            for l = 1,3 do
                table[l] = false 
            end
            fire.water_shoot[i] = table
        end
    end
end

function fire.down()
    if (fire.car_position < 2) then
        fire.car_position = fire.car_position + 1
        love.audio.play(fire.sfx.moove)
        
        for i = 1,2 do
            local table = fire.water_shoot[i]
            
            for l = 1,3 do
                table[l] = false 
            end
            fire.water_shoot[i] = table
        end
    end
end

function fire.left_button() 
    local table = fire.water_shoot[1]
    table[fire.car_position + 1] = true
    fire.water_shoot[1] = table
    
    local table = fire.water_shoot[2]        
    for l = 1,3 do
        table[l] = false 
    end
    fire.water_shoot[2] = table
end

function fire.right_button() 
    local table = fire.water_shoot[2]
    table[fire.car_position + 1] = true
    fire.water_shoot[2] = table
    
    local table = fire.water_shoot[1]        
    for l = 1,3 do
        table[l] = false 
    end
    fire.water_shoot[1] = table
end

function fire.pause()
    love.audio.play(fire.sfx.pause)
    if (fire.loose == true) then
        fire.load()
    else
        if (fire.on_pause == false) then
            fire.on_pause = true 
        elseif (fire.on_pause == true) then
            fire.on_pause = false 
        end
    end
end

function fire.left() end
function fire.right() end