mods.libs = mods.libs or {}
mods.libs.SG = {
  name = "SimpleGraphics",
  version = "1.1",
  author = "C20H12untitled",
}
---@class SimpleSprite
mods.libs.SG.SimpleSprite = {
  _isShowing = true,
  _timer = 0,
  _shouldHide = false,
  _texture = nil,
  _state = "off",

  new = function(self, imgName)
    local o = {imgName = imgName}
    o._texture = Hyperspace.Resources:GetImageId(imgName .. ".png")
    self.__index = self
    return setmetatable(o, self)
  end,

  _processModifiers = function(self, modifierTable)
    local width = modifierTable.width or self._texture.width
    local height = modifierTable.height or self._texture.height
    local positionX = 1280 / 2 - width / 2 + (modifierTable.Xalign or 0)
    local positionY = 720 / 2 - height / 2 - (modifierTable.Yalign or 0)
    local rotation = modifierTable.rotation or 0
    local color = modifierTable.color or Graphics.GL_Color(1, 1, 1, 1)
    local isMirror = modifierTable.isMirror or false
    local arr = {positionX, positionY, width, height, rotation, color, isMirror}
    return arr
  end,

  toggleState = function(self)
    if self._state == "off" then
      self._state = "on"
    else
      self._state = "off"
    end
  end,

  getState = function(self)
    return self._state
  end,

  show = function(self, modifierTable)
    
    if not self._isShowing then
      return
    end
    
    modifierTable = modifierTable or {}
    local processedModifiers = self:_processModifiers(modifierTable)
    Graphics.CSurface.GL_BlitImage(
      self._texture,
      table.unpack(processedModifiers)
    )
  end,
  hide = function(self)
    local isTimerInitialized = self._timer ~= 0
    if self._shouldHide or (not isTimerInitialized) then
      self._isShowing = false
      self._shouldHide = false
    end
    return self._isShowing
  end,
  wait = function(self, sec)
    if not self._isShowing then 
      return sec + 1
    end

    self._timer = self._timer + (Hyperspace.FPS.SpeedFactor / 16)
    if self._timer > sec then
      self._shouldHide = true
    end

    return self._timer
  end,
  reset = function(self)
    self._timer = 0
    self._isShowing = true
    self._shouldHide = false
  end,

  colorFactory = function(rOrHex, g, b, a)
    local rr, gg, bb, aa;
    if type(rOrHex) == "string" then
      rr = tonumber(rOrHex:sub(1, 2), 16) / 255
      gg = tonumber(rOrHex:sub(3, 4), 16) / 255
      bb = tonumber(rOrHex:sub(5, 6), 16) / 255
      aa = tonumber(rOrHex:sub(7, 8), 16) / 255
    else
      rr = rOrHex / 255
      gg = g / 255
      bb = b / 255
      aa = a
    end
    return Graphics.GL_Color(rr, gg, bb, aa)
  end,

  randint = function(min, max)
    return Hyperspace.random32() % (max + 1 - min) + min
  end,
}
---@class SimpleAnimatedSprite : SimpleSprite
mods.libs.SG.SimpleAnimatedSprite = mods.libs.SG.SimpleSprite:new('null')

mods.libs.SG.SimpleAnimatedSprite._animTimer = 0

mods.libs.SG.SimpleAnimatedSprite.new = function(self, imgName, frameCount, rows)
  local o = mods.libs.SG.SimpleSprite.new(self, imgName)
  o.frameCount = frameCount
  o.rows = rows or 1
  self.__index = self
  return setmetatable(o, self)
end

mods.libs.SG.SimpleAnimatedSprite._processModifiers = function(self, modifierTable)
  local width = modifierTable.width or (self._texture.width / self.frameCount)
  local height = modifierTable.height or (self._texture.height / self.rows)
  local positionX = 1280 / 2 - width / 2 + (modifierTable.Xalign or 0)
  local positionY = 720 / 2 - height / 2 - (modifierTable.Yalign or 0)
  local color = modifierTable.color or Graphics.GL_Color(1, 1, 1, 1)
  local isMirror = modifierTable.isMirror or false
  local arr = {positionX, positionY, width, height, color, isMirror}
  return arr
end

mods.libs.SG.SimpleAnimatedSprite._renderAnim = function(self, currFrameNumber, pModifs)
  local startFrame = currFrameNumber / self.frameCount
  local endFrame = (currFrameNumber + 1) / self.frameCount

  Graphics.CSurface.GL_BlitImagePartial(
    self._texture, 
    pModifs[1], 
    pModifs[2], 
    pModifs[3], 
    pModifs[4], 
    startFrame, 
    endFrame, 
    1, 
    0, 
    1, 
    pModifs[5], 
    pModifs[6]
  )
end

mods.libs.SG.SimpleAnimatedSprite._renderMultilineAnim = function(self, currFrameNumber, pModifs)
  local currentRow = math.floor(currFrameNumber / self.frameCount)
  local currentColumn = currFrameNumber %  self.frameCount

  local startX = currentColumn / self.frameCount
  local endX = (currentColumn+1) / self.frameCount
  local startY = currentRow / self.rows
  local endY = (currentRow + 1) / self.rows

  Graphics.CSurface.GL_BlitImagePartial(
    self._texture, 
    pModifs[1], 
    pModifs[2], 
    pModifs[3], 
    pModifs[4], 
    startX, 
    endX, 
    startY, 
    endY, 
    1,
    pModifs[5], 
    pModifs[6]
  )
end

mods.libs.SG.SimpleAnimatedSprite.show = function(self, time, modifierTable)
  if not self._isShowing then
    return true
  end

  self._animTimer = self._animTimer + (Hyperspace.FPS.SpeedFactor / 16)

  local currentFrameNumber = math.floor(self._animTimer * self.frameCount / time)

  local modifierTable = modifierTable or {}
  local processedModifs = self:_processModifiers(modifierTable)

  if self.rows == 1 then
    self:_renderAnim(currentFrameNumber, processedModifs)
  else
    self:_renderMultilineAnim(currentFrameNumber, processedModifs)
  end

  if currentFrameNumber >= (self.frameCount * self.rows) then
    self._isShowing = false
  end

  return false
end

---@override
mods.libs.SG.SimpleAnimatedSprite.reset = function(self)
  self._timer = 0
  self._animTimer = 0
  self._isShowing = true
  self._shouldHide = false
end
---@class Polygon static 
mods.libs.SG.Polygon = {
  -- Reference https://2dengine.com/?p=polygons

  -- Finds twice the signed area of a polygon
  signedPolyArea = function(pointsTable)
    local area = 0
    local totalPoints = #pointsTable
    local lastPoint = pointsTable[totalPoints]
    for i = 1, totalPoints do
      local currPoint = pointsTable[i]
      area = area + (currPoint[1] + lastPoint[1]) * (currPoint[2] - lastPoint[2])
      lastPoint = currPoint
    end
    return area
  end,

  -- Finds the actual area of a polygon
  polyArea = function(self, pointsTable)
    local area = self.signedPolyArea(pointsTable)
    return math.abs(area / 2)
  end,

  -- Checks if the winding of a polygon is counter-clockwise
  isPolyCCW = function(self, pointsTable)
    return self.signedPolyArea(pointsTable) > 0
  end,

  -- Reverses the vertex winding
  polyReverse = function(pointsTable)
    local reversed = {}
    local totalPoints = #pointsTable
    for i = 1, totalPoints do
      reversed[i] = pointsTable[totalPoints - i + 1]
    end
    return reversed
  end,

  -- Finds twice the signed area of a triangle
  signedTriArea = function(point_1, point_2, point_3)
    return ((point_1[1] - point_3[1]) * (point_2[2] - point_3[2]) 
            - 
            (point_1[2] - point_3[2]) * (point_2[1] - point_3[1])
          )
  end,

  -- Checks if a point is inside a triangle
  pointInTri = function(point, tri_pt1, tri_pt2, tri_pt3)
    local point_x = point[1]
    local point_y = point[2]
    local px1 =  tri_pt1[1] - point_x
    local py1 = tri_pt1[2] - point_y
    local px2 = tri_pt2[1] - point_x
    local py2 = tri_pt2[2] - point_y
    local px3 = tri_pt3[1] - point_x
    local py3 = tri_pt3[2] - point_y
    local ab = px1 * py2 - py1 * px2
    local bc = px2 * py3 - py2 * px3
    local ca = px3 * py1 - py3 * px1
    local sab = ab < 0
    local sbc = bc < 0
    local sca = ca < 0
    if sab ~= sbc then
      return false
    end
    return sab == sca
  end,

  -- Checks if the vertex is an "ear" or "mouth"
  left = {},
  right = {}, -- linked lists? maybe?

  isEar = function(self, point_1, point_2, point_3) -- points are pairs

    if self.signedTriArea(point_1, point_2, point_3) >= 0 then
      local j1 = self.right[point_3]

      repeat
        local j0 = self.left[j1]
        local j2 = self.right[j1]
        if self.signedTriArea(j0, j1, j2) <= 0 then
          if self.pointInTri(j1, point_1, point_2, point_3) then
            return false
          end
        end
        j1 = j2
      until j1 == point_1

      return true
    end

    return false
  end,

  -- Triangulates a counter-clockwise polygon
  triangulatePoly = function(self, pointsTable)
    if not self:isPolyCCW(pointsTable) then
      pointsTable = self.polyReverse(pointsTable)
    end

    local numberOfPoints = #pointsTable

    for i = 1, numberOfPoints do
      local v = pointsTable[i]
      self.left[v], self.right[v] = pointsTable[i - 1], pointsTable[i + 1]
    end

    local firstPoint = pointsTable[1]
    local lastPoint = pointsTable[numberOfPoints]
    self.left[firstPoint] = lastPoint
    self.right[lastPoint] = firstPoint

    local out = {}
    local skippedCounter = 0
    local i1 = firstPoint
    while numberOfPoints >= 3 and skippedCounter <= numberOfPoints do
      local i0, i2 = self.left[i1], self.right[i1]
      if numberOfPoints > 3 and self:isEar(i0, i1, i2) then
        table.insert(out, { i0, i1, i2 })
        self.left[i2], self.right[i0] = i0, i2     
        self.left[i1], self.right[i1] = nil, nil
        skippedCounter = 0
        i1 = i0
      else
        skippedCounter = skippedCounter + 1
        i1 = i2
      end
    end
    return out
  end
}
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

  if borderWidth > 0 then
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