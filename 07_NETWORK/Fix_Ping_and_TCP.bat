@echo off
REM ============================================================
REM 07_NETWORK: исправленный "Decrease Ping.bat" из старого набора.
REM ВАЖНО: в старом файле было TcpAckFrequency=0 и TCPNoDelay=0 —
REM это НЕВЕРНО (0 = не трогать/по умолчанию). Правильные значения: 1.
REM Также старый скрипт писал ключ в корень Interfaces\ без GUID —
REM теперь перебираем все интерфейсы корректно.
REM Откат: _RESTORE\Restore_Network.reg + netsh команды там же.
REM ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Запустите от имени администратора.
    pause
    exit /b 1
)

echo Настройка TCP для всех активных интерфейсов...

REM --- TCP No Delay + Ack Frequency на каждый интерфейс
for /f "tokens=2 delims= " %%G in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" ^| findstr "Interfaces\\"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%G" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%G" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
)

REM --- ECN (из старого "Enble ECN Capability.bat", оставлено enabled:
REM безопасно, помогает некоторым серверам Steam; при проблемах с коннектом
REM ставьте disabled)
netsh int tcp set global ecncapability=enabled

REM --- Autotuning normal (NOT disabled! отключение ломает скорость загрузки)
netsh int tcp set global autotuninglevel=normal

REM --- Отключить Direct Cache Access (перерывания NIC бьют по latency на слабых CPU)
netsh int tcp set global dca=disabled

REM --- Отключить NetDMA (устаревшее, снижает DPC-нагрузку)
netsh int tcp set global netdma=disabled

REM --- DNS: сброс кэша + прописываем надёжные resolvers (Google/Cloudflare).
REM При желании замените на DNS вашего провайдера/мейкера CS-серверов.
ipconfig /flushdns >nul 2>&1

REM --- Отключить RSC (Receive Segment Coalescing): коалесценция пакетов
REM добавляет задержку интерактивному трафику (ping), помогает только throughput.
netsh rsc set rscstate disabled
powershell -NoProfile "Disable-NetAdapterRsc -Name * -ErrorAction SilentlyContinue"

REM --- Отключить Energy Efficient Ethernet на NIC (просьба спящего режима = скачки пинга)
powershell -NoProfile "Get-NetAdapter | ForEach-Object { try { Set-NetAdapterPowerManagement -Name $_.Name -AllowRestart $false -WakeOnMagicPacket Disabled -WakeOnPattern Disabled -ErrorAction Stop } catch {} ; try { Disable-NetAdapterPowerFeature -Name $_.Name -ErrorAction Stop } catch {} }"

echo.
echo Готово. Проверка: ping 1.1.1.1 -t  (сравните до/после)
pause
