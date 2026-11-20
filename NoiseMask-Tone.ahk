#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

AudioFile := A_ScriptDir "\tone.wav"
SoundBuf  := FileRead(AudioFile, "RAW") ; Loads WAV straight into RAM for zero-gap looping
isPlaying := false

UpdateStatus()

OnMessage(0x404, TrayClick)

TrayClick(wParam, lParam, msg, hwnd) {
    global isPlaying, SoundBuf
    if (lParam = 0x201 || lParam = 0x203) {
        if (isPlaying) {
            DllCall("winmm\PlaySoundW", "Ptr", 0, "Ptr", 0, "UInt", 0x40)
            isPlaying := false
        } else {
            DllCall("winmm\PlaySoundW", "Ptr", SoundBuf.Ptr, "Ptr", 0, "UInt", 0xD)
            isPlaying := true
        }
        UpdateStatus()
    }
}

UpdateStatus() {
    global isPlaying
    iconFile := isPlaying ? A_ScriptDir "\tone-play.png" : A_ScriptDir "\tone-pause.png"
    if FileExist(iconFile)
        TraySetIcon(iconFile)
    else
        TraySetIcon("ddores.dll", isPlaying ? 28 : 21)
    
    A_IconTip := isPlaying ? "Tone: Playing" : "Tone: Paused"
}
