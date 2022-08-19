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
local pointsHexagon = {
  -- points for a standard hexagon with 6 sides, there should be 6 points
  -- each point is a tuple of x and y coordinates, the first value is the x, the second is the y
  -- each side should be the same length, which is 100
  {100, 0},
  {200, 0},
  {300, 100},
  {300, 200},
  {200, 300},
  {100, 300},
  {0, 200},
  {0, 100},
}

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


-- given a table of points which, when connected together, make a polygon outline 
-- use triangles to fill in the polygon
-- loop through the points and draw triangles between them
-- use the least amount of triangles possible
-- example: a hexagon has 6 points, but can be filled with 4 triangles
-- the first triangle should be made with the first point, second point, and third point
-- the second triangle should be made with the first point, thrid point, and fourth point
-- the third triangle should be made with the first point, fourth point, and fifth point
-- the fourth triangle should be made with the first point, fifth point, and sixth point
-- should be able to suppot any amount of points in the polygon
-- the triangles should be drawn in the order that they are made
-- use ear clipping to make the triangles
-- if the polygon is not convex, the triangles should be drawn in the order that they are made
-- function drawPolygonWithTriangles(pointsTable)
--   local points = pointsTable
--   local pointCount = #points
--   local triangles = {}
--   for i = 1, pointCount do
--     local point1 = points[i]
--     local point2 = points[i + 1]
--     if point2 == nil then
--       point2 = points[1]
--     end
--     local point3 = points[i + 2]
--     if point3 == nil then
--       point3 = points[2]
--     end
--     local point4 = points[i + 3]
--     if point4 == nil then
--       point4 = points[3]
--     end
--     local point5 = points[i + 4]
--     if point5 == nil then
--       point5 = points[4]
--     end
--     local point6 = points[i + 5]
--     if point6 == nil then
--       point6 = points[5]
--     end
--     SimpleShape:new("triangle"):show({
--       point1 = point1,
--       point2 = point2,
--       point3 = point3,
--       color = SimpleSprite.colorFactory("ff0000ff")
--     })
--     SimpleShape:new("triangle"):show({
--       point1 = point1,
--       point2 = point3,
--       point3 = point4,
--       color = SimpleSprite.colorFactory("ff0000ff")
--     })
--     SimpleShape:new("triangle"):show({
--       point1 = point1,
--       point2 = point4,
--       point3 = point5,
--       color = SimpleSprite.colorFactory("ff0000ff")
--     })
--     SimpleShape:new("triangle"):show({
--       point1 = point1,
--       point2 = point5,
--       point3 = point6,
--       color = SimpleSprite.colorFactory("ff0000ff")
--     })
--   end
-- end

-- script.on_render_event(Defines.RenderEvents.LAYER_PLAYER, 
--   function() end,
--   function()
--     drawPolygonWithTriangles(pointsHexagon)
--   end
-- )

-- local stopSign = SimpleShape:new("polygon", 8)
-- local tri = SimpleShape:new("triangle")

local pointsOctagon = {
  {100, 0},
  {200, 0},
  {300, 100},
  {300, 200},
  {200, 300},
  {100, 300},
  {0, 200},
  {0, 100},
}

local sus = {
  {154, -117},
  {169, -270},
  {259, -293},
  {257, 86},
  {151, 221},
  {8, 226},
  {-123, 108},
  {-116, -273},
  {-14, -282},
  {-4, -120}
}
local sus2 = {
  {-14, 55},
  {-15, 12},
  {9, -24},
  {118, -27},
  {154, -4},
  {153, 47},
  {140, 79},
  {27, 80},
  {-13, 54},
}

-- script.on_render_event(Defines.RenderEvents.GUI_CONTAINER, 
--   function() end,
--   function()
--     -- stopSign:show({
--     --   points = pointsOctagon,
--     --   color = SimpleSprite.colorFactory("ff0000ff"),
--     --   borderColor = SimpleSprite.colorFactory(207, 207, 207, 1),
--     --   borderWidth = 5
--     -- })

--     -- tri:show({
--     --   point1 = {-100, -100},
--     --   point2 = {-200, -200},
--     --   point3 = {-300, -100},
--     --   color = SimpleSprite.colorFactory("ff0000ff"),
--     --   borderColor = SimpleSprite.colorFactory(207, 207, 207, 1),
--     --   borderWidth = 5
--     -- })

--     SimpleShape:new("polygon"):show({
--       points = sus,
--       color = SimpleSprite.colorFactory("ff0000ff"),
--       borderWidth = 5
--     })
--     SimpleShape:new("polygon"):show({
--       points = sus2,
--       color = SimpleSprite.colorFactory("47a9ffff"),
--       borderWidth = 5
--     })
--   end
-- )
