#Warn
; REMOVED: #NoEnv
#SingleInstance Force
; REMOVED: SetBatchLines -1

title := "No Man's Sky"

While(true) {
    if (WinExist(title)) {
        if (!WinActive(title)) {
            Sleep(50) ;Small delay while tabbing
            PostMessage(0x06, 1, 0, , title)
        }
    }
    Sleep(500)
}
return