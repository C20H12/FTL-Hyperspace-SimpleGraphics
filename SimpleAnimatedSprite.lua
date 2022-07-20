---@class SimpleAnimatedSprite : SimpleSprite
SimpleAnimatedSprite = SimpleSprite:new('null')

SimpleAnimatedSprite._animTimer = 0

SimpleAnimatedSprite.new = function(self, imgName, frameCount, rows)
  local o = SimpleSprite.new(self, imgName)
  o.frameCount = frameCount
  o.rows = rows or 1
  self.__index = self
  return setmetatable(initTable, self)
end

SimpleAnimatedSprite._renderAnim = function(self, time, pModifs)
  self._animTimer = self._animTimer + (Hyperspace.FPS.SpeedFactor / 16)

  local currFrameNumber = math.floor(self._animTimer * self.frameCount / time)
  local startFrame = currFrameNumber / self.frameCount
  local endFrame = (currFrameNumber + 1) / self.frameCount

  Graphics.CSurface.GL_BlitImagePartial(
    self._texture, 
    pModifs[0], 
    pModifs[1], 
    pModifs[2], 
    pModifs[3], 
    startFrame, 
    endFrame, 
    1, 
    0, 
    1, 
    pModifs[5], 
    pModifs[6]
  )
end
_renderMultilineAnim = function(self, imagepath, numberofframes, frame_width, frame_height, position_x, position_y, seconds)
  -- if mods.vals.animbool then

  --   animtimer_seconds = (animtimer_seconds or 0) + (Hyperspace.FPS.SpeedFactor / 16)
  --   local framenumber=math.floor((animtimer_seconds*numberofframes)/seconds)

  --   local tex=Hyperspace.Resources:GetImageId(imagepath)

  --   local framesperrow=tex.width/frame_width
  --   local rows=tex.height/frame_height

  --   local current_row = math.floor(framenumber/framesperrow)
  --   local current_column = framenumber % framesperrow

  --   local start_x = current_column/framesperrow
  --   local end_x = (current_column+1)/(framesperrow)
  --   local start_y = ((current_row)/(rows))
  --   local end_y = ((current_row+1)/(rows))
  --   local alpha = 1
  --   local color = Graphics.GL_Color(1, 1, 1, 1)
  --   local mirror = false

  --   Graphics.CSurface.GL_BlitImagePartial(tex, position_x, position_y, frame_width, frame_height, start_x, end_x, start_y, end_y, alpha, color, mirror)
  --   if animtimer_seconds > seconds then
  --       animtimer_seconds = nil
  --       mods.vals.animbool = false
  --   end
  -- end
end


---@override 
SimpleAnimatedSprite.show = function(self, time, modifierTable)
  if not self._isShowing then
    return
  end

  local modifierTable = modifierTable or {}
  local processedModifs = self:_processModifiers(modifierTable)

  if self.rows == 1 then
    self:_renderAnim(time, processedModifs)
  else
    self:_renderMultilineAnim()
  end
end



