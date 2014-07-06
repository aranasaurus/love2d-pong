require('cupid')
require('paddle')

function love.load()
  love.graphics.setBackgroundColor(0, 0, 0)
  p1 = Paddle(1, { up = { "w", "e" }, down = { "s", "d" } })
  p2 = Paddle(2, { up = { "up" }, down = { "down" } })
end

function love.draw()
  p1:draw()
  p2:draw()
end

function love.update(dt)
  p1:update(dt)
  p2:update(dt)

  if love.keyboard.isDown("r") then
    love.load()
  end
end

function love.resize(w, h)
  p1.pos[1] = 15
  p2.pos[1] = w - 15 - p2.w
end
