@echo off
REM ============================================================
REM 00_COMMON_BASE: отключить фоновые службы, добавляющие задержку/фризы.
REM Откат: _RESTORE\Restore_Services.bat
REM ВНИМАНИЕ: служба Windows Update возвращается командой из _RESTORE или
REM вручную: sc config wuauserv start= delayed-auto
REM ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Запустите от имени администратора.
    pause
    exit /b 1
)

echo Отключение служб...

REM --- Телеметрия и сборщики данных (нагрузка на CPU/Disk в фоне)
sc config DiagTrack start= disabled   >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
sc config SysMain start= disabled     >nul 2>&1 & REM Superfetch: на SSD не нужен, вызывает диск-пики
sc config WSearch start= manual       >nul 2>&1 & REM Индексация поиска — пиковые нагрузки диска
sc config Spooler start= manual       >nul 2>&1 & REM Очередь печати (если нет принтера)
sc config Fax start= disabled         >nul 2>&1
sc config lfsvc start= manual         >nul 2>&1 & REM Geolocation
sc config MapsBroker start= disabled  >nul 2>&1
sc config wlidsvc start= manual       >nul 2>&1
sc config WiseBootAssistant start= disabled >nul 2>&1

REM --- Xbox/GameBar компоненты (оверлей = лишняя задержка ввода)
sc config GameInputRedistService start= disabled >nul 2>&1
taskkill /f /im GameBar.exe           >nul 2>&1
taskkill /f /im GameBarFTServer.exe   >nul 2>&1

REM --- Windows Update временно (вернуть перед обычным использованием ПК!)
sc config wuauserv start= manual      >nul 2>&1
sc config UsoSvc start= manual        >nul 2>&1

REM --- Немедленно остановить критичные для фризов
taskkill /f /im SearchIndexer.exe     >nul 2>&1
taskkill /f /im MsMpEng.exe           >nul 2>&1 & REM НЕ отключайте Defender навсегда! Только рестарт процесса.

echo.
echo Готово. Перезагрузитесь.
pause
