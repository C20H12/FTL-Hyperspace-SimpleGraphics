---@class SimpleShape : SimpleSprite
mods.libs.SG.SimpleShape = mods.libs.SG.SimpleSprite:new("null")

mods.libs.SG.SimpleShape.new = function(self, shape, sides)
  local o = {shape = shape, sides = sides}
  self.__index = self
  return setmetatable(o, self)
end

mods.libs.SG.SimpleShape._renderRect = function(modifierTable)
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

mods.libs.SG.SimpleShape._renderLine = function(modifierTable)
  local screenCenter = {1280 / 2, 720 / 2}
  local width = modifierTable.width or 1
  local color = modifierTable.color or Graphics.GL_Color(1, 1, 1, 1)
  
  local points = {}
  for i=1, 2 do
    modifierTable["point" .. i] = modifierTable["point" .. i] or screenCenter
    points[i] = {
      screenCenter[1] + modifierTable["point" .. i][1], 
      screenCenter[2] - modifierTable["point" .. i][2]
    }
  end

  Graphics.CSurface.GL_DrawLine(
    points[1][1],
    points[1][2], 
    points[2][1], 
    points[2][2], 
    width, 
    color
  )
end

mods.libs.SG.SimpleShape._renderTriangle = function(self, modifierTable)
  local screenCenter = {1280 / 2, 720 / 2}
  local points = {}

  for i=1, 3 do
    modifierTable["point" .. i] = modifierTable["point" .. i] or screenCenter
    points[i] = {
      screenCenter[1] + modifierTable["point" .. i][1], 
      screenCenter[2] - modifierTable["point" .. i][2]
    }
  end

  local color = modifierTable.color or Graphics.GL_Color(1, 1, 1, 1)
  local borderColor = modifierTable.borderColor or Graphics.GL_Color(1, 1, 1, 1)
  local borderWidth = modifierTable.borderWidth or 0

  Graphics.CSurface.GL_DrawTriangle(
    Hyperspace.Point(table.unpack(points[1])),
    Hyperspace.Point(table.unpack(points[2])),
    Hyperspace.Point(table.unpack(points[3])),
    color
  )
  for i=1, 3 do
    local point1 = points[i]
    local point2 = points[i + 1] or points[1]
    Graphics.CSurface.GL_DrawLine(
      point1[1],
      point1[2], 
      point2[1], 
      point2[2], 
      borderWidth, 
      borderColor
    )
  end
end

mods.libs.SG.SimpleShape._renderPolygon = function(self, modifierTable)
  local triangulated = mods.libs.SG.Polygon:triangulatePoly(modifierTable.points)
  local color = modifierTable.color or Graphics.GL_Color(1, 1, 1, 1)
  local borderColor = modifierTable.borderColor or Graphics.GL_Color(1, 1, 1, 1)
  local borderWidth = modifierTable.borderWidth or 0

  for i = 1, #triangulated do
    local tri = triangulated[i]
    local point1 = tri[1]
    local point2 = tri[2]
    local point3 = tri[3]
    self:_renderTriangle({
      point1 = point1,
      point2 = point2,
      point3 = point3,
      color = color
    })
  end

  for i = 1, #modifierTable.points do
    local point1 = modifierTable.points[i]
    local point2 = modifierTable.points[i + 1] or modifierTable.points[1]
    self._renderLine({
      point1 = point1,
      point2 = point2,
      width = borderWidth,
      color = borderColor
    })
  end
end

---@override
mods.libs.SG.SimpleShape.show = function(self, modifierTable)

  if not self._isShowing then
    return
  end

  if self.shape == "rect" then
    self._renderRect(modifierTable)
  elseif self.shape == "triangle" then
    self._renderTriangle(self, modifierTable)
  elseif self.shape == "line" then
    self._renderLine(modifierTable)
  elseif self.shape == "polygon" then
    self._renderPolygon(self, modifierTable)
  else
    error("Unknown shape: " .. self.shape)
  end
  
end

_G['Draw_Amongus'] = function() 
  local sus = {
    {154, -117}, {169, -270}, {259, -293},
    {257, 86}, {151, 221}, {8, 226},
    {-123, 108}, {-116, -273}, {-14, -282},
    {-4, -120}}; 
  local sus2 = {
    {-14, 55}, {-15, 12}, {9, -24},
    {118, -27}, {154, -4}, {153, 47},
    {140, 79}, {27, 80}, {-13, 54}};
  local SimpleShape = mods.libs.SG.SimpleShape;
  local ColorFactory = mods.libs.SG.SimpleSprite.colorFactory;
  script.on_render_event(Defines.RenderEvents.GUI_CONTAINER, 
    function() end,
    function()
      SimpleShape:new("polygon"):show({
        points = sus,
        color = ColorFactory("ff0000ff"),
        borderWidth = 5
      })
      SimpleShape:new("polygon"):show({
        points = sus2,
        color = ColorFactory("47a9ffff"),
        borderWidth = 5
      })

      Graphics.freetype.easy_print(20, 400, 580, "GET SUS'ED LOL")
    end
  )
end