; REMOVED: #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
; REMOVED: SetBatchLines, -1
ErrorLevel := ProcessSetPriority("High")

DetectHiddenWindows(true)

Opacity := 200  ; [0, 255] or off
Height := 0.4  ; [0., 1.]

; Toggle windows terminal using Alt+1
!1::ToggleTerminal()

ShowAndPositionTerminal(WinTitle)
{
  global Height

  WinShow(WinTitle)
  WinActivate(WinTitle)

  WinGetPos(&CurX, &CurY, &CurWidth, &CurHeight, WinTitle)
  if (CurHeight != A_ScreenHeight)
  {
    WinMove(-9, -14, A_ScreenWidth + 18, A_ScreenHeight * Height, WinTitle)
  }
}

InitTerminal()
{
  global Opacity

  ; MsgBox, Iinitialize Windows Terminal
  WinClassTitle := "ahk_class CASCADIA_HOSTING_WINDOW_CLASS"
  Hwnd := WinExist(WinClassTitle)
  if !Hwnd
  {
    ; Run new Windows Terminal
    Run("`"wt`"")
    ErrorLevel := !WinWait(WinClassTitle, , 5)
    if ErrorLevel
    {
      MsgBox("Timeout waiting for wt!!")
      Return
    }
    Hwnd := WinExist(WinClassTitle)
  }

  WinIdTitle := "ahk_id " Hwnd
  WinSetAlwaysOnTop(1, WinIdTitle)
  WinSetTransparent(Opacity, WinIdTitle)
  WinHide(WinIdTitle)
  Return WinIdTitle
}

ToggleTerminal()
{
  static WinIdTitle := ""
  DetectHiddenWindows(true)
  if !WinExist(WinIdTitle)
  {
    ; Iinitialization
    WinIdTitle := InitTerminal()
  }

  DetectHiddenWindows(false)

  if WinExist(WinIdTitle)
  {
    ; The window is not hidden, so hide the window
    ; MsgBox, Hide the window
    WinHide(WinIdTitle)
    ActiveTitle := WinGetTitle("A")
    if !ActiveTitle
    {
        ; Activate last focused window
        ; Use {Blind} to avoid releasing Alt if user already pressed down Alt
        Send("{Blind}!{Esc}")
    }
  }
  else
  {
    ; The window is hidden, so show the window
    ShowAndPositionTerminal(WinIdTitle)
  }
}