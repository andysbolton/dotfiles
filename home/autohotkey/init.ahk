#SingleInstance

global Pid := 0

!6::
{
    target := "ahk_pid" Pid
    if not WinExist(target)
        Init()
    else
        if WinActive(target)
            WinMinimize
        else
            WinActivate(target)
            ResizeWindow() 
}

!7::
{
    Run "wezterm-gui",,, &Pid
    WaitForWin(Pid)
}

Init() {
    Run "wezterm-gui",,, &Pid
    WaitForWin(Pid)

    global Pid := Pid
    Send "clear{enter}"

    ResizeWindow()
    WinRestore
}

WaitForWin(Pid) {
    WinWait "ahk_pid" Pid
    WinActivate
}

ResizeWindow() {
    targetWidth := A_ScreenWidth - 200
    targetHeight := A_ScreenHeight - 200

    x := A_ScreenWidth/2 - targetWidth/2
    y := A_ScreenHeight/2 - targetHeight/2

    WinMove x, y, targetWidth, targetHeight
}

