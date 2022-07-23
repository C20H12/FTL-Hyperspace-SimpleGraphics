# SimpleGraphics Documentation

## Index

- [ModifierTable](#type-modifiertable)
- [Simple Sprite](#class-simplesprite)
- [Simple Animated Sprite](#class-simpleanimatedsprite)
- [Simple Shape](#class-simpleshape)

---

<br/>

## Type: ModifierTable

The table that is passed to `show` methods in order to costomize the behavior of sprites.

### Members

- Sprite  
  `table`
  | Property | Type | |
  | --------- | -------- | -------------------------------------------------- |
  | width | `number` | -- The on-screen width, defaults to the image's width. |
  | height | `number` | -- The on-screen height, defaults to the image's height. |
  | Xalign | `number` | -- Amount of offset in the X direction. |
  | Yalign | `number` | -- Amount of offset in the Y direction. |
  | rotation | `number` | -- Degrees of rotation. |
  | color | `GL_Color` | -- The color filter that will apply to the image. |
  | isMirror | `boolean` | -- Should the image display mirrored? |

- AnimatedSprite  
  `table`
  | Property | Type | |
  | --------- | -------- | -------------------------------------------------- |
  | width | `number` | -- The width of each frame, defaults to the image's width / frames per row. |
  | height | `number` | -- The height of each frame, defaults to the image's height / rows. |
  | Xalign | `number` | -- Amount of offset in the X direction. |
  | Yalign | `number` | -- Amount of offset in the Y direction. |
  | color | `GL_Color` | -- The color filter that will apply to the image. |
  | isMirror | `boolean` | -- Should the image display mirrored? |

- Rect  
  `table`
  | Property | Type | |
  | --------- | -------- | -------------------------------------------------- |
  | width | `number` | -- The width of the rectangle. |
  | height | `number` | -- The height of the rectangle. |
  | Xalign | `number` | -- Amount of offset in the X direction. |
  | Yalign | `number` | -- Amount of offset in the Y direction. |
  | color | `GL_Color` | -- The fill color of the rectangle. |
  | borderColor | `GL_Color` | -- The border color. |
  | borderWidth | `number` | -- The border width. |

- Tri  
  `table`
  | Property | Type | |
  | --------- | -------- | -------------------------------------------------- |
  | point1 | `[number, number]` | -- The X, Y coordinates for the 1st vertice. |
  | point2 | `[number, number]` | -- The X, Y coordinates for the 2nd vertice. |
  | point3 | `[number, number]` | -- The X, Y coordinates for the  vertice. |

- Line  
  `table`
  | Property | Type | |
  | --------- | -------- | -------------------------------------------------- |
  | point1 | `[number, number]` | -- The X, Y coordinates for the start point. |
  | point2 | `[number, number]` | -- The X, Y coordinates for the end point. |

---

<br/>

## Class: SimpleSprite

Class containing functions for displaying sprite images. Also the base class for the other classes.

<br/>

### Constructor

`new( imgName )`

| Parameter | Type     |                                                    |
| --------- | -------- | -------------------------------------------------- |
| imgName   | `string` | -- The image name and path, with the /img as root. |

Initiates a new Sprite. The image name does not need to include the file extension. The image provided must be a `.png` format.

<br/>

### Properties

- imgName  
  `string`

  The image name or path passed into the constructor.

- \_isShowing  
  _protected_  
  `boolean`

  Is the sprite supposed to be showing?

- \_timer  
  _protected_  
  `number`

  Time elapsed since the start of `wait`.

- \_shouldHide  
  _protected_  
  `boolean`

  Should this sprite be hiding?

- \_texture  
  _protected_  
  `GL_Texture | nil`

  The texture converted from the raw image.

- \_state  
  _protected_  
  `"on" | "off"`

  The current state of this sprite.

<br/>

### Methods

- toggleState  
  `toggleState()`

  Switches the current state of the sprite.

- getState  
  `getState()`

  Gets the current state if the sprite.

  **Returns** `"on" | "off"`

- \_processModifiers  
  _private_  
  `_processModifiers( modifierTable )`
  | Parameter | Type | |
  | --------- | -------- | -------------------------------------------------- |
  | modifierTable | `ModifierTable.Sprite` | -- Table with the customizable properties. Passed from `show` method. |

  Processes the table to fill in any unspecified fields with default values.

  **Returns** `Arrary of number | GL_Color | boolean`

- show  
  `show( modifierTable )`  
  | Parameter | Type | |
  | --------- | -------- | -------------------------------------------------- |
  | modifierTable | `ModifierTable.Sprite \| nil` | --Table with the customizable properties. Is optional. |

  Starts the displaying of the sprite. Shows sprite at screen center by default.

- hide  
  `hide()`

  Stops the displaying of the sprite, if the wait time is fulfilled.

- wait  
  `wait( sec )`  
  | Parameter | Type | |
  | --- | -------- | ---------------------------------
  | sec | `number` | -- Number of seconds to wait for. |

  Switches `_shouldHide` after the timer expires, allowing `hide` calls to hide the sprite.

- reset  
  `reset()`

  Resets the boolean flags and the timer, allowing the sprite to be shown in the next `show` call.

- colorFactory  
  _static_  
  `colorFactory( hexString )`  
  | Parameter | Type | |
  | --------- | -------- | -------------------------------------------- |
  | hexString | `String` | -- A 8 digit hexadecimal value (rrggbbaa). |

  Processes the input and returns a color for use in shapes or filters on sprite images.

  **Returns** `GL_Color`

- colorFactory  
  _overload_  
  _static_  
  `colorFactory( rr, gg, bb, aa )`  
  | Parameter | Type | |
  | --------- | -------- | -------------------------------------------- |
  | rr | `number` | -- A number stating the amout of red (0 - 255). |
  | gg | `number` | -- A number stating the amout of green (0 - 255). |
  | bb | `number` | -- A number stating the amout of blue (0 - 255). |
  | bb | `number` | -- A number stating the amout of alpha (0 - 1). |

  Processes the input and returns a color for use in shapes or filters on sprite images.

  **Returns** `GL_Color`

- randint  
  _static_
  `randint( min, max )`  
  | Parameter | Type | |
  | --------- | -------- | -------------------------------------------- |
  | min | `number` | -- The minimum value of the range. |
  | max | `number` | -- The maximum value of the range. |

  Generates a random number for use in random coordinates for sprites.

  **Returns** `number` -- Integer withing the set range. Max not included.

---

<br/>

## Class: SimpleAnimatedSprite

_extends SimpleSprite_

Class containing functions for playing through various sized sprite sheets.

<br/>

### Constructor

`new( imgName, frameCount, rows )`

| Parameter  | Type            |                                                                                                                   |
| ---------- | --------------- | ----------------------------------------------------------------------------------------------------------------- |
| imgName    | `string`        | -- The image name and path, with the /img as root.                                                                |
| frameCount | `number`        | -- Number of frames in the sprite sheet. If sprite sheet has multiple rows, this is the number of frames per row. |
| rows       | `number \| nil` | -- Number of rows. Defaults to 1. Is optional.                                                                    |

Initiates a new animated sprite. The image name does not need to include the file extension. The image provided must be a `.png` format.

<br/>

### Properties

- imgName  
  `string`

  The image name or path passed into the constructor.

- frameCount  
  `number`

  The total amount of frames, or the number of frames in each row.

- \_isShowing  
  _inherited from SimpleSprite_

- \_timer  
  _inherited from SimpleSprite_

- \_shouldHide  
  _inherited from SimpleSprite_

- \_texture  
  _inherited from SimpleSprite_

- \_state  
  _inherited from SimpleSprite_

<br/>

### Methods

- toggleState  
  `toggleState()`  
  _inherited from SimpleSprite_

- getState  
  `getState()`  
  _inherited from SimpleSprite_

- \_processModifiers  
  _private_  
  `_processModifiers( modifierTable )`
  | Parameter | Type | |
  | --------- | -------- | -------------------------------------------------- |
  | modifierTable | `ModifierTable.AnimatedSprite` | -- Table with the customizable properties. Passed from `show` method. |

  Processes the table to fill in any unspecified fields with default values.

  **Returns** `Arrary of number | GL_Color | boolean`

- _renderAnim
  \_private_  
  `_renderAnim( currFrameNumber, processedModifs )`
  | Parameter | Type | |
  | --------- | -------- | -------------------------------------------------- |
  | currFrameNumber | `number` | -- The calculated frame number that should be rendered. |
  | processedModifs | `Array of number \| GL_color \| boolean` | -- Array of modifiers after processing. |

  Calculates the frame's location on the sprite sheet, and starts the rendering of a single frame to the screen.

- _renderMultilineAnim
  \_private_  
  `_renderMultilineAnim( currFrameNumber, processedModifs )`
  | Parameter | Type | |
  | --------- | -------- | -------------------------------------------------- |
  | currFrameNumber | `number` | -- The calculated frame number that should be rendered. |
  | processedModifs | `Array of number \| GL_color \| boolean` | -- Array of modifiers after processing. |

  Calculates the frame's location on the sprite sheet, and starts the rendering of a single frame to the screen.

- show  
  `show( time, modifierTable )`  
  | Parameter | Type | |
  | --------- | -------- | -------------------------------------------------- |
  | time | `number` | -- Amount of time the animation lasts. Amount of time per row if has many rows. |
  | modifierTable | `ModifierTable.AnimatedSprite \| nil` | -- Table with the customizable properties. Is optional. |

  Starts the displaying of the sprite. Shows sprite at screen center by default.  
  Will hide itself automatically after the animation is done.

- hide  
  `hide()`
  _inherited from SimpleSprite_

- wait  
  `wait( sec )`  
  _inherited from SimpleSprite_

- reset  
  `reset()`

  Resets the boolean flags, the animation timer, and the timer, allowing the sprite to be shown in the next `show` call.

---

<br/>

## Class: SimpleShape

_extends SimpleSprite_

Class containing functions for drawing shapes and lines.

<br/>

### Constructor

`new( shape )`

| Parameter | Type     |                                                                                         |
| --------- | -------- | --------------------------------------------------------------------------------------- |
| shape     | `string` | -- The name of the shape, only supports `"rect", "triangle", "line", "poly"` as of now. |

Initiates a new shape sprite.

<br/>

### Properties

- shape  
  `string`

  The type of shape passed into the constructor.

- \_isShowing  
  _inherited from SimpleSprite_

- \_timer  
  _inherited from SimpleSprite_

- \_shouldHide  
  _inherited from SimpleSprite_

- \_texture  
  _inherited from SimpleSprite_

- \_state  
  _inherited from SimpleSprite_

<br/>

### Methods

- toggleState  
  `toggleState()`  
  _inherited from SimpleSprite_

- getState  
  `getState()`  
  _inherited from SimpleSprite_

- \_renderRect  
  _private_  
  `_renderRect( modifierTable )`  
  | Parameter | Type | |
  | --------- | -------- | -------------------------------------------------- |
  | modifierTable | `ModifierTable.Rect` | -- Table with the customizable properties. |

  Starts the displaying of the rectangle.

- \_renderTriangle  
  _private_  
  `_renderTriangle( modifierTable )`  
  | Parameter | Type | |
  | --------- | -------- | -------------------------------------------------- |
  | modifierTable | `ModifierTable.Tri` | -- Table with the customizable properties. |

  Starts the displaying of the Triangle.

- \_renderLine  
  _private_  
  `_renderLine( modifierTable )`  
  | Parameter | Type | |
  | --------- | -------- | -------------------------------------------------- |
  | modifierTable | `ModifierTable.Line` | -- Table with the customizable properties. |

  Starts the displaying of the line.

- show  
  `show( time, modifierTable )`  
  | Parameter | Type | |
  | --------- | -------- | -------------------------------------------------- |
  | modifierTable | `ModifierTable.Rect \| ModifierTable.Tri \| ModifierTable.Line` | -- Table with the points' coordinates and other properties. Cannot be nil. |

  Starts the displaying of the selected shape.

- hide  
  `hide()`
  _inherited from SimpleSprite_

- wait  
  `wait( sec )`  
  _inherited from SimpleSprite_

- reset  
  `reset()`
  _inherited from SimpleSprite_
