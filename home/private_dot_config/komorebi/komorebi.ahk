#SingleInstance Force

; Load library
#Include komorebic.lib.ahk
; Load coKomorebinfiguration
#Include komorebi.generated.ahk

; Send the ALT key whenever changing focus to force focus changes
AltFocusHack("enable")
; Default to cloaking windows when switching workspaces
WindowHidingBehaviour("cloak")
; Set cross-monitor move behaviour to insert instead of swap
CrossMonitorMoveBehaviour("Insert")
; Enable hot reloading of changes to this file
; WatchConfiguration("enable")

EnsureNamedWorkspaces(0, "I Teams Discord Phone")
EnsureNamedWorkspaces(1, "I II III Komorebi")
EnsureNamedWorkspaces(2, "I II III")

; Assign layouts to workspaces, possible values: bsp, columns, rows, vertical-stack, horizontal-stack, ultrawide-vertical-stack
; NamedWorkspaceLayout("I", "bsp")

; Configure the invisible border dimensions
InvisibleBorders(7, 0, 14, 7)

; Uncomment the next lines if you want a visual border around the active window
ActiveWindowBorderColour(180, 249, 248, "single")
ActiveWindowBorderColour(256, 165, 66, "stack")
ActiveWindowBorderColour(255, 51, 153, "monocle")

ActiveWindowBorderWidth(4)
ActiveWindowBorder("enable")

CrossMonitorMoveBehaviour("insert")

NamedWorkspaceRule("exe", "ms-teams.exe", "Teams")
NamedWorkspaceRule("exe", "Discord.exe", "Discord")
NamedWorkspaceRule("exe", "PhoneExperienceHost.exe", "Phone")

NamedWorkspaceRule("title", "komorebic.exe", "Komorebi")
NamedWorkspaceRule("title", "komorebi-visualizer.exe", "Komorebi")

CompleteConfiguration()

; Focus windows
+^h::Focus("left")
+^j::Focus("down")
+^k::Focus("up")
+^l::Focus("right")
!+[::CycleFocus("previous")
!+]::CycleFocus("next")

; Move windows
!^+h::Move("left")
!^+j::Move("down")
!^+k::Move("up")
!^+l::Move("right")
!+Enter::Promote()

; Stack windows
!^Left::Stack("left")
!^Right::Stack("right")
!^Up::Stack("up")
!^Down::Stack("down")
!;::Unstack()
![::CycleStack("previous")
!]::CycleStack("next")

; Resize
!=::ResizeAxis("horizontal", "increase")
!-::ResizeAxis("horizontal", "decrease")
!+=::ResizeAxis("vertical", "increase")
!+-::ResizeAxis("vertical", "decrease")
  
; Manipulate windows
!f::ToggleFloat()
!+f::ToggleMonocle()
!m::ToggleMaximize()
!+m::Manage()
+^m::Minimize()

; Window manager options
!+r::Retile()
!p::TogglePause()

; Layouts
!x::FlipLayout("horizontal")
!y::FlipLayout("vertical")

; Workspaces
!+1::FocusMonitor(0)
!+2::FocusMonitor(1)
!+3::FocusMonitor(2)

!1::FocusWorkspace(0)
!2::FocusWorkspace(1)
!3::FocusWorkspace(2)
!4::FocusWorkspace(3)

!^+d::FocusNamedWorkspace("Discord")
!^+t::FocusNamedWorkspace("Teams")
!^+p::FocusNamedWorkspace("Phone")
!^+v::FocusNamedWorkspace("Komorebi")

; Move windows across workspaces
; !+1::MoveToWorkspace(0)
; !+2::MoveToWorkspace(1)
; !+3::MoveToWorkspace(2)

; !r::ReloadConfiguration()
!q::Close()

FocusMonitor(2)
FocusWorkspace(0)
Retile()

