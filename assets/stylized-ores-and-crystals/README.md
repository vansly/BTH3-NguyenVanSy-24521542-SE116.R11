# Rockbound Ores & Crystals

Five chunky low-poly mining props for RPG, survival and crafting games. Faceted silhouettes, flat shading and one shared nine-colour palette so every node reads clearly from a top-down or third-person camera.

3 low-poly props, flat shaded, one 512x512 texture each, all sharing one palette (dark stone #3b3f47, slate #5d6470, light stone #8f96a0, coal black #22252b, rust ore #b5602f, gold #e8b931, amethyst #8a4fc9, amethyst highlight #c7a2f0, aquamarine #3fc4c9).
Real-world scale: 1 unit = 1 metre, pivot at the centre of the base.

| Asset | Triangles | Height | Texture |
|---|---|---|---|
| Iron Ore Node | 950 | 0.9 m | 512px |
| Amethyst Cluster | 1140 | 0.7 m | 512px |
| Coal Pile | 736 | 0.4 m | 512px |

## Formats
- `Models/GLB`: glTF binary with the texture embedded (Godot, Unreal, Blender, three.js)
- `Models/FBX`: FBX with the texture embedded (Unity, Unreal)
- `Models/OBJ`: OBJ + MTL + PNG
- `Textures`: the PNG textures on their own

## Engines
- **Godot 4**: copy this folder into your project as `res://stylized-ores-and-crystals/` and open `Godot/demo_scene.tscn`.
- **Unity**: copy this folder into `Assets/`, then use the menu **Tools > Rockbound Ores & Crystals > Build Demo Scene**.
- **Unreal**: import the FBX or GLB files.

Not included: rigging, animation, LODs, collision meshes.

## How this pack was made
AI tools were used. See `AI_DISCLOSURE.md` for exactly which steps, and `PROCESS_LOG.md` for every prompt and cleanup step.
