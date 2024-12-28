@echo off

:: Elevate privileges
fltmc >nul 2>&1 || (powershell -Command "Start-Process '%0' -Verb RunAs" & exit)

:: Restore TCP/IP settings
netsh int tcp set global autotuning=normal >nul
netsh int tcp set heuristics enabled >nul
netsh int tcp set global rss=disabled >nul
netsh int tcp set global chimney=default >nul
netsh int tcp set global dca=default >nul
netsh int tcp set global netdma=default >nul
netsh int tcp set global ecncapability=default >nul
netsh int tcp set global timestamps=default >nul

:: Reset DNS cache size
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxCacheTtl /f >nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxNegativeCacheTtl /f >nul

:: Restore Network Throttling Index
goto :check_registry
:check_registry
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex >nul 2>&1
if %errorlevel% equ 0 (
    reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /f >nul
)

:: Restore Game Priority settings
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /f >nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v SchedulingCategory /f >nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v SFIOPriority /f >nul

:: Re-enable Large Send Offload (LSO)
netsh int tcp set global taskoffload=enabled >nul

:: Re-enable Wi-Fi Power Saving
for /f "tokens=*" %%A in ('wmic nic where "NetConnectionStatus=2" get NetConnectionID') do (
    netsh interface set interface name="%%A" admin=enable >nul
)

:: Re-enable background services
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 0 /f >nul

:: Completion message
echo Network settings restored to defaults. Restart your PC for changes to take effect.
pause
