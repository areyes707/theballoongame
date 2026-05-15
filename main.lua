-- Balloon Collector - A Simple Game made using Love2D
-- You move the player with arrow keys and collect balloons.
-- Once you collect 10 balloons, you're given an option to play the Endless Mode.
-- Either way, if you miss 5 balloons and you lose.

-- player settings
player = {x = 300, y = 400, size = 20, speed = 200}

-- game data
balloons = {}
spawnTimer = 0
score = 0
missed = 0
gameState = "title"

-- makes balloons
function spawnBalloon(speedBoost)
    local b = {
        x = math.random(20, 580),
        y = -20,
        size = 15,
        speed = 100 + (speedBoost or 0)
    }
    table.insert(balloons, b)
end

function love.update(dt)
    if gameState ~= "play" and gameState ~= "endless" then return end

    -- speeds up endless mode
    local speedBoost = (gameState == "endless") and 120 or 0
    local moveSpeed = player.speed + speedBoost

    -- moves player
    if love.keyboard.isDown("left") then
        player.x = player.x - moveSpeed * dt
    elseif love.keyboard.isDown("right") then
        player.x = player.x + moveSpeed * dt
    end
    
    -- balloon spawn timer
    spawnTimer = spawnTimer + dt
    if spawnTimer > 1 then
        if gameState == "endless" then
            spawnBalloon(80)
        else
            spawnBalloon(0)
        end
        spawnTimer = 0
    end

    -- speeds balloons
    for i = #balloons, 1, -1 do
        local b = balloons[i]
        b.y = b.y + b.speed * dt

        local dx = b.x - player.x
        local dy = b.y - player.y
        local dist = math.sqrt(dx*dx + dy*dy)

        -- allows player to collect balloons
        if dist < b.size + player.size then 
            score = score + 1
            table.remove(balloons, i)

        -- penalty for missing balloons
        elseif b.y > 500 then
            missed = missed +1
            table.remove(balloons, i)
        end
    end

    -- lose and win check
    if missed >= 5 then
        gameState = "lose"
    end

    if gameState == "play" and score >= 10 then
        gameState = "win"
    end
end

-- sky colors
function love.draw()
    if gameState == "endless" then
        love.graphics.clear(1, 0.5, 0)
    else
        love.graphics.clear(0.5, 0.8, 1)
    end

    -- title screen
    if gameState == "title" then
        love.graphics.setColor(1, 1, 1)

        love.graphics.setFont(love.graphics.newFont(48))
        love.graphics.printf("The Balloon Game", 0, 150, 600, "center")

        love.graphics.setFont(love.graphics.newFont(24))
        love.graphics.printf("Press SPACE to Start", 0, 250, 600, "center")
        return
    end

    -- player
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", player.x, player.y, player.size)

    -- balloons
    for _, b in ipairs(balloons) do
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", b.x, b.y, b.size)

        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(1)
        love.graphics.line(b.x, b.y + b.size, b.x, b.y + b.size + 20)
    end

    -- ui text
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)
    love.graphics.print("Missed: " .. missed, 10, 30)

    --win and lose screen
    if gameState == "win" then
        love.graphics.setFont(love.graphics.newFont(32))
        love.graphics.printf("YOU WIN!", 0, 200, 600, "center")

        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.printf("Press R to restart", 0, 260, 600, "center")
        love.graphics.printf("Press E for Endless Mode", 0, 300, 600, "center")
    end

    if gameState == "lose" then
        love.graphics.setFont(love.graphics.newFont(32))
        love.graphics.printf("You lose!", 0, 200, 600, "center")

        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.printf("Press R to retry", 0, 260, 600, "center")
    end

    -- endless option
    if gameState == "endless" then
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.printf("Endless Mode", 0, 470, 600, "center")
    end
end

-- start game
function love.keypressed(key)
    if gameState == "title" and key == "space" then
        gameState = "play"
    end

    -- restart
    if key == "r" and (gameState == "win" or gameState == "lose")  then
        balloons = {}
        score = 0
        missed = 0
        spawnTimer = 0
        gameState = "play"
    end

    -- endless mode
    if gameState == "win" and key == "e" then
        balloons = {}
        score = 0
        missed = 0
        spawnTimer = 0
        gameState = "endless"
    end
end