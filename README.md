Atlas Generator
===============

The Atlas Generator is a [Godot][godot] plugin which takes [Texture][texture]
as input and outputs [AtlasTexture][atex]s according to the sizes given by the user.

For example; If the user inputs an image with sizes 128x128 and inputs 64x64 as Width and Height to the plugin
it would generate 4 [.atex][atex] files from each corner of the image.

Changelog
---------

- **Version 1.3 Planned features:**
  - A Grid, where you can select which sprites should be exported and which not
    - Select/Deselect all button
    - Selected sprites should be highlighted
  - Remove "Atlas Generator" -button when plugin is disabled.. Somehow
- **Version 1.2 Updates:**
  - Edited 'Width' and 'Height' SpinBoxes
    - Not editable if origin texture not selected
    - Max values from origin texture
  - Error Message now now shown in interface
  - Origin Texture field now also checks for file type
    - Both 'browse' buttons now correctly show supported file types
  - Misc. bug fixes
  - Known bugs:
    - PNG Images don't export for some reason
- **Version 1.1 Updates:**
  - Destination format can be selected


[godot]: http://godotengine.org/
[texture]: http://docs.godotengine.org/en/latest/classes/class_texture.html#class-texture
[atex]: http://docs.godotengine.org/en/latest/classes/class_atlastexture.html
