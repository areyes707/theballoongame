-- Balloon Collector - A Simple Game using Love2D
-- You move the player with arrow keys and collect balloons.
-- Collect 10 balloons to win. Miss 5 balloons and you lose.

player = {x = 300, y = 400, size = 20, speed = 200}

ballons = {}
spawntimer = 0
score = 0
missed = 0
gameState = "play"

function spawnBalloon()
    local b = {
        x = math.random(20, 580),
        y = -20,
        size = 15,
        speed = 100
    }
    table.insert(ballons, b)
end

function love.update(dt)
    if gameState ~= "play" then return end

    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed * dt

    elseif love.keyboard.isDown("right") then
        player.x = player.x + player.speed * dt
    end
    
    spawnTimer = spawnTimer + dt
    if spawnTimer > 1 then
        spawnBalloon()
        spawnTimer = 0
    end

    for i = #balloons, 1, -1 do
        local b = balloons[i]
        b.y = b.y +b.speed * dt

        local dx=b.x - player.x
        local dy=b.y - player.y
        local dist = math.sqrt(dx*dx + dy*dy)

        if dist < b.size + player.size then 
        score = score +1
        table.remove(balloons, i)
        elseif b.y > 500 then
        missed = missed +1
        table.remove(balloons, i)
        end
    end

    if score >= 10 then
        gameState = "win"
    elseif missed >= 5 then
        gameState = "lose"
    end
end

function love.draw()
    love.graphics.setColor(0, 0.5, 1)
    love.graphics.circle("fill", player.x, player.y, player.size)

    love.graphics.setColor(1, 0, 0)
    for _, b in ipairs(balloons) do
        love.graphics.circle("fill", b.x, b.y, b.size)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("score: "..score, 10, 10)
    love.graphics.print("missed: ".. missed, 10, 30)

    if gameState == "win" then
        love.graphics.print("YOU WIN! Press R to restart", 200, 250)
    elseif gameState == "lose" then
        love.graphics.print("You lose! Press R to try again", 200, 250)
    end
end

function love.keypressed(key)
    if key == "r" and gameState ~= "play" then
        balloons = {}
        score = 0
        missed = 0
        gameState = "play"
    end
end