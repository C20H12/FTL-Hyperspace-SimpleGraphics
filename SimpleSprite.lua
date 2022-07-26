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

  _checkPos = function(self, x, y, screenCenterMode)
    if screenCenterMode and ((x > 680 or x < -680) or (y > 360 or y < -360)) then
      log(
        string.format(
          "[SG] WARNING: Sprite %s is too far from the screen center, it may be invisible. Current coordinates: %i, %i",
          self.imgName, x, y
        )
      )
    elseif not screenCenterMode and ((x > 1280 or x < 0) or (y > 720 or y < 0)) then
      log(
        string.format(
          "[SG] WARNING: Sprite %s is outside the screen, it may be invisible. Current coordinates: %i, %i",
          self.imgName, x, y
        )
      )
    end
  end,

  _processModifiers = function(self, modifierTable)
    local width = modifierTable.width or self._texture.width
    local height = modifierTable.height or self._texture.height

    local useSC = modifierTable.useScreenCenter or true
    local useIC = modifierTable.useImageCenter or true

    local screenCenter = useSC and {1280 / 2, 720 / 2} or {0, 0}
    local imageCenter = useIC and {width / 2, height / 2} or {0, 0}

    local positionX = screenCenter[1] - imageCenter[1] + (modifierTable.Xalign or 0)
    local positionY = screenCenter[2] - imageCenter[2] - (modifierTable.Yalign or 0)

    self:_checkPos(positionX, positionY, useSC)

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

  --static
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
