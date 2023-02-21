Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

--estas variables son para mantener un registro de la velocidad en X y en Y
    self.dy = math.random (2) == 1 and -100 or 100
    self.dx = math.random (2) == 1 and math.random(-80, -100) or math.random(80,100)
end

function Ball:collides(paddle)
    -- Primero revisar si el borde izquierdo  de alguna esta mas a la derecha
    -- que el borde derecho de la otra
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end 

    --despues comprobar si el borde inferior de alguna esta mas alto que la cima de la otra
    if self.y > paddle.y + paddle.height or paddle.y > self.y +self.height then
        return false
    end
-- si las de arriba son falsas, hay superposcision 
    return true
end
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 -2
    self.y = VIRTUAL_HEIGHT / 2 -2
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
