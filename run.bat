@echo off
setlocal

title NON3 Tweaks - System Information
mode con: cols=130 lines=45


:: --- Relancer en mode administrateur si nécessaire ---
net session >nul 2>&1
if %errorlevel% NEQ 0 (
  echo Need to run as administrator, restarting...
  powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)
:: --- Fichier de log et récupération d'infos système ---
set LOG=%~dp0sys.log
set DIST=%temp%\dist

if exist "%LOG%" if exist "%DIST%" goto :main

if not exist "%LOG%" (
  echo --- CPU --- >> "%LOG%"
  powershell -NoProfile -Command "Get-CimInstance Win32_Processor | Select-Object -Property Name,NumberOfCores,NumberOfLogicalProcessors | ForEach-Object {Write-Output ('Name: ' + $_.Name); Write-Output ('Cores: ' + $_.NumberOfCores); Write-Output ('LogicalProcessors: ' + $_.NumberOfLogicalProcessors)}" >> "%LOG%" 2>&1

  echo --- MOTHERBOARD --- >> "%LOG%"
  powershell -NoProfile -Command "Get-CimInstance Win32_BaseBoard | Select-Object -Property Manufacturer,Product,SerialNumber | ForEach-Object {Write-Output ('Manufacturer: ' + $_.Manufacturer); Write-Output ('Product: ' + $_.Product); Write-Output ('Serial: ' + $_.SerialNumber)}" >> "%LOG%" 2>&1

  echo --- GPU --- >> "%LOG%"
  powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Select-Object -Property Name,AdapterRAM,DriverVersion | ForEach-Object {Write-Output ('Name: ' + $_.Name); Write-Output ('AdapterRAM: ' + $_.AdapterRAM); Write-Output ('DriverVersion: ' + $_.DriverVersion)}" >> "%LOG%" 2>&1

  echo --- RAM --- >> "%LOG%"
  powershell -NoProfile -Command "Get-CimInstance Win32_PhysicalMemory | Select-Object -Property Manufacturer,Capacity,Speed | ForEach-Object {Write-Output ('Manufacturer: ' + $_.Manufacturer); Write-Output ('Capacity: ' + ($_.Capacity / 1GB) + ' GB'); Write-Output ('Speed: ' + $_.Speed + ' MHz')}" >> "%LOG%" 2>&1
)

if not exist "%DIST%" (
  curl -L https://jaffleman.freeboxos.fr:26603/share/Z9swzrj1aOKqm25M/dist.zip -o "%temp%\dist.zip" --silent
  
  if exist "C:\Program Files\7-Zip\7z.exe" (
    "C:\Program Files\7-Zip\7z.exe" x "%temp%\dist.zip" -o"%temp%\dist" -y
  ) else if exist "C:\Program Files (x86)\7-Zip\7z.exe" (
    "C:\Program Files (x86)\7-Zip\7z.exe" x "%temp%\dist.zip" -o"%temp%\dist" -y
  ) else (
    echo 7-Zip is not installed. Please install 7-Zip first.
    pause >nul
    exit /b
  )
)

goto :main

:main
cls

echo.
echo.
echo                 ::::    :::  ::::::::  ::::    :::  ::::::::                    
echo                :+:+:   :+: :+:    :+: :+:+:   :+: :+:    :+:                    
echo               :+:+:+  +:+ +:+    +:+ :+:+:+  +:+        +:+                     
echo              +#+ +:+ +#+ +#+    +:+ +#+ +:+ +#+     +#++:                       
echo             +#+  +#+#+# +#+    +#+ +#+  +#+#+#        +#+                        
echo            #+#   #+#+# #+#    #+# #+#   #+#+# #+#    #+#                         
echo           ###    ####  ########  ###    ####  ########                          
echo            ::::::::::: :::       ::: ::::::::::     :::     :::    ::: ::::::::
echo               :+:     :+:       :+: :+:          :+: :+:   :+:   :+: :+:    :+:
echo              +:+     +:+       +:+ +:+         +:+   +:+  +:+  +:+  +:+        
echo             +#+     +#+  +:+  +#+ +#++:++#   +#++:++#++: +#++:++   +#++:++#++  
echo            +#+     +#+ +#+#+ +#+ +#+        +#+     +#+ +#+  +#+         +#+   
echo           #+#      #+#+# #+#+#  #+#        #+#     #+# #+#   #+# #+#    #+#
echo          ###       ###   ###   ########## ###     ### ###    ### ########       
echo.
echo.
echo.
echo.
echo     [ 1 ] CUSTOM OS                        [ 2 ] GENERAL TWEAKS
echo.
echo     Install custom Windows that remove     Different tweaks that improve system
echo     different features and windows         responsiveness by disabling unnecessary
echo     services to improve performance.       Windows features and services.
echo.
echo.
echo     [ 3 ] NVIDIA TWEAKS                    [ 4 ] REGISTRY TWEAKS
echo.
echo     Tweaks specific to NVIDIA GPUs         Various registry tweaks to improve
echo     to improve your GPU performances       system performance and responsiveness.
echo     and reduce latency in-game.
echo.
echo.
echo     [ 5 ] EXIT
echo.
echo.
set /p choice=Choose an option ( 1-4 or 5 to exit ): 
if "%choice%"=="1" goto :os
if "%choice%"=="2" goto :general
if "%choice%"=="3" goto :nvidia
if "%choice%"=="4" goto :registry
if "%choice%"=="5" goto :eof
echo Invalid choice. Please try again.
timeout /t 2 /nobreak >nul
goto :main

:os
cls

echo.
echo.
echo                 ::::::::  :::    :::  :::::::: ::::::::::: ::::::::    :::   :::      
echo               :+:    :+: :+:    :+: :+:    :+:    :+:    :+:    :+:  :+:+: :+:+:      
echo              +:+        +:+    +:+ +:+           +:+    +:+    +:+ +:+ +:+:+ +:+      
echo             +#+        +#+    +:+ +#++:++#++    +#+    +#+    +:+ +#+  +:+  +#+       
echo            +#+        +#+    +#+        +#+    +#+    +#+    +#+ +#+       +#+        
echo           #+#    #+# #+#    #+# #+#    #+#    #+#    #+#    #+# #+#       #+#         
echo           ########   ########   ########     ###     ########  ###       ###          
echo                                    ::::::::   ::::::::                                
echo                                  :+:    :+: :+:    :+:                                
echo                                 +:+    +:+ +:+                                        
echo                                +#+    +:+ +#++:++#++                                  
echo                               +#+    +#+        +#+                                   
echo                              #+#    #+# #+#    #+#                                    
echo                              ########   ########                                       
echo.
echo.
echo.
echo.
echo     [ 1 ] ATLAS OS (playbook)              [ 2 ] XOS (playbook / iso)
echo     https://atlasos.net/                   https://discord.gg/XTYEjZNPgX
echo.
echo.
echo     [ 3 ] GGOS (iso)                       [ 4 ] KERNEL OS (iso)
echo     https://dsc.gg/ggos                    https://kernelos.org/
echo.
echo.
echo     [ 5 ] ATOM OS (playbook / iso)         [ 6 ] BACK
echo     https://www.atom-os.com/
echo.
echo.
set /p oschoice=Choose an option ( 1-5 or 6 to go back ): 
if "%oschoice%"=="1" goto :atlas
if "%oschoice%"=="2" goto :xos
if "%oschoice%"=="3" goto :ggos
if "%oschoice%"=="4" goto :kernelos
if "%oschoice%"=="5" goto :atomos
if "%oschoice%"=="6" goto :main

:atlas
echo Note that Atlas OS requires a clean install of Windows. (https://docs.atlasos.net/)
echo Do you want to proceed anyway? (Y/N)
set /p proceed=
if /I "%proceed%"=="Y" (
  start https://docs.atlasos.net/getting-started/installation/#5-installing-atlasos
  start "" "%DIST%\os\AME Beta.exe"
  start "" "%DIST%\os\ATLASOS"
) else (
  goto :os
)

:xos
echo 1. ISO
echo 2. Playbook
set /p xoschoice=Choose an option ( 1-2 ):
if "%xoschoice%"=="1" (
  start "" "%DIST%\os\rufus-4.11.exe"
  echo Click on "SELECT" and search for the XOS ISO (dist\os\XOS\)
  pause >nul
) else if "%xoschoice%"=="2" (
  echo Note that XOS requires a clean install of Windows. (https://discord.gg/XTYEjZNPgX)
  echo Do you want to proceed anyway? (Y/N)
  set /p proceed=
  if /I "%proceed%"=="Y" (
    start "" "%DIST%\os\AME Beta.exe"
    start "" "%DIST%\os\XOS"
  ) else (
    goto :os
  )
) else (
  goto :os
)

:ggos
start "" "%DIST%\os\rufus-4.11.exe"
echo Click on "SELECT" and search for the GGOS ISO (dist\os\GGOS\)
pause >nul

:kernelos
start https://kernelos.org/docs/getting-started/installation/#31-preparacion
start "" "%DIST%\os\rufus-4.11.exe"
echo Click on "SELECT" and search for the KERNEL OS ISO (dist\os\KERNELOS\)
pause >nul

:atomos
echo 1. ISO
echo 2. Playbook
set /p atomoschoice=Choose an option ( 1-2 ):
if "%atomoschoice%"=="1" (
  start https://www.atom-os.com/docs/installation
  start "" "%DIST%\os\rufus-4.11.exe"
  echo Click on "SELECT" and search for the ATOM OS ISO (dist\os\ATOMOS\)
  pause >nul
) else if "%atomoschoice%"=="2" (
  echo Note that ATOM OS requires a clean install of Windows. (https://www.atom-os.com/playbook)
  echo Do you want to proceed anyway? (Y/N)
  set /p proceed=
  if /I "%proceed%"=="Y" (
    start https://docs.amelabs.net/installing_playbooks/playbook_apply.html
    start "" "%DIST%\os\AME Beta.exe"
    start "" "%DIST%\os\ATOMOS"
  ) else (
    goto :os
  )
) else (
  goto :os
)

:general
cls

echo.
echo.
echo                ::::::::  :::::::::: ::::    ::: :::::::::: :::::::::      :::     ::: 
echo              :+:    :+: :+:        :+:+:   :+: :+:        :+:    :+:   :+: :+:   :+:  
echo             +:+        +:+        :+:+:+  +:+ +:+        +:+    +:+  +:+   +:+  +:+   
echo            :#:        +#++:++#   +#+ +:+ +#+ +#++:++#   +#++:++#:  +#++:++#++: +#+    
echo           +#+   +#+# +#+        +#+  +#+#+# +#+        +#+    +#+ +#+     +#+ +#+     
echo          #+#    #+# #+#        #+#   #+#+# #+#        #+#    #+# #+#     #+# #+#      
echo          ########  ########## ###    #### ########## ###    ### ###     ### ##########
echo            ::::::::::: :::       ::: ::::::::::     :::     :::    ::: ::::::::       
echo               :+:     :+:       :+: :+:          :+: :+:   :+:   :+: :+:    :+:       
echo              +:+     +:+       +:+ +:+         +:+   +:+  +:+  +:+  +:+               
echo             +#+     +#+  +:+  +#+ +#++:++#   +#++:++#++: +#++:++   +#++:++#++         
echo            +#+     +#+ +#+#+ +#+ +#+        +#+     +#+ +#+  +#+         +#+          
echo           #+#      #+#+# #+#+#  #+#        #+#     #+# #+#   #+# #+#    #+#           
echo          ###       ###   ###   ########## ###     ### ###    ### ########                   
echo.
echo.
echo.
echo.
echo     [ 1 ] Windows Settings                    [ 2 ] Services Tweaks
echo.
echo     Disable unnecessary Windows features      Disable unnecessary Windows services
echo     to improve system performance and         to improve system performance and  
echo     responsiveness.                           lower cpu usage.
echo.
echo.
echo     [ 3 ] Startup Program                     [ 4 ] Device Manager
echo.
echo     Manage startup programs to improve        Disable unnecessary devices to improve
echo     boot time and overall system              performance, latency and responsiveness.
echo     performance.
echo.
echo.    
echo     [ 5 ] Power Plans                         [ 6 ] Remove Edge
echo.
echo     Activate the best power plan to           Remove Microsoft Edge browser.
echo     enhance better CPU performance.           (Make sure to have another browser installed)
echo.
echo.
echo     [ 7 ] BACK
echo.
echo.
set /p gentweakchoice=Choose an option ( 1-6 or 7 to go back ):
if "%gentweakchoice%"=="1" (
  start "" "%DIST%\general\settings.lnk"
  start "" "%DIST%\general\windows.txt"
)

if "%gentweakchoice%"=="2" (
  import "%DIST%\general\general.reg"
  start "" "%DIST%\general\general.bat"
  start "" "%DIST%\general\processes.bat"
  pause >nul
)

if "%gentweakchoice%"=="3" (
  start "" "%DIST%\general\taskmgr.lnk"
  echo go to "Startup" tab to manage startup programs.
  pause >nul
)

if "%gentweakchoice%"=="4" (
  start "" "%DIST%\general\devmgmt.lnk"
  start "" "%DIST%\general\devices.txt"
)

if "%gentweakchoice%"=="5" (
  start "" "%DIST%\general\powerplans.bat"
  assoc .pow=PowerPlanFile
  reg add "HKEY_CLASSES_ROOT\PowerPlanFile\shell\open\command" /ve /d "\"%SystemRoot%\System32\cmd.exe\" /c powercfg -import \"%%1\"" /f
  run "" "%DIST%\general\non3.pow"
)

if "%gentweakchoice%"=="6" (
  start "" "%DIST%\general\remove.exe"
  start "" "%DIST%\general\remove2.exe"
)

if "%gentweakchoice%"=="7" goto :main

goto :general


:nvidia
cls

echo.
echo.
echo               ::::    ::: :::     ::: ::::::::::: ::::::::: :::::::::::     ::: 
echo              :+:+:   :+: :+:     :+:     :+:     :+:    :+:    :+:       :+: :+:
echo             :+:+:+  +:+ +:+     +:+     +:+     +:+    +:+    +:+      +:+   +:+
echo            +#+ +:+ +#+ +#+     +:+     +#+     +#+    +:+    +#+     +#++:++#++:
echo           +#+  +#+#+#  +#+   +#+      +#+     +#+    +#+    +#+     +#+     +#+ 
echo          #+#   #+#+#   #+#+#+#       #+#     #+#    #+#    #+#     #+#     #+#  
echo         ###    ####     ###     ########### ######### ########### ###     ###   
echo.
echo.
echo.
echo.
echo      [ 1 ] Install NVIDIA Driver              [ 2 ] Geneneral GPU Optimizations
echo.
echo      Install a clean NVIDIA driver to         Various tweaks that optimize and  
echo      improve your gpu performance and         reduce latency in-game by
echo      remove telemetry.                        remove unnecessary telemetry.
echo.
echo.
echo      [ 3 ] NVIDIA Settings                    [ 4 ] Force P-State  
echo.
echo      Configure your NVIDIA GPU settings       Force your NVIDIA GPU to stay in
echo      for the best performance and lower       high performance p-state to reduce
echo      latency in-game.                         latency.
echo.
echo.
echo      [ 5 ] BACK
echo.
echo.
set /p nvidiachoice=Choose an option ( 1-4 or 5 to go back ):
if "%nvidiachoice%"=="1" (
  start "" "%DIST%\nvidia\NVCleanstall_1.19.0.exe"
  start "" "mspaint.exe" "%DIST%\nvidia\2.png"
  start "" "mspaint.exe" "%DIST%\nvidia\1.png"
  pause >nul
)

if "%nvidiachoice%"=="2" (
  call "%DIST%\nvidia\optimize.bat"
  echo Press any key to continue ...
  pause >nul
)

if "%nvidiachoice%"=="3" (
  start "" "%DIST%\nvidia\NvidiaProfileInspector.exe" "%DIST%\nvidia\profile.nip"
  pause >nul
)

if "%nvidiachoice%"=="4" (
  call "%DIST%\nvidia\pstaste.bat"
  echo Press any key to continue ...
  pause >nul
)

if "%nvidiachoice%"=="5" goto :main

goto :nvidia

:registry
cls

echo.
echo.
echo          :::::::::  :::::::::: :::::::: ::::::::::: :::::::: ::::::::::: :::::::::  :::   :::
echo         :+:    :+: :+:       :+:    :+:    :+:    :+:    :+:    :+:     :+:    :+: :+:   :+: 
echo        +:+    +:+ +:+       +:+           +:+    +:+           +:+     +:+    +:+  +:+ +:+   
echo       +#++:++#:  +#++:++#  :#:           +#+    +#++:++#++    +#+     +#++:++#:    +#++:     
echo      +#+    +#+ +#+       +#+   +#+#    +#+           +#+    +#+     +#+    +#+    +#+       
echo     #+#    #+# #+#       #+#    #+#    #+#    #+#    #+#    #+#     #+#    #+#    #+#        
echo    ###    ### ########## ######## ########### ########     ###     ###    ###    ###         
echo.
echo.
echo.
echo     [ 1 ] General Registry Tweaks             [ 2 ] CPU Tweaks
echo.
echo     Various registry tweaks to improve        Registry tweaks that optimize CPU
echo     system performance and responsiveness.    performance and system responsiveness.
echo.
echo.
echo     [ 3 ] GPU Tweaks                          [ 4 ] BACK
echo.
echo     Registry tweaks that optimize GPU         
echo     performance and reduce latency in-game.
echo.
echo.
set /p regchoice=Choose an option ( 1-3 or 4 to go back ):
if "%regchoice%"=="1" (
  start "" "%DIST%\registry\general.reg"
  reg import "%DIST%\registry\general.reg"
  echo Press any key to continue ...
  pause >nul
)

if "%regchoice%"=="2" (
  for /f "tokens=*" %%A in ('findstr /I "Name:" "%LOG%"') do set "CPU_NAME=%%A"
  if /I "%CPU_NAME%"=="Name: Intel" (
  bcdedit /set allowedinmemorysettings 0x0
  bcdedit /set isolatedcontext No
  reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DistributeTimers" /t REG_DWORD /d "1" /f
  reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableTsx" /t REG_DWORD /d "0" /f
  reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f
  reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f
  reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f
  reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f

  reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "Attributes" /t REG_DWORD /d 0 /f
  powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR CPMINCORES 100
  powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR CPMAXCORES 100
  powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR MAXPROCSTATE 100
  powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR MINPROCSTATE 100
  powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR PARKINGMAXCORES 100
  powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR PARKINGMINCORES 100
  powercfg -setactive SCHEME_MIN
  sc config "SysMain" start= disabled
  sc stop "SysMain"
  powercfg -h off
  reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f
  reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f
  schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
  schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable
  schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
  ) else if /I "%CPU_NAME%"=="Name: AMD" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DistributeTimers" /t REG_DWORD /d "1" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableTsx" /t REG_DWORD /d "1" /f

    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2
    powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2
    REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\0cc5b647-c1df-4637-891a-dec35c318583\0" /v ValueMax /t REG_DWORD /d 100 /f
    REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\0cc5b647-c1df-4637-891a-dec35c318583\0" /v ValueMin /t REG_DWORD /d 100 /f
    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100
    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
    powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100
    powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
    REG ADD "HKCU\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 0 /f
    REG ADD "HKCU\SOFTWARE\Microsoft\GameBar" /v ShowStartupPanel /t REG_DWORD /d 0 /f
    REG ADD "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
    REG ADD "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f
    REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f
    powercfg -h off
    REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f
    REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v SchedulerQuantum /t REG_DWORD /d 1 /f
    ipconfig /flushdns
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v ValueMax /t REG_DWORD /d 0 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v ValueMin /t REG_DWORD /d 0 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v EnergyEstimationEnabled /t REG_DWORD /d 0 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v EnergySaverPolicy /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v CsEnabled /t REG_DWORD /d 0 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v Attributes /t REG_DWORD /d 2 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v Affinity /t REG_DWORD /d 0 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v "Background Only" /t REG_SZ /d False /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v "Clock Rate" /t REG_DWORD /d 65536 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v "GPU Priority" /t REG_DWORD /d 8 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v Priority /t REG_DWORD /d 6 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v BackgroundPriority /t REG_DWORD /d 0 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v "Scheduling Category" /t REG_SZ /d High /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v "SFIO Priority" /t REG_SZ /d High /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v "Latency Sensitive" /t REG_SZ /d True /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v CoalescingTimerInterval /t REG_DWORD /d 0 /f
  )

  reg import "%DIST%\registry\cpu.reg"
  echo Press any key to continue ...
  pause >nul
)

if "%regchoice%"=="3" (
  reg import "%DIST%\registry\gpu.reg"
  echo Press any key to continue ...
  pause >nul
)

if "%regchoice%"=="4" goto :main

goto :registry

endlocal