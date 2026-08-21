#Requires AutoHotkey v2.0
#SingleInstance Force

CoordMode "Pixel", "Client"
CoordMode "Mouse", "Client"

GameWindow := "ahk_exe FortniteClient-Win64-Shipping.exe"

; ==============================================================================
; SETTINGS - MOVEMENT
; ==============================================================================
JumpChance    := 30    
ClickChance   := 15    
MinMoveTime   := 300   
MaxMoveTime   := 1800  

; ==============================================================================
; SETTINGS - LOBBY DETECTION
; ==============================================================================
TargetColor := 0xF7FF1A  ; Bright Yellow
SearchWidthRatio := 0.35
SearchTopRatio   := 0.60

; ==============================================================================
; LOGIC
; ==============================================================================
toggle := false
isInLobby := false

MoveSets := [
    ["w"], ["a"], ["s"], ["d"],
    ["w", "a"], ["w", "d"],
    ["s", "a"], ["s", "d"]
]

; Toggle ON/OFF (F1)
F1:: {
    global toggle := !toggle
    
    if toggle {
        SoundBeep 1000, 200
        ToolTip "Auto-Move + Rejoin: ON"
        SetTimer GameLoop, 10
        SetTimer CheckLobby, 2000
        SetTimer RemoveToolTip, -2000
    } else {
        SoundBeep 500, 200
        ToolTip "Auto-Move: OFF"
        SetTimer GameLoop, 0
        SetTimer CheckLobby, 0
        ReleaseKeys()
        SetTimer RemoveToolTip, -2000
    }
}

F2:: {
    ReleaseKeys()
    ExitApp
}

; ------------------------------------------------------------------------------
; LOBBY CHECKER
; ------------------------------------------------------------------------------
CheckLobby() {
    global isInLobby

    fortniteHwnd := WinActive(GameWindow)
    if !fortniteHwnd
        return

    WinGetClientPos(, , &clientWidth, &clientHeight, fortniteHwnd)
    if clientWidth <= 0 or clientHeight <= 0
        return

    if !FindPlayPixel(&foundX, &foundY, clientWidth, clientHeight) {
        isInLobby := false
        return
    }

    if isInLobby
        return

    isInLobby := true
    ReleaseKeys()
    ToolTip "Lobby Detected: Clicking Play..."

    ; Reject a transient match before moving the cursor.
    Sleep 100
    if WinActive(GameWindow) != fortniteHwnd
        return ResetLobbyState()
    if PixelGetColor(foundX, foundY) != TargetColor
        return ResetLobbyState()

    ; A matching pixel is already inside the button's clickable area.
    MouseGetPos &originalMouseX, &originalMouseY
    MouseMove foundX, foundY
    Sleep 300

    if WinActive(GameWindow) != fortniteHwnd
        return ResetLobbyState()

    SendEvent "{LButton down}"
    Sleep 150
    SendEvent "{LButton up}"
    MouseMove originalMouseX, originalMouseY

    ; Retry on the next timer tick if Play remains visible.
    Sleep 4000
    if WinActive(GameWindow) != fortniteHwnd
        return ResetLobbyState()
    if FindPlayPixel(&retryX, &retryY, clientWidth, clientHeight) {
        isInLobby := false
        ToolTip "Play Still Detected: Retrying..."
    }
    SetTimer RemoveToolTip, -1000
}

FindPlayPixel(&foundX, &foundY, clientWidth, clientHeight) {
    searchRight := Round((clientWidth - 1) * SearchWidthRatio)
    searchTop := Round((clientHeight - 1) * SearchTopRatio)

    ; Search the lower-left region from bottom to top.
    return PixelSearch(
        &foundX,
        &foundY,
        0,
        clientHeight - 1,
        searchRight,
        searchTop,
        TargetColor
    )
}

ResetLobbyState() {
    global isInLobby := false
    ReleaseKeys()
    SetTimer RemoveToolTip, -1000
}

; ------------------------------------------------------------------------------
; MOVEMENT LOOP
; ------------------------------------------------------------------------------
GameLoop() {
    global isInLobby
    if !toggle or isInLobby
        return

    fortniteHwnd := WinActive(GameWindow)
    if !fortniteHwnd
        return

    currentKeys := MoveSets[Random(1, MoveSets.Length)]
    
    for key in currentKeys {
        Send "{" key " down}"
    }

    duration := Random(MinMoveTime, MaxMoveTime)
    
    if (Random(1, 100) <= JumpChance) {
        Sleep Random(50, 300)
        if !KeepFortniteFocus(fortniteHwnd)
            return

        Send "{Space down}"
        Sleep Random(50, 150)
        if !KeepFortniteFocus(fortniteHwnd)
            return

        Send "{Space up}"
        duration := Max(0, duration - 450) 
    }

    if (Random(1, 100) <= ClickChance) {
        Sleep Random(50, 300)
        if !KeepFortniteFocus(fortniteHwnd)
            return

        Click "down"
        Sleep Random(50, 150)
        if !KeepFortniteFocus(fortniteHwnd)
            return

        Click "up"
    }

    EndTime := A_TickCount + duration
    while (A_TickCount < EndTime) {
        if isInLobby {
            ReleaseKeys()
            return
        }
        if !KeepFortniteFocus(fortniteHwnd)
            return

        Sleep 50
    }

    for key in currentKeys {
        Send "{" key " up}"
    }
    
    Sleep Random(100, 500)
}

KeepFortniteFocus(fortniteHwnd) {
    if WinActive(GameWindow) == fortniteHwnd
        return true

    ReleaseKeys()
    return false
}

ReleaseKeys() {
    Send "{w up}{a up}{s up}{d up}{Space up}"
    Click "up"
}

RemoveToolTip() {
    ToolTip
}
