@echo off

:: Elevate privileges
fltmc >nul 2>&1 || (powershell -Command "Start-Process '%0' -Verb RunAs" & exit)

:: Optimize TCP/IP settings
netsh int tcp set global autotuning=normal >nul
netsh int tcp set heuristics disabled >nul
netsh int tcp set global rss=enabled >nul
netsh int tcp set global chimney=enabled >nul
netsh int tcp set global dca=enabled >nul
netsh int tcp set global netdma=enabled >nul
netsh int tcp set global ecncapability=disabled >nul
netsh int tcp set global timestamps=disabled >nul

:: Flush DNS cache
ipconfig /flushdns >nul

:: Reset Winsock
netsh winsock reset >nul
netsh int ip reset >nul

:: Increase DNS Cache Size
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxCacheTtl /t REG_DWORD /d 86400 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxNegativeCacheTtl /t REG_DWORD /d 5 /f >nul

:: Disable Network Throttling Index (better performance for gaming)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >nul

:: Optimize Network Performance for Gaming
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v SchedulingCategory /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v SFIOPriority /t REG_SZ /d "High" /f >nul

:: Disable Large Send Offload (LSO)
netsh int tcp set global taskoffload=disabled >nul

:: Disable Power Saving on Wi-Fi Adapter
for /f "tokens=*" %%A in ('wmic nic where "NetConnectionStatus=2" get NetConnectionID') do (
    netsh interface set interface name="%%A" admin=enable >nul
)

:: Disable Background Services Consuming Bandwidth
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul

:: Completion message
echo Wi-Fi optimization complete. Restart your PC for the best results.
pause
