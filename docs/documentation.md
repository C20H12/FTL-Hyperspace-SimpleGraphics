# SimpleGraphics Documentation

## Index

- [Simple Sprite](#sprite)
- Simple Animated Sprite
- Simple Shape

---

<span id="sprite"></span>

## Class: SimpleSprite

Class containing functions for displaying sprite images. Also the base class for the other classes.

<br/>

### Constructor

`SimpleSprite:new( imgName )`

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
  | modifierTable | `ModifierTable.Sprite` | --Table with the customizable properties. Cannot be nil. |

  Starts the displaying of the sprite. Shows sprite at screen center by default.

- hide  
  `hide()`

  Stops the displaying of the sprite, if the wait time is fulfilled.

- wait  
  `wait( sec )`  
  | Parameter | Type |                                 |
  | --- | -------- | --------------------------------- |
  | sec | `number` | -- Number of seconds to wait for. |

  Switches `_shouldHide` after the timer expires, allowing `hide` calls to hide the sprite.

- reset  
  `reset()`  

  Resets the boolean flags and the timer, allowing the sprite to be showne in the next `show` call.

- colorFactory  
  *static*  
  `colorFactory( hexString )`   
  | Parameter | Type     |                                              |
  | --------- | -------- | -------------------------------------------- |
  | hexString   | `String` | -- A 8 digit hexadecimal value (rrggbbaa). |

  Processes the input and returns a color for use in shapes or filters on sprite images.

  **Returns** `GL_Color`

- colorFactory  
  *overload*  
  *static*  
  `colorFactory( rr, gg, bb, aa )`   
  | Parameter | Type     |                                              |
  | --------- | -------- | -------------------------------------------- |
  | rr   | `number` | -- A number stating the amout of red (0 - 255). |
  | gg   | `number` | -- A number stating the amout of green (0 - 255). |
  | bb   | `number` | -- A number stating the amout of blue (0 - 255). |
  | aa   | `number` | -- A number stating the amout of alpha (0 - 1). |

  Processes the input and returns a color for use in shapes or filters on sprite images.

  **Returns** `GL_Color`

- randint  
  *static*
  `randint( min, max )`  
  | Parameter | Type     |                                              |
  | --------- | -------- | -------------------------------------------- |
  | min   | `number` | -- The minimum value of the range. |
  | max | `number` | -- The maximum value of the range. |

  Generates a random number for use in random coordinates for sprites.

  **Returns** `number` -- Integer withing the set range. Max not included.
