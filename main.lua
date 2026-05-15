-- Balloon Collector - A Simple Game using Love2D
-- You move the player with arrow keys and collect balloons.
-- Collect 10 balloons to win. Miss 5 balloons and you lose.

player = {x = 300, y = 400, size = 20, speed = 200}

ballons = {}
spawntimer = 0
score = 0
missed = 0
gameState = "play"