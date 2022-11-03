--------------------
-- Simple static sprite that moves example
-- sprite will move from left to right of screen in a curve
-- then hide then finished
-- is activated with an event
--------------------
local bacon = SimpleSprite:new("bacon")
local bacon2 = SimpleSprite:new("bacon")
local x = -250
local y = 0
local sqrt = math.sqrt

script.on_game_event("TEST_LUA", false, function()
  bacon:toggleState()
  bacon2:toggleState()
end)

script.on_render_event(Defines.RenderEvents.LAYER_PLAYER, 
function() end, 
function()

  if bacon:getState() == "off" and bacon2:getState() == "off" then 
    bacon:reset()
    bacon2:reset()
    x = -250
    y = 0
    return 
  end

  bacon:show({Xalign = x, Yalign = y})
  bacon2:show({Xalign = x, Yalign = -y})
  
  x = x + 1
  y = sqrt(250 ^ 2 - x ^ 2)
  
  if x > 250 then
    bacon:hide()
    bacon2:hide()
  end

end)


--------------------
-- Animated sprite that moves example
-- similar to above but with a animation
-- except this one will reset itself when it reaches the dest coords
--------------------
local flagship_gun = SimpleAnimatedSprite:new("flagship_gun", 15)
local flagship_gun2 = SimpleAnimatedSprite:new("flagship_gun", 15)
local x = -250
local y = 0

script.on_game_event("TEST_LUA", false, function()
  flagship_gun:toggleState()
  flagship_gun2:toggleState()
end)

script.on_render_event(Defines.RenderEvents.LAYER_PLAYER, 
  function() end, 
  function()

    if flagship_gun:getState() == "off" and flagship_gun2:getState() == "off" then 
      flagship_gun:reset()
      flagship_gun2:reset()
      x = -250
      y = 0
      return
    end

    flagship_gun:show(10, {Xalign = x, Yalign = y})
    flagship_gun2:show(10, {Xalign = x, Yalign = -y})

    if x > 200 then
      flagship_gun:wait(3)
      flagship_gun2:wait(3)
      flagship_gun:hide()
      flagship_gun2:hide()
      flagship_gun:toggleState()
      flagship_gun2:toggleState()
    else 
      x = x + 1
      y = sqrt(250 ^ 2 - x ^ 2)
    end
  end
)


--------------------
-- showing objects in a sequence example
-- the triangle is only shown after the rect hides
--------------------
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
  local isShowing = rect:hide()

  if not isShowing then
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


--------------------
-- Simple animation example
-- plays the rick anim
--------------------
local rick = SimpleAnimatedSprite:new("rick", 10, 4)

script.on_render_event(Defines.RenderEvents.LAYER_PLAYER, 
  function() end, 
  function()
    rick:show(5, {
      Xalign = 100,
      Yalign = 100,
    })
  end
)


--------------------
-- Drawing complex shapes
-- such as this octagon with borders or this amongus figure
--------------------
local stopSign = SimpleShape:new("polygon", 8)

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

script.on_render_event(Defines.RenderEvents.GUI_CONTAINER, 
  function() end,
  function()
    stopSign:show({
      points = pointsOctagon,
      color = SimpleSprite.colorFactory("ff0000ff"),
      borderColor = SimpleSprite.colorFactory(207, 207, 207, 1),
      borderWidth = 5
    })

    SimpleShape:new("polygon"):show({
      points = sus,
      color = SimpleSprite.colorFactory("ff0000ff"),
      borderWidth = 5
    })
    SimpleShape:new("polygon"):show({
      points = sus2,
      color = SimpleSprite.colorFactory("47a9ffff"),
      borderWidth = 5
    })
  end
)
