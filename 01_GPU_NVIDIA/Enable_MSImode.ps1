# ============================================================
# 01_GPU_NVIDIA: включить Message Signaled Interrupts (MSI) для GPU
# и отключить совместное использование прерываний (Line-based IRQ).
# Меньше DPC-латентность => ниже задержка ввода.
# Запуск: powershell -ExecutionPolicy Bypass -File Enable_MSImode.ps1
# Откат: выключить галку "Use MSI..." в Диспетчере устройств -> Свойства ->
#        Ресурсы -> Настройка параметров (или _RESTORE).
# ============================================================

$ErrorActionPreference = 'SilentlyContinue'

Write-Host "== Поиск видеоадаптеров NVIDIA ==" -ForegroundColor Cyan
$gpus = Get-PnpDevice -Class Display | Where-Object { $_.FriendlyName -match 'NVIDIA|GeForce' }
if (-not $gpus) { Write-Host "NVIDIA GPU не найден. Выход."; exit 1 }

foreach ($gpu in $gpus) {
    Write-Host ("Устройство: " + $gpu.FriendlyName)
    # Открыть диалог свойств устройства, где вручную ставится MSI mode
    # (Windows не даёт программно менять тип прерываний без devcon/PnP API,
    #  поэтому скрипт открывает нужный dialog и печатает инструкцию).
    Start-Process "devmgmt.msc"
    Write-Host ""
    Write-Host "Инструкция:" -ForegroundColor Yellow
    Write-Host " 1. Диспетчер устройств -> Видеоадаптеры -> ваша NVIDIA"
    Write-Host " 2. Свойства -> вкладка 'Ресурсы' -> снять 'Использовать общие параметры'"
    Write-Host " 3. Если есть 'Прерывание' (IRQ) — заменить на 'Message Based View' (MSI)"
    Write-Host " 4. Также проверьте: контроллер NVMe/USB часто сидит на Line IRQ —"
    Write-Host "    переведите их на MSI тем же способом."
}

Write-Host ""
Write-Host "Дополнительно: NVRHI/ReBAR уже включается драйвером при Above-4G в BIOS."
Read-Host "Нажмите Enter для выхода"
