Dim gameLauncher, localFolder, regCell, localAppPath, localImgPath, scriptPath, imgPath, desktop, easallyFolder, command, tPath
Set wShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
desktop = wShell.SpecialFolders("Desktop")
localFolder = wShell.ExpandEnvironmentStrings("%localappdata%")
easallyFolder = localFolder & "/Easally"
curDir = wShell.CurrentDirectory
localAppPath = curDir & "/src/easally.vbs"
localImgPath = curDir & "/assets/icon.ico"
regCell = "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\shell"
gInput = InputBox("Enter the path to your game launcher (WITHOUT QUOTES):" + vbNewLine + vbNewLine + "Default Locations:" + vbNewLine + vbNewLine + "Steam: " + "C:\Program Files (x86)\Steam\steam.exe" + vbNewLine + vbNewLine + "Playnite: " + localFolder + vbNewLine + "\Playnite\Playnite.FullscreenApp.exe", "Easally")
gameLauncher = replace(gameLauncher, Chr(34), "")
'TODO make custom dialog box with IE
If NOT IsEmpty(gameLauncher) Then
    'TODO add error handling
    If fso.FileExists(gameLauncher) Then
        If NOT (fso.FolderExists(localFolder & "\Easally")) Then
            fso.CreateFolder(localFolder & "\Easally")
        End If
        scriptPath = easallyFolder & "\easally.vbs"
        imgPath = easallyFolder & "\icon.ico"
        fso.CopyFile localAppPath, easallyFolder & "\", True
        fso.CopyFile localImgPath, easallyFolder & "\", True

        wShell.RegWrite regCell, "wscript " & Chr(34) & scriptPath & Chr(34) & " " & Chr(34) & gameLauncher & Chr(34), "REG_SZ"

        Set shortcut = wShell.CreateShortcut(desktop & "\Return to Game Mode.lnk")
        tPath = Chr(34) & command & Chr(34)
        shortcut.TargetPath = scriptPath
        shortcut.Arguments = Chr(34) & gameLauncher & Chr(34)
        shortcut.Description = "Easally - Return to Gaming Mode"
        shortcut.WorkingDirectory = easallyFolder
        shortcut.IconLocation = imgPath
        shortcut.Save
        MsgBox "Installation Complete"
    Else
        MsgBox "Launcher Not Found - Please verify the path and try again"
    End If
End If
