Ball = {
  new = function (pos, clr, spd, r, segments)
    radius = r or 15
    segments = segments or 25
    spd = spd or { love.math.random(-250, 250), love.math.random(-250, 250) }
    while math.abs(spd[1]) < 100 do
      spd[1] = love.math.random(-250, 250)
    end
    while math.abs(spd[2]) < 100 do
      spd[2] = love.math.random(-250, 250)
    end
    return setmetatable({
      spd = spd,
      pos = pos or { love.window.getWidth()/2, love.window.getHeight()/2 },
      clr = clr or { 255, 255, 255 },
      radius = radius,
      segments = segments
    }, Ball)
  end
}
Ball.__index = Ball
setmetatable(Ball, {
  __call = function(_, ...)
    return Ball.new(...)
  end
})

function Ball:draw()
  love.graphics.setColor(self.clr[1], self.clr[2], self.clr[3])
  love.graphics.circle( "fill", self.pos[1], self.pos[2], self.radius, self.segments )
end

function Ball:update(dt)
  self.pos[1] = self.pos[1] + self.spd[1] * dt
  self.pos[2] = self.pos[2] + self.spd[2] * dt

  -- keep it on the screen
  if self.pos[1] > love.window.getWidth() - self.radius or self.pos[1] < self.radius then
    self.spd[1] = -self.spd[1]
  end
  if self.pos[2] > love.window.getHeight() - self.radius then
    self.pos[2] = love.window.getHeight() - self.radius - 1
    self.spd[2] = math.min(-self.spd[2], 250)
  elseif self.pos[2] < self.radius then
    self.pos[2] = self.radius + 1
    self.spd[2] = math.max(-self.spd[2], -250)
  end
end

function Ball:angle()
  -- top center
  local a = { x = self.pos[1], y = self.pos[2] - self.radius }
  -- center
  local b = { x = self.pos[1], y = self.pos[2] }
  -- heading point
  local c = { x = self.pos[1] + self.spd[1], y = self.pos[2] + self.spd[2] }

  -- vertical vector
  local ab = {
    x = 0,
    y = -self.radius
  }
  -- vector from the center of the ball to its heading
  local bc = {
    x = self.spd[1],
    y = self.spd[2]
  }

  -- dot product of AB * BC
  local dot = ab.x * bc.x + ab.y * bc.y
  local abLen = math.sqrt(ab.x * ab.x + ab.y * ab.y)
  local bcLen = math.sqrt(bc.x * bc.x + bc.y * bc.y)
  local angle = math.acos(dot/(abLen * bcLen))
  return angle
end

function Ball:collide(p)
  local intersects, dist, cornerDist = self:intersects(p)
  if intersects then
    if cornerDist then
      print("corner")
      --[[
      self.spd[2] = -self.spd[2]
      return
      ]]
    end

    local vertCollision = dist.y >= p.h/2 - self.radius
    if vertCollision then
      print("top/bottom reversing y")
      -- On the top/bottom, reverse the y velocity and push the ball to the edge
      self.spd[2] = -self.spd[2]
      if self.pos[2] > p.pos[2] + p.h/2 then
        print("pushing down")
        self.pos[2] = p.pos[2] + p.h + self.radius
      else
        print("pushing up")
        self.pos[2] = p.pos[2] - self.radius
      end
    end
    self.spd[2] = self.spd[2] + p.velocity

    -- Determine if we need to push the ball left/right
    if dist.x < self.radius and not vertCollision then
      if self.pos[1] < p.pos[1] + p.w/2 then
        -- ball on left side of paddle, push left
        self.pos[1] = p.pos[1] - self.radius
      else
        -- ball on right side of paddle, push right
        self.pos[1] = p.pos[1] + self.radius
      end
    end

    -- Determine if we need to reverse the x direction
    if not vertCollision then
      if (self.pos[1] < p.pos[1] + p.w/2 and self.spd[1] >= 0) or
        (self.pos[1] > p.pos[1] + p.w/2 and self.spd[1] < 0) then
        self.spd[1] = -self.spd[1]
      end
    end
  end
end

function Ball:intersects(p)
  local dist = {
    x = math.abs(self.pos[1] - (p.pos[1] + p.w/2)),
    y = math.abs(self.pos[2] - (p.pos[2] + p.h/2))
  }

  if dist.x > (p.w/2 + self.radius) or dist.y > (p.h/2 + self.radius) then
    return false
  end

  if dist.x <= p.w/2 or dist.y <= p.h/2 then
    return true, dist
  end

  cornerDist = (dist.x - p.w/2)^2 + (dist.y - p.h/2)^2

  if cornerDist <= self.radius^2 then
    return true, dist, cornerDist
  end

  return false
end
