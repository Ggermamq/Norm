@echo off
REM ============================================================
REM 02_GPU_AMD: отключить USB Selective Suspend и запрет отключения
REM USB-устройств (мышь/клавиатура) для экономии энергии.
REM На AMD чипсетах (X570/B650 и др.) это заметный источник микрофризов
REM и лишних ~1-3 мс задержки ввода.
REM Откат: powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308d3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1
REM        + вернуть "Разрешить отключение..." в диспетчере устройств.
REM ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Запустите от имени администратора.
    pause
    exit /b 1
)

REM USB selective suspend OFF (AC и DC)
powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308d3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg /setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308d3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg /setactive SCHEME_CURRENT

REM Запретить Windows отключать USB Root Hubs и устройства HID для энергосбережения
powershell -NoProfile -Command ^
 "Get-CimInstance Win32_PnPEntity | Where-Object { $_.Name -match 'USB Root Hub|Generic USB Hub|USB Input Device' } | ForEach-Object { $p = $_; Get-CimInstance -Namespace root\wmi -ClassName MSPower_DeviceEnable -ErrorAction SilentlyContinue | Where-Object { $_.InstanceName -like ($p.DeviceID + '*') } | Set-CimInstance -Property @{Enable=$false} }"

echo Готово. Перезагрузитесь.
pause
