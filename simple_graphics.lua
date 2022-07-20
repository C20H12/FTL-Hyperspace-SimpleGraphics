
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
    return {positionX, positionY, width, height, rotation, color, isMirror}
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
}

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



local bacon = SimpleSprite:new("bacon")
local bacon2 = SimpleSprite:new("bacon")
local x = -250
local y = 0
local sqrt = math.sqrt
local bool = false

script.on_game_event("TEST_LUA", false, function()
  bool = not bool
end)

script.on_render_event(Defines.RenderEvents.LAYER_PLAYER, 
  function() end, 
  function()

    if not bool then 
      bacon:reset()
      bacon2:reset()
      x = -250
      y = 0
      return 
    end

    bacon:show({Xalign = x, Yalign = y})
    bacon2:show({Xalign = x, Yalign = -y})

    if x > 250 then
      bacon:hide()
      bacon2:hide()
    else
      x = x + 1
      y = sqrt(250 ^ 2 - x ^ 2)
    end

  end
)