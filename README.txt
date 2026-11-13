========================================================================
CS2 LOW-LATENCY / HIGH-FPS TWEAK PACK v2.0  (Windows 11, Desktop)
========================================================================

Цель: максимальный FPS и минимальная задержка ввода в Counter-Strike 2,
стабильная производительность (низкий 1% low) в других играх.

Структура папок — РАЗДЕЛЕНИЕ ПО ВИДЕОКАРТЕ И ХАРАКТЕРИСТИКАМ:

  00_COMMON_BASE\          Базовые твики Windows 11 (одинаковы для всех)
  01_GPU_NVIDIA\           Только для NVIDIA (GeForce)
  02_GPU_AMD\              Только для AMD (Radeon)
  03_CPU_INTEL\            Твики под Intel CPU
  04_CPU_AMD\              Твики под AMD CPU (Ryzen)
  05_RAM_16GB\             Профиль памяти: 16 ГБ
  06_RAM_32GB_PLUS\        Профиль памяти: 32 ГБ и больше
  07_NETWORK\              Сеть / пинг / буферизация (все системы)
  08_STORAGE_SSD\          SSD/NVMe (все системы)
  09_STORAGE_HDD\          HDD (если используется как игровой диск)
  10_CS2_CONFIG\           Готовый autoexec.cfg + параметры запуска CS2
  11_POWER_PLANS\          Электропитание (Ultimate Performance / Game plan)
  _RESTORE\                Откат настроек (реестр + bcdedit + netsh)

КАК ПРИМЕНЯТЬ (порядок):
  1. Создать ТОЧКУ ВОССТАНОВЛЕНИЯ (00_COMMON_BASE\Create_Restore_Point.bat).
  2. Запускать .bat/.cmd файлы от администратора по одному.
     .reg файлы — двойной клик -> "Да".
  3. Порядок: 00_COMMON_BASE -> ваш GPU (01 или 02) -> ваш CPU (03 или 04)
     -> ваш RAM (05 или 06) -> 07..09 -> 10 -> 11 -> перезагрузка.
  4. После применения ВСЕГДА делать перезагрузку.

ПОРЯДОК ПЕРЕ ЗАПУСКОМ ТВИКОВ (важнее самих твиков!):
  - BIOS: XMP/EXPO профиль ОН, Above 4G Decoding ON, ReBAR/Resizable BAR ON,
          CSM OFF (UEFI only), Secure Boot по вкусу, Global C-state Control
          можно оставить ON (на новых платформах разница мала).
  - Windows Update выключить на время сессий (00_COMMON_BASE\Disable_WU_temporary.bat).
  - Драйвер GPU: чистая установка через DDU в безопасном режиме.
      NVIDIA: Studio НЕ надо — ставте Game Ready; в панели NVIDIA:
        Low Latency Mode = Ultra (или Ultra+Boost),
        Power Management = Prefer Maximum Performance,
        Threaded Optimization = ON, V-Sync = Off (в игре через reflex).
      AMD: в Adrenalin Radeon Anti-Lag 2 / Boost где поддерживается игрой.
  - CS2: параметр запуска -fullscreen (полный экран, НЕ окно без рамки),
         mat_reflexAllowPartialFrame = 1 в конфиге при поддержке Reflex.
  - МЫШЬ: в реестре точность мыши OFF (входит в базовый пакет).

ВНИМАНИЕ / ЧЕСТНОЕ МНЕНИЕ:
  * Часть популярных "твиков" (NetworkThrottlingIndex=ffffffff,
    Win32PrioritySeparation=40, отключение Spectre/Meltdown) дают от 0 до
    ~1-3% и иногда вредят стабильности. Здесь они собраны отдельными
    файлами с пометками [РИСК] — применяйте осознанно.
  * На актуальном Windows 11 24H2 многие сетевые "ускорители" не влияют ни
    на что. Реальный latency в CS2 дают: полный экран, Reflex/Anti-Lag,
    высокий FPS, отключенный оверлей,GameManager и фоновые приложения.
  * Файлы из старого набора были повреждены (битая кодировка UTF-16/CP1251)
    и частично содержали ОПАСНЫЕ значения (например TcpAckFrequency=0 и
    TCPNoDelay=0 вместо 1 — это УХУДШАЕТ пинг). Всё исправлено ниже.

Все скрипты протестированы на синтаксис, но ответственность за применение
— на вас. Каталог _RESTORE возвращает значения к дефолту Windows 11.
========================================================================
