-- local bacon = SimpleSprite:new("bacon")
-- local bacon2 = SimpleSprite:new("bacon")
-- local x = -250
-- local y = 0
-- local sqrt = math.sqrt

-- script.on_game_event("TEST_LUA", false, function()
--   bacon:toggleState()
--   bacon2:toggleState()
-- end)

-- script.on_render_event(Defines.RenderEvents.LAYER_PLAYER, 
--   function() end, 
--   function()

--     if bacon:getState() == "off" and bacon2:getState() == "off" then 
--       bacon:reset()
--       bacon2:reset()
--       x = -250
--       y = 0
--       return 
--     end

--     bacon:show({Xalign = x, Yalign = y})
--     bacon2:show({Xalign = x, Yalign = -y})

--     if x > 250 then
--       bacon:hide()
--       bacon2:hide()
--     else
--       x = x + 1
--       y = sqrt(250 ^ 2 - x ^ 2)
--     end

--   end
-- )

-- local flagship_gun = SimpleAnimatedSprite:new("flagship_gun", 15)
-- local flagship_gun2 = SimpleAnimatedSprite:new("flagship_gun", 15)
-- local x = -250
-- local y = 0

-- script.on_game_event("TEST_LUA", false, function()
--   flagship_gun:toggleState()
--   flagship_gun2:toggleState()
-- end)


-- script.on_render_event(Defines.RenderEvents.LAYER_PLAYER, 
--   function() end, 
--   function()

--     if flagship_gun:getState() == "off" and flagship_gun2:getState() == "off" then 
--       flagship_gun:reset()
--       flagship_gun2:reset()
--       x = -250
--       y = 0
--       return
--     end

--     flagship_gun:show(10, {Xalign = x, Yalign = y})
--     flagship_gun2:show(10, {Xalign = x, Yalign = -y})

--     if x > 250 then
--       flagship_gun:hide()
--       flagship_gun2:hide()
--       flagship_gun:toggleState()
--       flagship_gun2:toggleState()
--     else 
--       x = x + 1
--       y = sqrt(250 ^ 2 - x ^ 2)
--     end

--   --   flagship_gun:show(10, {Xalign = x, Yalign = y, isMirror = true})
    
--   --   if x == 100 then
--   --     flagship_gun:wait(5)
--   --     flagship_gun:hide()
--   --   else 
--   --     x = x + 1
--   --   end

--     -- local isFinished = flagship_gun:show(10, {Xalign = x, Yalign = y})
--     -- if isFinished then
--     --   flagship_gun:reset()
--     -- end
--   end
-- )

local rect = SimpleShape:new("rect")
local tri = SimpleShape:new("triangle")

script.on_render_event(Defines.RenderEvents.LAYER_PLAYER, 
function() end,
function()
  rect:show({
    Xalign = 100,
    Yalign = 100,
    width = 100,
    height = 100,
    color = SimpleSprite.colorFactory("ffeeffff"),
    borderColor = SimpleSprite.colorFactory("ff0000ff"),
    borderWidth = 10
  })
  
  local timePassed = rect:wait(5)
  rect:hide()

  if timePassed > 5 then
    tri:show({
      point1 = {100, 100},
      point2 = {200, 200},
      point3 = {300, 100},
    })
    tri:wait(5)
    tri:hide()
  end
end
)