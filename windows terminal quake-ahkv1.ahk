#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1
Process, Priority,, High

Opacity := 255  ; [0, 255] or off
Height := 0.6  ; [0., 1.]

; Toggle windows terminal using Alt+1
F1::ToggleTerminal()

ShowAndPositionTerminal(WinTitle)
{
  global Height

  WinShow, %WinTitle%
  WinActivate, %WinTitle%

  WinGetPos, CurX, CurY, CurWidth, CurHeight, %WinTitle%
  if (CurHeight != A_ScreenHeight)
  {
    WinMove, %WinTitle%,, -7, 0, A_ScreenWidth + 18, A_ScreenHeight * Height
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
    Run "wt"
    WinWait, %WinClassTitle%,, 5
    if ErrorLevel
    {
      MsgBox, Timeout waiting for wt!!
      Return
    }
    Hwnd := WinExist(WinClassTitle)
  }

  WinIdTitle := "ahk_id " Hwnd
  Winset, AlwaysOnTop, On, %WinIdTitle%
  WinSet, Transparent, %Opacity%, %WinIdTitle%
  WinHide, %WinIdTitle%
  Return WinIdTitle
}

ToggleTerminal()
{
  static WinIdTitle := ""
  DetectHiddenWindows, On
  if !WinExist(WinIdTitle)
  {
    ; Iinitialization
    WinIdTitle := InitTerminal()
  }

  DetectHiddenWindows, Off

  if WinExist(WinIdTitle)
  {
    ; The window is not hidden, so hide the window
    ; MsgBox, Hide the window
    WinHide, %WinIdTitle%
    WinGetActiveTitle, ActiveTitle
    if !ActiveTitle
    {
        ; Activate last focused window
        ; Use {Blind} to avoid releasing Alt if user already pressed down Alt
        Send {Blind}!{Esc}
    }
  }
  else
  {
    ; The window is hidden, so show the window
    ShowAndPositionTerminal(WinIdTitle)
  }
}