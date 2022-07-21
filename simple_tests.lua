-- local bacon = SimpleSprite:new("bacon")
-- local bacon2 = SimpleSprite:new("bacon")
-- local x = -250
-- local y = 0
-- local sqrt = math.sqrt
-- local bool = false

-- script.on_game_event("TEST_LUA", false, function()
--   bool = not bool
-- end)

-- script.on_render_event(Defines.RenderEvents.LAYER_PLAYER, 
--   function() end, 
--   function()

--     if not bool then 
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

local flagship_gun = SimpleAnimatedSprite:new("rick", 10, 4)

script.on_render_event(Defines.RenderEvents.GUI_CONTAINER, 
  function() end, 
  function()
    flagship_gun:show(10)
  end
)