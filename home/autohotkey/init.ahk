#SingleInstance

!6::
{
    Run "C:\Users\AndyBolton\scoop\apps\wezterm\current\wezterm-gui.exe",,, &Pid
    WinWaitActive "ahk_pid" Pid
    Send "wsl{enter}"
}

!7::
{
    Run "C:\Users\AndyBolton\scoop\apps\wezterm\current\wezterm-gui.exe",,, &Pid
    WinWaitActive "ahk_pid" Pid
}

