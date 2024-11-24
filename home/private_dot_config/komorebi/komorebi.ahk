#Requires AutoHotkey v2.0.2
#SingleInstance Force

Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

; Send the ALT key whenever changing focus to force focus changes
Komorebic("alt-focus-hack enable")
; Default to cloaking windows when switching workspaces
Komorebic("window-hiding-behaviour cloak")
; Set cross-monitor move behaviour to insert instead of swap
Komorebic("cross-monitor-move-behaviour insert")
; Enable hot reloading of changes to this file
; WatchConfiguration("enable")

Komorebic("ensure-named-workspaces 0 I II III IIII Teams Discord Phone")
Komorebic("ensure-named-workspaces 1 I II III Komorebi")
Komorebic("ensure-named-workspaces 2 I II III")

; Assign layouts to workspaces, possible values: bsp, columns, rows, vertical-stack, horizontal-stack, ultrawide-vertical-stack
Komorebic("named-workspace-layout I bsp")

; Configure the invisible border dimensions
Komorebic("invisible-borders 7 0 14 7")

; Uncomment the next lines if you want a visual border around the active window
Komorebic("active-window-border-colour 180 249 248 single")
Komorebic("active-window-border-colour 256 165 66 stack")
Komorebic("active-window-border-colour 255 51 153 monocle")

Komorebic("active-window-border-width 4")
Komorebic("active-window-border enable")

Komorebic("named-workspace-rule exe ms-teams.exe Teams")
Komorebic("named-workspace-rule exe Discord.exe Discord")
Komorebic("named-workspace-rule exe PhoneExperienceHost.exe Phone")

Komorebic("named-workspace-rule title komorebic.exe Komorebi")
Komorebic("named-workspace-rule title komorebi-visualizer.exe Komorebi")


Komorebic("complete-configuration")

; Focus windows
+^h::Komorebic("focus left")
+^j::Komorebic("focus down")
+^k::Komorebic("focus up")
+^l::Komorebic("focus right")
!+[::Komorebic("cycle-focus previous")
!+]::Komorebic("cycle-focus next")

; Move windows
!^+h::Komorebic("move left")
!^+j::Komorebic("move down")
!^+k::Komorebic("move up")
!^+l::Komorebic("move right")
!+Enter::Komorebic("promote")

; Stack windows
!^Left::Komorebic("stack left")
!^Right::Komorebic("stack right")
!^Up::Komorebic("stack up")
!^Down::Komorebic("stack down")
!;::Komorebic("unstack")
![::Komorebic("cycle-stack previous")
!]::Komorebic("cycle-stack next")

; Resize
!=::Komorebic("resize-axis horizontal increase")
!-::Komorebic("resize-axis horizontal decrease")
!+=::Komorebic("resize-axis vertical increase")
!+-::Komorebic("resize-axis vertical decrease")

; Manipulate windows
!f::Komorebic("toggle-float")
!+f::Komorebic("toggle-monocle")
!m::Komorebic("toggle-maximize")
+^m::Komorebic("minimize")
!+m::Komorebic("manage")

; Window manager options
!+r::Komorebic("retile")
!p::Komorebic("toggle-pause")

; Layouts
!x::Komorebic("flip-layout horizontal")
!y::Komorebic("flip-layout vertical")

; Workspaces
!+1::Komorebic("focus-monitor 0")
!+2::Komorebic("focus-monitor 1")
!+3::Komorebic("focus-monitor 2")

!1::Komorebic("focus-workspace 0")
!2::Komorebic("focus-workspace 1")
!3::Komorebic("focus-workspace 2")
!4::Komorebic("focus-workspace 3")

!^+d::Komorebic("focus-named-workspace Discord")
!^+t::Komorebic("focus-named-workspace Teams")
!^+p::Komorebic("focus-named-workspace Phone")
!^+v::Komorebic("focus-named-workspace Komorebi")

; Move windows across workspaces
!^+1::Komorebic("move-to-workspace 0")
!^+2::Komorebic("move-to-workspace 1")
!^+3::Komorebic("move-to-workspace 2")
!^+4::Komorebic("move-to-workspace 3")

; !r::ReloadConfiguration()
!q::Komorebic("close")

; FocusMonitor(2)
; FocusWorkspace(0)
; Retile()

