Paddle = {
  new = function (player, ctrlMap, pos, clr, spd, w, h)
    local x = 15
    if player ~= 1 then
      x = love.window.getWidth() - (w or 25) - 15
    end
    return setmetatable({
      player = player or 1,
      ctrlMap = ctrlMap,
      spd = spd or 250,
      pos = pos or { x, love.window.getHeight()/2 - (h or 150)/2 },
      clr = clr or { 255, 255, 255 },
      w = w or 25,
      h = h or 150
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
  local offsetX = 15
  if self.player ~= 1 then
    offsetX = love.window.getWidth() - self.w
  end
  love.graphics.setColor(self.clr[1], self.clr[2], self.clr[3])
  love.graphics.rectangle( "fill", self.pos[1], self.pos[2], self.w, self.h )
end

function Paddle:update(dt)
  if self.ctrlMap then
    for i,k in ipairs(self.ctrlMap.up) do
      if love.keyboard.isDown(k) then
        self.pos[2] = self.pos[2] - (self.spd * dt)
        break
      end
    end
    for i,k in ipairs(self.ctrlMap.down) do
      if love.keyboard.isDown(k) then
        self.pos[2] = self.pos[2] + (self.spd * dt)
        break
      end
    end
  end

  -- keep it on the screen
  self.pos[2] = math.min(self.pos[2], love.window.getHeight() - self.h)
  self.pos[2] = math.max(self.pos[2], 0)
end
