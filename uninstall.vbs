Dim wShell, fso, localFolder, logonShell, regCell, desktop
Set wShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
localFolder = wShell.ExpandEnvironmentStrings("%localappdata%")
desktop = wShell.SpecialFolders("Desktop")
regCell = "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\shell"

'Figure out why this can sometimes get perm denied
'If (fso.FolderExists(localFolder & "\Easally")) Then
  'fso.DeleteFolder localFolder & "\Easally": MsgBox "Return code: " & CreateObject("WSCript.Shell").Run("cmd.exe /c rmdir /s /q """ & Path & """", 0, True)
'End If

If (fso.FileExists(localFolder & "\Easally\easally.vbs")) Then
  fso.DeleteFile(localFolder & "\Easally\easally.vbs")
End If

If (fso.FileExists(desktop & "\Return to Game Mode.lnk")) Then
  fso.DeleteFile(desktop & "\Return to Game Mode.lnk")
End If

logonShell = wShell.RegRead(regCell)

If NOT (logonShell="explorer.exe") Then
    wShell.RegWrite regCell, "explorer.exe", "REG_SZ"
End if

MsgBox "Successfully Removed"