# SGUnityTools
Uses Radfordhound's HedgeLib for importing lights, materials

## Tools
Lightmap UV generator (in case if you have in-editor combined objects with no external mesh files)

Object Batching tool in context menu (it just uses StaticBatchingUtility and parents all objects to active one)
Object Instancing tool. Can be applied to a parent of game objects. After which it sorts all objects and instances them by applying same mesh to all similar surfaces. It uses these parameters: name of the object (it's numeration), vertex count and pivot point. So, if you have different objects under one naming condition, it will correctly instance them by alphabetic order. Though if something interrupts it, it starts new instancing order with another individual mesh. Can be undo.

Screenshot tool - it just makes a screenshot for previewing a game in a higher resolution

SG light importer - a script to import .light files from Sonic Generations. No support for light-lists, but working fine with both directional and point-lights (no support for 
spot lights, soon will be implemented?)

SG material importer - a script to import most standard materials from Sonic Generations to existing ASE shaders. You can change it to match your shaders, but it's messy. Shaders will be uploaded too. It does support cutoff and standard materials. In case if there's unknown shader, it's gonna make an asset with text document in it, which shows shader name and textures being used in it. The reason I ain't able to make this tool better is because I don't understand how exactly some shaders should perform and what are they. But, again, most surface materials and foliage materials are importing just fine.

UV Swapper - in case if you've imported lightmap uv set in UV2 instead of UV1. This mostly happen with SonicGLVL generated models.

## How to use
Firstly, add HedgeLib.dll to your project (more in Unity Docs). To install scripts, add them into any "Editor" folder in your Assets/ folder. Keep in mind it has namespaces inside every class, but you can delete it.

Lightmap UV generator, Object Batching tool and UV Swapper is available in context menu for any game object selection.

SG importers are being used when importing files just like anything else into your project. Keep in mind that after importing files, you cannot edit them (which is how Unity works). However, you can unpack prefabs in your scene, but that works only for gameobjects.
