#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

AudioFile := A_ScriptDir "\crackle.wav"
SoundBuf  := FileRead(AudioFile, "RAW") ; Loads WAV straight into RAM for zero-gap looping
isPlaying := false

UpdateStatus()

OnMessage(0x404, TrayClick)

TrayClick(wParam, lParam, msg, hwnd) {
    global isPlaying, SoundBuf
    if (lParam = 0x201 || lParam = 0x203) {
        if (isPlaying) {
            ; Stop playback immediately (SND_PURGE = 0x40)
            DllCall("winmm\PlaySoundW", "Ptr", 0, "Ptr", 0, "UInt", 0x40)
            isPlaying := false
        } else {
            ; Play from RAM asynchronously in an infinite gapless loop:
            ; SND_ASYNC (0x1) | SND_LOOP (0x8) | SND_MEMORY (0x4) = 0xD
            DllCall("winmm\PlaySoundW", "Ptr", SoundBuf.Ptr, "Ptr", 0, "UInt", 0xD)
            isPlaying := true
        }
        UpdateStatus()
    }
}

UpdateStatus() {
    global isPlaying
    iconFile := isPlaying ? A_ScriptDir "\crackle-play.png" : A_ScriptDir "\crackle-pause.png"
    if FileExist(iconFile)
        TraySetIcon(iconFile)
    else
        TraySetIcon("ddores.dll", isPlaying ? 16 : 15)
    
    A_IconTip := isPlaying ? "Crackle: Playing" : "Crackle: Paused"
}
