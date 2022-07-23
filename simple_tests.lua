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
    
--     x = x + 1
--     y = sqrt(250 ^ 2 - x ^ 2)
    
--     if x > 250 then
--       bacon:hide()
--       bacon2:hide()
--     end
    
    
    -- for i=0, 10 do 
    --   bacon:show({Xalign = 100, Yalign = 100})
    --   bacon:wait(1)
    --   bacon:hide()
    --   bacon:reset()
    -- end

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

--     if x > 200 then
--       flagship_gun:wait(3)
--       flagship_gun2:wait(3)
--       flagship_gun:hide()
--       flagship_gun2:hide()
--       -- flagship_gun:toggleState()
--       -- flagship_gun2:toggleState()
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

-- local rect = SimpleShape:new("rect")
-- local tri = SimpleShape:new("triangle")

-- script.on_render_event(Defines.RenderEvents.LAYER_PLAYER, 
-- function() end,
-- function()
--   rect:show({
--     Xalign = 100,
--     Yalign = 100,
--     width = 100,
--     height = 100,
--     color = SimpleSprite.colorFactory("ffeeffff"),
--     borderColor = SimpleSprite.colorFactory("ff0000ff"),
--     borderWidth = 10
--   })
  
--   local timePassed = rect:wait(5)
--   local isShowing = rect:hide()

--   if not isShowing then
--     tri:show({
--       point1 = {100, 100},
--       point2 = {200, 200},
--       point3 = {300, 100},
--     })
--     tri:wait(5)
--     tri:hide()
--   end
-- end
-- )

-- given a table of points, draw a polygon
-- loop through the points and draw lines between them
-- local pointsHexagon = {
--   -- points for a standard hexagon with 6 sides, there should be 6 points
--   -- each point is a tuple of x and y coordinates, the first value is the x, the second is the y
--   -- each side should be the same length, which is 100
--   {100, 0},
--   {200, 0},
--   {300, 100},
--   {300, 200},
--   {200, 300},
--   {100, 300},
--   {0, 200},
--   {0, 100},
-- }

-- function drawPolygon(pointsTable)
--   local points = pointsTable
--   local pointCount = #points
--   for i = 1, pointCount do
--     local point1 = points[i]
--     local point2 = points[i + 1]
--     if point2 == nil then
--       point2 = points[1]
--     end
--     SimpleShape:new("line"):show({
--       point1 = point1,
--       point2 = point2,
--       color = SimpleSprite.colorFactory("ff0000ff"),
--       width = 10
--     })
--   end
-- end

-- script.on_render_event(Defines.RenderEvents.LAYER_PLAYER, 
--   function() 
--     drawPolygon(pointsHexagon)

--   end, 
--   function()
--   end
-- )

-- local rick = SimpleAnimatedSprite:new("rick", 10, 4)

-- script.on_render_event(Defines.RenderEvents.LAYER_PLAYER, 
--   function() end, 
--   function()
--     rick:show(5, {
--       Xalign = 100,
--       Yalign = 100,
--     })
--   end
-- )