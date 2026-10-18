# Lit Bomb — 8 variants, two sizes

A thrown/placed bomb with a burning fuse. There are eight casing variants, each available at 16x16 and 32x32.

`iron` is the base drawing. The other seven variants are exact palette swaps of it, so the silhouette and pixel placement stay the same.

    sheet_16x16.gif     all eight, animated, side by side
    sheet_32x32.gif

    <variant>/
      16x16/  32x32/
        frame_1..4.png    the casing
        flame_1..4.png    the fuse flame
        glow.png          the pulse, as an animated PNG (APNG)
        glow_frames/      the same pulse as 14 plain PNGs
        showcase.gif      the three layers assembled

`glow.png` is an **APNG** with 14 frames, 30 ms per frame, looping. Browsers and itch will play it, but Aseprite, Photoshop, and most engines only read the first frame. The first frame is the pulse at full brightness, so it also works as a still. If you need the individual frames, use `glow_frames/`.

| | 16x16 | 32x32 |
|---|---|---|
| casing cell | 16x16 | 32x32 |
| flame cell | 6x8 | 16x16 |
| glow | 32x32 | 50x50 |

**`frame_3` is a copy of `frame_1`.** Frames 1 and 3 are the upright rest pose. Frames 2 and 4 lean left and right. The lean is already part of the drawing, so don't add another offset just to make the bomb lean.

## Showcase animation

The showcase uses three layers running on separate clocks. This lets the flame keep burning while the bomb itself stays still or moves through its fuse-burning sequence.

### Flame

Play `flame_1 -> 4` at **100 ms per frame**, looping continuously.

Anchor the bottom-centre of the flame to the fuse tip, with 1 px of overlap. The tip position changes with the bomb pose:

| pose | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 16x16 | (8,1) | (6,0) | (8,1) | (10,0) |
| 32x32 | (16,7) | (13,6) | (16,7) | (17,6) |

### Glow

Use additive blending (`screen`, `plus-lighter`, or `BLEND_MODE_ADD`) and centre the glow on the flame.

The pulse fades in for **48 ms** and fades out for **372 ms**, then loops. Both `glow.png` and `glow_frames/` start at peak brightness.

The glow pixels are white and the falloff is stored in the alpha, so tint it to whatever colour you need. The showcase uses `#ff0d0d`.

A single static frame also works if you don't want the glow animated.

### Casing

The casing animation follows the fuse burning down in a few stages. Given the length of your fuse, use roughly **50%** for `still`, **17%** for `judder`, and the rest for `swing`.

| beat | poses | offset px | notes |
|---|---|---|---|
| still | 1 | 0 | no movement; longest beat |
| judder | 2, 4, 2, 3 | -2, +2, -2, 0 | one loop |
| settle | 1 | 0 | back at rest for half a second |
| swing | 2, 3, 4, 3 + hold at rest | -2, 0, +2, 0 | twice, second pass is faster |
| | then 2, 3 | -2, 0 | half a bomb, then the fuse is out |

The offsets above are where the bomb should *appear*. Each drawing already has its own lean (`0, -1, 0, +1`), so subtract that lean when calculating the actual translation.

During a swing, the two extremes hold briefly and the movement through centre is quick, at roughly a 2:1 ratio.

The showcase uses these timings:

- **1.25 s** still
- **250 ms** for one judder loop
- **0.5 s** back at rest
- **520 ms** for a full swing plus the rest hold
- **380 ms** for the same swing, faster
- **100 ms** for the final half-bomb where the bomb would go off

That's **3.000 seconds total**, looping. It represents the full fuse length rather than a shortened preview. There is no explosion included.

All delays are multiples of 10 ms because GIF only supports that level of timing precision. If your engine supports finer timing, build the animation from the timings above rather than copying the GIF's timing.

## Transparency

**Every PNG in the pack has a transparent background.**

Only the showcase GIFs have a background. GIF only supports 1-bit transparency, so the individual PNGs are the better choice if you need proper alpha.

The showcases use a white background, so the glow is alpha-blended there instead of being additive. Additive blending over white doesn't show the glow properly. In an engine, use additive blending over a darker background for the intended effect.