Paddle = {
  new = function (player, ctrlMap, pos, clr, spd, w, h)
    w = w or 25
    h = h or 150
    local x = w + 10
    if player ~= 1 then
      x = love.window.getWidth() - x - w
    end
    return setmetatable({
      player = player or 1,
      ctrlMap = ctrlMap,
      spd = spd or 300,
      velocity = 0,
      pos = pos or { x, love.window.getHeight()/2 - h/2 },
      clr = clr or { 255, 255, 255 },
      w = w,
      h = h,
      score = 0
    }, Paddle)
  end
}
Paddle.__index = Paddle
setmetatable(Paddle, {
  __call = function(_, ...)
    return Paddle.new(...)
  end
})

function Paddle:draw()
  local offsetX = self.w
  if self.player ~= 1 then
    offsetX = love.window.getWidth() - self.w
  end
  love.graphics.setColor(self.clr[1], self.clr[2], self.clr[3])
  love.graphics.rectangle( "fill", self.pos[1], self.pos[2], self.w, self.h )
end

function Paddle:update(dt)
  self.velocity = 0
  for i,k in ipairs(self.ctrlMap.up) do
    if love.keyboard.isDown(k) then
      self.velocity = -self.spd
    end
  end
  for i,k in ipairs(self.ctrlMap.down) do
    if love.keyboard.isDown(k) then
      self.velocity = self.spd
    end
  end
  self.pos[2] = self.pos[2] + self.velocity * dt

  -- keep it on the screen
  self.pos[2] = math.min(self.pos[2], love.window.getHeight() - self.h)
  self.pos[2] = math.max(self.pos[2], 0)
end

