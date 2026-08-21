# Fortnite LEGO AFK

`legoafk.ahk` is an AutoHotkey v2 script that sends randomized movement, jumps, and mouse clicks to Fortnite's LEGO game mode. When Fortnite returns to the lobby, the script finds the yellow **Play** button, clicks it, and resumes movement after the game reloads.

The script sends input only while `FortniteClient-Win64-Shipping.exe` is active. It does not control Fortnite in the background.

> [!WARNING]
> This script automates Fortnite input. Epic's Gameplay Integrity terms prohibit bot software or services that automate Licensed Products. The script may put your Epic account at risk. Read the [Epic Games Terms of Service](https://legal.epicgames.com/epicgames/tos) before you run it.

## Requirements

- Windows
- [AutoHotkey v2](https://www.autohotkey.com/)
- Fortnite with the process name `FortniteClient-Win64-Shipping.exe`

The script requires no packages or build step.

## Run the script

1. Start Fortnite.
2. Enter the LEGO game mode that you want to use.
3. Open PowerShell in this repository.
4. Start the script:

```powershell
Start-Process .\legoafk.ahk
```

5. Return focus to Fortnite.
6. Press `F1` to enable automation.

A 1000 Hz beep and an `Auto-Move + Rejoin: ON` tooltip confirm that automation is active.

- Press `F1` again to disable automation and release held inputs.
- Press `F2` to release held inputs and exit the script.

Keep Fortnite focused while the script runs. The movement loop pauses when another window becomes active.

## Adjust behavior

Edit the settings near the top of `legoafk.ahk` before you start the script:

- Set `JumpChance` and `ClickChance` from `0` through `100` to control the chance of each action.
- Set `MinMoveTime` and `MaxMoveTime` in milliseconds to control how long each movement lasts.
- Change `TargetColor` only when Fortnite changes the exact yellow used by the **Play** button.
- Increase `SearchWidthRatio` to search farther right. The default `0.35` searches the left 35 percent of the client.
- Decrease `SearchTopRatio` to expand the search upward. The default `0.60` searches from 60 percent of the client height to the bottom.

The lobby search starts at the bottom-left and moves upward. This order avoids yellow notification badges near the top of the Fortnite lobby.

## Troubleshoot the script

### The hotkeys do nothing

Confirm that AutoHotkey v2 is installed. Check for the AutoHotkey tray icon. Start `legoafk.ahk` again if no icon appears.

### Movement stops when you switch applications

Return focus to Fortnite. The focus guard prevents the script from sending movement or clicks to another application.

### The script does not click Play

Confirm that the button contains the exact `TargetColor`. Use AutoHotkey Window Spy to inspect the rendered RGB value. Adjust `SearchWidthRatio` or `SearchTopRatio` if the button falls outside the lower-left search region.

### An input remains held

Press `F1` to disable automation. Press `F2` to call `ReleaseKeys()` and exit.

## Contribute

Read [AGENTS.md](AGENTS.md) for repository structure, coding conventions, manual test cases, and pull request guidance. Test lobby detection at 4:3, 16:10, 16:9, and 21:9 before you submit a change.
