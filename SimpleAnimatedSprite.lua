---@class SimpleAnimatedSprite : SimpleSprite
SimpleAnimatedSprite = SimpleSprite:new('null')

SimpleAnimatedSprite._animTimer = 0

SimpleAnimatedSprite.new = function(self, imgName, frameCount, rows)
  local o = SimpleSprite.new(self, imgName)
  o.frameCount = frameCount
  o.rows = rows or 1
  self.__index = self
  return setmetatable(o, self)
end

SimpleAnimatedSprite._processModifiers = function(self, modifierTable)
  local width = modifierTable.width or (self._texture.width / self.frameCount)
  local height = modifierTable.height or (self._texture.height / self.rows)
  local positionX = 1280 / 2 - width / 2 + (modifierTable.Xalign or 0)
  local positionY = 720 / 2 - height / 2 - (modifierTable.Yalign or 0)
  local color = modifierTable.color or Graphics.GL_Color(1, 1, 1, 1)
  local isMirror = modifierTable.isMirror or false
  local arr = {positionX, positionY, width, height, color, isMirror}
  return arr
end

SimpleAnimatedSprite._renderAnim = function(self, currFrameNumber, pModifs)
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

SimpleAnimatedSprite._renderMultilineAnim = function(self, currFrameNumber, pModifs)
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

SimpleAnimatedSprite.show = function(self, time, modifierTable)
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
SimpleAnimatedSprite.reset = function(self)
  self._timer = 0
  self._animTimer = 0
  self._isShowing = true
  self._shouldHide = false
end