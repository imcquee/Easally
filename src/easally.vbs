Dim wShell,gameLauncher, buffer, executable, regCell, logonShell
Set wShell = WScript.CreateObject( "WScript.Shell" )
regCell = "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\shell"
localFolder = wShell.ExpandEnvironmentStrings("%localappdata%")
scriptPath = localFolder & "\Easally\easally.vbs"
gameLauncher = WScript.Arguments(0)
buffer = Split(gameLauncher, "\")
executable = buffer(Ubound(buffer))
wShell.Run("taskkill /im explorer.exe /F"), 1, TRUE
wShell.Exec(gameLauncher)
Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
Set colProcesses = objWMIService.ExecQuery ("Select * from Win32_Process Where Name = '"& executable &"'")
Do While colProcesses.Count > 0
    Set colProcesses = objWMIService.ExecQuery ("Select * from Win32_Process Where Name = '"& executable &"'")
    Wscript.Sleep(1000)
Loop

logonShell = wShell.RegRead(regCell)

If NOT (logonShell="explorer.exe") Then
    wShell.RegWrite regCell, "explorer.exe", "REG_SZ"
End if
wShell.Run("""explorer.exe""")
wShell.RegWrite regCell, "wscript " & Chr(34) & scriptPath  & Chr(34) & " " & Chr(34) & gameLauncher & Chr(34), "REG_SZ"
