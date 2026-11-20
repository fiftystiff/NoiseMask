Set WshShell = CreateObject("WScript.Shell")
strPath = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)

' Launch the first icon
WshShell.Run """" & strPath & "\NoiseMask-Crackle.exe""", 0, False

' Wait 1.5 seconds so Windows registers its tray slot first
WScript.Sleep 1500

' Launch the second icon right next to it
WshShell.Run """" & strPath & "\NoiseMask-Tone.exe""", 0, False
