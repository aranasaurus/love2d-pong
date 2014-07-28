require('cupid')
require('paddle')
require('ball')

function love.load()
  love.graphics.setBackgroundColor(0, 0, 0)
  p1 = Paddle(1, { up = { "w", "e" }, down = { "s", "d" } })
  p2 = Paddle(2, { up = { "up" }, down = { "down" } })
  ball = Ball()
  state = 0
  center = {
    x = love.window.getWidth() / 2,
    y = love.window.getHeight() / 2
  }
  menu = {
    text = "Press [Space] to serve!",
    menuFont = love.graphics.newFont(32),
    scoreFont = love.graphics.newFont(56),
    x = p1.pos[1] + p1.w + 10,
    w = (p2.pos[1] -10) - (p1.pos[1] + p1.w + 10)
  }
  menu.y = p1.pos[2] - menu.menuFont:getHeight()

end

function love.draw()
  p1:draw()
  p2:draw()
  ball:draw()

  if state == 0 then
    love.graphics.setFont(menu.menuFont)
    love.graphics.printf(menu.text, menu.x, menu.y, menu.w, "center")
  end

  love.graphics.setFont(menu.scoreFont)
  love.graphics.printf(p1.score .. "   " .. p2.score, 0, 10, love.window.getWidth(), "center")
end

function love.update(dt)
  handleControls()

  if state == 0 then
    ball.pos[1] = center.x
    ball.pos[2] = center.y
    p1.pos[2] = center.y - p1.h/2
    p2.pos[2] = p1.pos[2]
  else
    p1:update(dt)
    p2:update(dt)
    ball:update(dt)

    ball:collide(p1)
    ball:collide(p2)

    if ball.pos[1] > love.window.getWidth() + ball.radius then
      state = 0
      p1.score = p1.score + 1
      ball = Ball()
    elseif ball.pos[1] < -ball.radius then
      state = 0
      p2.score = p2.score + 1
      ball = Ball()
    end
  end

end

function love.resize(w, h)
  p1.pos[1] = 15
  p2.pos[1] = w - 15 - p2.w

  center = {
    x = love.window.getWidth() / 2,
    y = love.window.getHeight() / 2
  }
end

function handleControls()
  if love.keyboard.isDown("r") then
    love.load()
  end

  if love.keyboard.isDown(" ") then
    state = 1
  end
end
