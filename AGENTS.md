# Repository Guidelines

## Project structure

This repository contains one AutoHotkey v2 script:

- `legoafk.ahk` keeps a Fortnite LEGO player active for XP, detects lobby returns, clicks Play, and resumes movement after reloading.
- There are no separate assets, dependencies, build files, or automated tests.

Keep user-tunable values near the top of `legoafk.ahk`. Put reusable behavior in named functions such as `CheckLobby()` or `ReleaseKeys()` rather than adding more work directly to a hotkey block. If the project grows, place test scripts under `tests/` and documentation or screenshots under `docs/`.

## Running and development commands

Install AutoHotkey v2 before running these commands. AutoHotkey is not bundled with the repository.

```powershell
AutoHotkey.exe .\legoafk.ahk
```

Runs the script locally. Press `F1` to toggle automation and `Esc` to release held inputs and exit.

```powershell
Ahk2Exe.exe /in .\legoafk.ahk /out .\legoafk.exe
```

Optionally compiles a standalone executable when the AutoHotkey compiler is installed. No build step is required for normal development.

## Coding style and naming

Target AutoHotkey v2 and retain `#Requires AutoHotkey v2.0`. Use four spaces for indentation, one statement per line, and braces for hotkey and function bodies. Follow the existing naming patterns: `PascalCase` for functions and shared settings, and `camelCase` for mutable state and local variables. Declare globals explicitly inside functions that modify them. Group configuration and logic with short `;` comments. Avoid unexplained screen coordinates, colors, or timing values.

## Testing changes

There is no automated test framework or coverage target. Test changes at 4:3, 16:10, 16:9, and 21:9:

1. Start the script and confirm `F1` enables and disables timers.
2. Verify movement keys, Space, and the mouse button are released when disabling or pressing `Esc`.
3. At each aspect ratio, return to the Fortnite lobby and confirm movement pauses, Play is clicked, and the AFK loop resumes after the LEGO game reloads.

Keep the AutoHotkey debugger or `/ErrorStdOut` output clear of syntax and runtime errors.

## Commits and pull requests

This checkout has no Git history to establish a local convention. Use short, imperative commit subjects, for example `Fix lobby click offset`. Keep each commit focused. Pull requests should describe changes, list the tested resolution and AutoHotkey version, and call out modified coordinates, colors, or delays. Include a screenshot for pixel-detection or UI changes.

## Safety notes

The script generates keyboard and mouse input. Test with Fortnite focused, keep `Esc` available, and call `ReleaseKeys()` on every new exit or interruption path.
