@echo off

:: Elevate privileges
fltmc >nul 2>&1 || (powershell -Command "Start-Process '%0' -Verb RunAs" & exit)

:: Restart services
net start "SysMain" >nul 2>&1
net start "DiagTrack" >nul 2>&1
net start "WSearch" >nul 2>&1

:: Re-enable visual effects
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 1 /f >nul

:: Restore power settings
powercfg /setactive SCHEME_BALANCED >nul

:: Re-enable Windows Game Bar and DVR
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 1 /f >nul

:: Reset GPU preference (NVIDIA)
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /f >nul 2>&1

:: Enable background apps
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 0 /f >nul

:: Restore network settings
netsh interface tcp set global autotuning=normal >nul
netsh interface tcp set heuristics enabled >nul
netsh int tcp set global rss=disabled >nul

:: Completion message
echo Settings restored to default. Restart your PC for changes to take effect.
pause
