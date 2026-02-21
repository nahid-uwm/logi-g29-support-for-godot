# Godot Asset Library Submission Details

Everything is now formatted properly. To submit to the Godot Asset Library, go to the **Submit Assets** page and use the following information.

> **Note**: Before submitting, ensure you have committed all changes to your GitHub repository and pushed them! 

### Submission Form

**Asset Name:** `Logitech G29 Hardware Addon`
**Category:** `Addons / Scripts`
**Godot version:** `4.6`
**Version:** `1.0.0`
**Repository host:** `GitHub` (or whatever provider you use)
**Repository URL:** *Your repository link (e.g., https://github.com/YourUsername/logitech-g-29-addon)*
**Issues URL:** *Your issues link (leave blank if same as repository)*

**Download Commit:** 
*You can find this on your GitHub repository page. It is the full 40-character SHA hash of your latest commit. Example: `b1d3172f89b86e52465a74f63a74ac84c491d3e1`.*

**Icon URL:** 
*(A 1:1 image, at least 128x128). If you upload an icon (like `icon.png`) to the root of your Github repo, link it like this:*
`https://raw.githubusercontent.com/YourUsername/logitech-g-29-addon/main/icon.png` 
*(Note the "raw.githubusercontent.com" domain!)*

**License:** `MIT`

**Description:**
```text
A dedicated input handler suite to directly integrate the Logitech G29 Racing Wheel, Pedals, and Driving Force Shifter using Godot's built-in Joypad engine. 

Features:
- Steering Angle Normalization: Converts raw X-axis input into accurate steering degrees (default 900-degree rotation range).
- Custom Named Signals: Emits standard named signals for every face button, D-pad, and dial on the G29 (e.g., cross_pressed, dial_right_pressed).
- Shifter Priority: Intelligently handles scenarios where gear shifter button IDs overlap with the D-pad entries.
- Pedal Normalization: Signals the precise travel distance of the Throttle, Brake, and Clutch on a uniform 0.0 to 1.0 scale, with toggleable inversion.
- Manual Mapping Utility: Built-in function to dynamically bind pedals by listening to the physical axis activated by the user.
- H-Pattern Standard Shifter: Emits distinct pressed and released signals for Gears 1 through 6, and Reverse.

Built primarily for Godot 4.6 (Jolt Physics & GL Compatibility). Includes fallback device polling logic to target specific hardware setups seamlessly.
```
