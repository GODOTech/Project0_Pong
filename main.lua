
push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200


-- corre solo una vez, cuando se inicia el programa
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Phong You!')
    
-- sembrar el RNG para que los numeros aleatorios varien cada vez que se inicia
    math.randomseed(os.time())

    smallFont = love. graphics.newFont('font.ttf', 8 )
    scoreFont = love.graphics.newFont('font.ttf', 32)

    love.graphics.setFont(smallFont)
-- inicializar ventana con resolucion virtual
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
        
    })
-- inicializar las variables de puntos para usar luego
    player1Score = 0
    player2Score = 0
    
    servingPlayer = 1

-- inicializar las paletas y hacerlas globales para que puedan detectarlas
-- otras funciones y modulos
    player1 = Paddle (10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    -- poner la pelota en el medio
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

-- la variable gamestate, para pasar entre distintas partes del juego (menues, pausa, etc)
-- utilizamos esto para determinar el comprtamiento durante el render y el update
    gameState = 'start'
end

--corre cada cuadro , con dt pasado, nuestro delta en segundos desde el ultimo cuadro,
-- que LÖVE2D nos provee

function love.update(dt)
    if gameState == 'serve' then
        ball.dy = math.random(-50,50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
   
    elseif gameState == 'play' then

       -- detectar la colicion de pelota-paletas invirtiendo dx si es cierta
       -- aumentarla ligeramente y alterar dy basado en la poscicon de la colicion 
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            -- mantener la velocidad en la misma direccion pero randomizarla
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10,150)
            end
        end

        -- detectar la colicion de pelota-paletas invirtiendo dx si es cierta
        -- aumentarla ligeramente y alterar dy basado en la poscicon de la colicion
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            -- mantener la velocidad en la misma direccion pero randomizarla
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

-- detectar bordes de pantalla e invertir
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = - ball.dy
        end

-- -4 para el tamaño de la pelota 
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy =  - ball.dy
        end
    end

    -- si la pelota se pasa de el borde de pantalla, volver a empezar y actualizar puntos

    if ball.x < 0 then
        servingPlayer = 1
        player2Score = player2Score + 1
        ball:reset()
        gameState = 'serve' 
    end

    if ball.x > VIRTUAL_WIDTH then
        servingPlayer = 2
        player1Score = player1Score + 1
        ball:reset()
        gameState = 'serve'
    end


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
    
-- actualizar pelota basado en su DX y DY solo si esta en estado play
--escalar la velocidad por dt para que el movimiento se independiente del FPS
    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

-- gestion del teclado, llamado por LÖVE2D cada cuadro
-- pasa la tecla que prescionamos para que podamos acceder

function love.keypressed(key)
    --las teclas pueden accederse a travez de un string
    if key == 'escape' then
        -- la funcion que utiliza LÖVE2D para cerrar la aplicacion
        love.event.quit()
    -- si prescionamos enter pasamos a modo play
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        end
    end
end

-- llamado despues del update por LÖVE2D, para dibujar todo en la pantalla
-- actualizado o no
function love.draw()
    -- comenzar a renderizar a la resolucion virtual
    push:apply('start')

    --limpiar la pantalla a un color especifico 
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    
    -- dibujar diferentes cosas basado en el estado de juego
    love.graphics.setFont(smallFont)

    displayScore()

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Bienvenidos al Re-Make!', 0 , 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Presiona ENTER', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Jugador '.. tostring(servingPlayer)..' Saca!',
            0, 10, VIRTUAL_WIDTH, "center")
        --love.graphics.printf('ENTER para sacar!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- sin mensajes durante el juego
    end

        
    -- renderizar paletas ahora utilizando el methodo de la clase
    player1:render()
    player2:render()
    
    -- renderizar la pelota utilizando el methodo render de la clase
    ball:render()

    --displayFPS()
    
    -- terminar renderizacion a la resolucion virtual
    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: '..tostring(love.timer.getFPS()), 10, 10)
end
   
function displayScore()
    -- dibujar puntaje a la izquierda y derecha en el centro
    -- hace falta cambiar la fuente antes de imprimir
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2  -50,
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end