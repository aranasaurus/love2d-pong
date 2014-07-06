require('cupid')
require('paddle')
require('ball')

function love.load()
  love.graphics.setBackgroundColor(0, 0, 0)
  p1 = Paddle(1, { up = { "w", "e" }, down = { "s", "d" } })
  p2 = Paddle(2, { up = { "up" }, down = { "down" } })
  ball = Ball()
end

function love.draw()
  p1:draw()
  p2:draw()
  ball:draw()
end

function love.update(dt)
  handleControls()

  p1:update(dt)
  p2:update(dt)
  ball:update(dt)

  ball:collide(p1)
  ball:collide(p2)
end

function love.resize(w, h)
  p1.pos[1] = 15
  p2.pos[1] = w - 15 - p2.w
end

function handleControls()
  if love.keyboard.isDown("r") then
    love.load()
  end
end
