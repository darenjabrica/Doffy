@echo off

:: Elevate privileges
fltmc >nul 2>&1 || (powershell -Command "Start-Process '%0' -Verb RunAs" & exit)

:: Stop unnecessary services
net stop "SysMain" >nul 2>&1
net stop "DiagTrack" >nul 2>&1
net stop "WSearch" >nul 2>&1

:: Disable visual effects for performance
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul

:: Set power plan to High Performance
powercfg /setactive SCHEME_MIN >nul

:: Enable Ultimate Performance Plan (Optional)
:: powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul

:: Clean temp files
rd /s /q "%TEMP%" >nul 2>&1
md "%TEMP%" >nul

:: Disable Windows Game Bar and DVR
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul

:: Prioritize Valorant
wmic process where name="VALORANT-Win64-Shipping.exe" CALL setpriority "high priority" >nul 2>&1

:: Set GPU preference for Valorant (NVIDIA)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul

:: Disable background apps
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul

:: Apply Network Optimization
netsh interface tcp set global autotuning=normal >nul
netsh interface tcp set heuristics disabled >nul
netsh int tcp set global rss=enabled >nul

:: Defragment drives (only if not SSD)
defrag c: /O >nul

:: Clear DNS cache
ipconfig /flushdns >nul

:: Restart Windows Explorer (optional for settings to take effect)
taskkill /f /im explorer.exe >nul
start explorer.exe

:: Completion message
echo Optimization complete. Enjoy improved FPS in Valorant!
pause
