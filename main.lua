
push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    

    math.randomseed(os.time())

    smallFont = love. graphics.newFont('font.ttf', 8 )
    scoreFont = love.graphics.newFont('font.ttf', 32)

    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
        
    })

    player1 = Paddle (10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    --[[player1Score = 0
    player2Score = 0

    player1Y = 30
    player2Y = VIRTUAL_HEIGHT -50

    ballX = VIRTUAL_WIDTH / 2 -2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    ballDX = math.random (2) == 1 and 100 or -100
    ballDY = math.random(-50,50)
]]
    gameState = 'start'
end

function love.update(dt)

    --Player 1 Movement
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    --Player 2 Movement
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end
    
    if gameState == 'play' then
        ball:update(dt)
    end
    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            ball:reset()
        end
    end
end




function love.draw()
    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.printf('Start!', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Play!', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    player1:render()
    player2:render()
    
    ball:render()
    
    push:apply('end')
end
