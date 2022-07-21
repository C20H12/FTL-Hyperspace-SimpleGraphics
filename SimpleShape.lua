---@class SimpleShape : SimpleSprite
SimpleShape = SimpleSprite:new("null")

SimpleShape.new = function(self, shape)
  local o = {shape = shape}
  self.__index = self
  return setmetatable(o, self)
end

SimpleShape._renderRect = function(modifierTable)
  local width = modifierTable.width or 0
  local height = modifierTable.height or 0
  local positionX = 1280 / 2 - width / 2 + (modifierTable.Xalign or 0)
  local positionY = 720 / 2 - height / 2 - (modifierTable.Yalign or 0)
  local color = modifierTable.color or Graphics.GL_Color(1, 1, 1, 1)
  local borderColor = modifierTable.borderColor or Graphics.GL_Color(1, 1, 1, 1)
  local borderWidth = modifierTable.borderWidth or 0
  
  Graphics.CSurface.GL_DrawRect(
    positionX, 
    positionY, 
    width,
    height,
    color
  )
  Graphics.CSurface.GL_DrawRectOutline(
    positionX, 
    positionY, 
    width,
    height,
    borderColor,
    borderWidth
  )
end

SimpleShape._renderTriangle = function(modifierTable)
  local screenCenter = {1280 / 2, 720 / 2}
  local points = {}

  for i=1, 3 do
    modifierTable["point" .. i] = modifierTable["point" .. i] or screenCenter
    points[i] = Hyperspace.Point(
      screenCenter[1] + modifierTable["point" .. i][1], 
      screenCenter[2] - modifierTable["point" .. i][2]
    )
  end

  local color = modifierTable.color or Graphics.GL_Color(1, 1, 1, 1)
  Graphics.CSurface.GL_DrawTriangle(
    points[1],
    points[2],
    points[3],
    color
  )
end

---@override
SimpleShape.show = function(self, modifierTable)

  if not self._isShowing then
    return
  end

  if self.shape == "rect" then
    self._renderRect(modifierTable)
  elseif self.shape == "triangle" then
    self._renderTriangle(modifierTable)
  else
    error("Unknown shape: " .. self.shape)
  end
  
end 