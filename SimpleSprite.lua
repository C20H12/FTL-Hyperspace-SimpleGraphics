---@class SimpleSprite
SimpleSprite = {
  _isShowing = true,
  _imgTimer = 0,
  _shouldHide = false,
  _texture = nil,

  new = function(self, imgName)
    local o = {imgName = imgName}
    self.__index = self
    self._texture = Hyperspace.Resources:GetImageId(imgName .. ".png")
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
    local isTimerInitialized = self._imgTimer ~= 0
    if self._shouldHide or (not isTimerInitialized) then
      self._isShowing = false
      self._shouldHide = false
    end
  end,
  wait = function(self, sec)
    if self._shouldHide then return end

    self._imgTimer = self._imgTimer + (Hyperspace.FPS.SpeedFactor / 16)
    if self._imgTimer > sec then
      self._shouldHide = true
    end
  end,
  reset = function(self)
    self._imgTimer = 0
    self._isShowing = true
    self._shouldHide = false
  end,

  colorFactory = function(r, g, b, a)
    local rr = r / 255
    local gg = g / 255
    local bb = b / 255
    return Graphics.GL_Color(rr, gg, bb, a)
  end,
}
