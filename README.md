# FTL-Hyperspace-SimpleGraphics

A graphics library that simplifies drawing sprites on to the game screen.

##### This library depends on the latest version of FTL Hyperapce to function, please install the latest extension files that enables Lua.

##### Install [FTL Hyperspace](https://github.com/FTL-Hyperspace/FTL-Hyperspace) or found in the [FTL-Multiverse Discord server](https://discord.com/channels/604415384979898464/865264119795941397/987189605080133682).

---

### Features

- Utility functions for displaying all kinds of sprite images
- Support for playing whole animation sheets
- Highly customizable placements, sizes, time, and more
- Also allows drawing of shapes to accompany your sprites

### Initiative

This library was made to provide an abstraction over the raw exposed functions that Hyperspace offers, which is hard to read and lacks documentation. Because of the nature of the graphics functions, they must run on render events. Which often leads to hard-to-understand code. Therefore, this also provides modders with a consistent syntax for displaying sprite images.  
Special thanks to <u>vertaalfout#3043</u> for providing with the first versions of the functions that renders animations.

---

## Quick start

1. Download the distribution build.  
   _If you plan to use only part of the functionalities, download `SimpleSprite.lua` plus whichever files you need._
2. Include the file in your mods' `<scripts>` section found inside `hyperspace.xml`.

```xml
<scripts>
  <script>data/SimpleGraphics_dist_min.lua</script>
  <!-- make sure to place it above your other scripts -->
  <script>data/my_amazing_script.lua</script>
</scripts>
```

3. Inside a script file, initiate a sprite by calling `new()`, then assigning it to a local variable. In the `new` constructor, pass in a string representing the path to your image, relative to the `img` folder of your mod. Be sure that the image is in `.png` format.

```lua
local bacon = SimpleSprite:new("bacon") -- root/img/bacon.png
```

4. In the same script file, add an event callback for any of the [render events](https://github.com/FTL-Hyperspace/FTL-Hyperspace/wiki/Lua-Script-Module#on_render_eventrenderevents-event-beforecallback-aftercallback). The render events decides which layer your graphics will be drawn on. For example, the `LAYER_PLAYER` value draws at the player ships's layer.  
   Functions are first class objects in Lua, so other than creating them anonymously, they can also be defined elsewhere and passed to `on_render_event`.

```lua
script.on_render_event(Defines.RenderEvents.LAYER_PLAYER,
  function()
  -- things here will happen BEFORE the selected layer renders.
  -- so they will render below the objects drawn here
  end,
  function()
  -- things here will happen AFTER the selected layer renders.
  -- so they will render above the objects drawn here
  end
)
```

5. Pick when your sprite will be drawn. Then, inside the callback function, call `show()` on the sprite to make it appear. You can also pass various parameters, or modifiers, to `show()` as a table, in order to customize the sprite. A full list of allowed modifiers can be found in the [documentations](./docs/documentation.md) page.

```lua
script.on_render_event(Defines.RenderEvents.LAYER_PLAYER,
  function() end,
  function()
    bacon:show({Xalign = 100, Yalign = 100})
  end
)
```

6. Now patch your mod and run the game. Start a new game. If all goes well, the image will show up in the place a bit right and above the game window's center.

7. To make the sprite go away, call `hide()` on it. However, `hide` will immediately hide your sprite, resulting in nothing showing up. To prevent this, call `wait()` and pass in a number representing the amount of seconds to wait before the sprite hides itself.

```lua
script.on_render_event(Defines.RenderEvents.LAYER_PLAYER,
  function() end,
  function()
    bacon:show({Xalign = 100, Yalign = 100})
    bacon:wait(5)
    bacon:hide()
  end
)
```

8. Now try and run the game again. Sprite `bacon` should show up for 5 seconds, then hide itself.

9. One thing to beware of, is that `wait` does not pause the execution of the function. Therefore, they do not work as they seem to be inside loops. This is also because `on_render_event` callbacks runs many times per second, which means your loop is also ran many times.  
  Loops can be used to show an amount of sprites at once, or hide them at once, but never a mixture of these actions.

```lua
-- this will only show up for 1 second:
function()
  for i=0, 10 do 
    bacon:show({Xalign = 100, Yalign = 100})
    bacon:wait(1)
    bacon:hide()
  end
  bacon:hide()
end
```
10. As mentioned, the looping nature of `on_render_event` callbacks can be used in our favour. You can use local variables outside of the callback to keep track of things, then increment/decrement them inside the function, allowings interesting interactions.   
  For example, this will move the sprite to the top-right corner rapidly , then hide if it is out of sight.
```lua
local x = 0
local y = 0
script.on_render_event(Defines.RenderEvents.LAYER_PLAYER,
  function() end,
  function()
    bacon:show({Xalign = x, Yalign = y})
    x = x + 1
    y = y + 1
    if x > 680 and y > 360 then
      bacon:hide()
    end
  end
)
```

11. In most cases, you will not want the sprite to show up right when the game starts, and rather when a certain event runs. Sprites provide a property `state` for this purpose. You can do a conditional check inside the callback for this property.  
  It can also be toggled by calling the `toggleState()` method inside a `on_game_event` callback.   
  The `state` is `off` by default.

```lua
script.on_game_event("TEST_LUA", false, function()
  bacon:toggleState()
end)

script.on_render_event(Defines.RenderEvents.LAYER_PLAYER,
  function() end,
  function()
    if bacon:getState() == "off" then return end -- skips the rest if off

    bacon:show({Xalign = 100, Yalign = 100})
    bacon:wait(5)
    bacon:hide()
  end
)
```
#### End of quick start guide.

___

## More resources
- [Full documentations](./docs/documentation.md)
- [More examples from testing  (*cleanup needed*)](./simple_tests.lua)