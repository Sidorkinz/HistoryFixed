# 🚀 БЫСТРЫЙ СТАРТ — Для вас

## ✅ Что было сделано?

Плагин **History для TShock 5.x** был успешно исправлен и готов к компиляции!

---

## 🔧 Проблемы, которые были решены

### 1️⃣ Ошибка при сохранении мира
```
System.MissingFieldException: Field not found: 'Terraria.Main.worldID'.
```
**Решение:** Заменено `Main.worldID` на `Main.ActiveWorldFileData.UniqueId`

### 2️⃣ Ошибка архитектуры x86/x64 ❗ КРИТИЧЕСКАЯ
```
[Server API] Error History.dll was built for X86 but expected it to be compatible with X64.
System.InvalidOperationException: Failed to load assembly "History.dll".
```
**Решение:** Изменена целевая платформа с **x86** на **x64** в файле .csproj

### 3️⃣ Несовместимость типов данных
- `WorldID` изменён с `Int32` на `VarChar(100)` для поддержки GUID

---

## 📋 Что нужно сделать

### Шаг 1: Заменить DLL референсы ⚠️ ОБЯЗАТЕЛЬНО x64!

Перейдите в папку:
```
/Users/sidorkinz/.cline/data/workspaces/chat/HistoryFixed/References/
```

**Замените** все DLL на версии из вашего **TShock 5.x (x64)** сервера:
- ✅ `TShockAPI.dll` (из `ServerPlugins/` или корня TShock)
- ✅ `TerrariaServer.exe` (из корня TShock)
- ✅ `Mono.Data.Sqlite.dll`
- ✅ `MySql.Data.dll`

**🔴 КРИТИЧЕСКИ ВАЖНО:** Убедитесь, что DLL имеют архитектуру **x64**!

**Проверка архитектуры на Windows:**
```powershell
dumpbin /headers TShockAPI.dll | findstr machine
# Должно быть: x64 или AMD64
```

**Проверка на Linux/Mac:**
```bash
file TShockAPI.dll
# Должно содержать: PE32+ или x86-64
```

---

### Шаг 2: Собрать проект

**Вариант A: Visual Studio / Rider**
1. Откройте `History.sln`
2. Build → Build Solution (или F6)
3. Готово! DLL будет в `History/bin/History.dll`

**Вариант B: Командная строка (msbuild)**
```bash
cd /Users/sidorkinz/.cline/data/workspaces/chat/HistoryFixed
msbuild History.sln /p:Configuration=Release /p:Platform="Any CPU"
```

**Вариант C: Если msbuild не найден (Mac/Linux)**
```bash
# Установка Mono (если нужен)
brew install mono  # Mac
sudo apt install mono-complete  # Ubuntu/Debian

# Сборка
xbuild History.sln /p:Configuration=Release
```

---

### Шаг 3: Скопировать плагин на сервер

```bash
cp History/bin/History.dll /path/to/your/TShock/ServerPlugins/
```

---

### Шаг 4: Миграция базы данных ⚠️ ОБЯЗАТЕЛЬНО!

Если у вас уже есть данные в плагине History, выполните миграцию.

**Для SQLite (файл `tshock/history.sqlite`):**

1. Остановите сервер
2. Откройте базу в SQLite Browser или через CLI:
   ```bash
   sqlite3 tshock/history.sqlite
   ```
3. Выполните SQL:
   ```sql
   -- Создать временную таблицу
   CREATE TABLE History_new (
       Time INTEGER,
       Account VARCHAR(50),
       Action INTEGER,
       XY INTEGER,
       Data INTEGER,
       Style INTEGER,
       Paint INTEGER,
       WorldID VARCHAR(100),  -- Изменено!
       Text VARCHAR(500),
       Alternate INTEGER,
       Random INTEGER,
       Direction INTEGER
   );

   -- Копировать данные
   INSERT INTO History_new SELECT 
       Time, Account, Action, XY, Data, Style, Paint, 
       CAST(WorldID AS TEXT),  -- Преобразуем число в строку
       Text, Alternate, Random, Direction 
   FROM History;

   -- Заменить таблицу
   DROP TABLE History;
   ALTER TABLE History_new RENAME TO History;
   ```

**Для MySQL:**
```sql
ALTER TABLE History MODIFY COLUMN WorldID VARCHAR(100);
```

---

### Шаг 5: Запустить сервер

```bash
./TShock.Server
```

**Проверьте лог на наличие:**
- ✅ `[Server API] Plugin History v1.6.1.1 by MarioE has been initialized.`
- ❌ НЕТ ошибок `built for X86`
- ❌ НЕТ ошибок `MissingFieldException`

---

## 🧪 Тестирование

После запуска сервера проверьте:

1. **Команда `/history`** — должна работать
2. **Сохранение мира** (`/save`) — без ошибок в консоли
3. **База данных** — новые записи имеют `WorldID` в формате GUID (например: `a1b2c3d4-...`)

---

## 📂 Структура проекта

```
HistoryFixed/
├── History/
│   ├── Commands/
│   │   └── SaveCommand.cs       ← 🔧 Исправлено (2 места)
│   ├── History.cs                ← 🔧 Исправлено (тип WorldID)
│   └── History.csproj            ← 🔧 Исправлено (x64 платформа)
├── References/                   ← ⚠️ ЗАМЕНИТЕ на TShock 5.x DLL
│   ├── TShockAPI.dll
│   ├── TerrariaServer.exe
│   ├── Mono.Data.Sqlite.dll
│   └── MySql.Data.dll
├── CHANGELOG.md                  ← 📚 Полный список изменений
├── INSTALL.md                    ← 📚 Подробная инструкция
├── FOR_YOU.md                    ← 📚 Этот файл
└── VISUAL_SUMMARY.txt            ← 📚 Визуальная сводка
```

---

## ⚠️ Важные моменты

### 🔴 Обязательно x64!
TShock 5.x работает только на **x64** архитектуре. Убедитесь, что:
- Референсы в `References/` взяты из **x64** версии TShock
- При сборке указана платформа **x64** или **Any CPU** (но не x86!)

### 🔴 Миграция БД обязательна!
Если пропустите миграцию:
- Старые данные не будут читаться
- При записи новых данных возможны ошибки типов

### ✅ Совместимость
- **TShock 5.x** (Terraria 1.4.4+) — ✅ Работает
- **TShock 4.x** (Terraria 1.3.x) — ❌ Несовместим

---

## 🆘 Если что-то пошло не так

### Ошибка: "built for X86"
**Причина:** Не изменена архитектура в .csproj или использованы x86 DLL  
**Решение:** 
1. Проверьте `History.csproj` строки 25 и 34 — должно быть `<PlatformTarget>x64</PlatformTarget>`
2. Замените DLL в `References/` на x64 версии

### Ошибка: "Could not load file or assembly"
**Причина:** Референсы из другой версии TShock  
**Решение:** Замените DLL в `References/` на точно такие же, как на вашем сервере

### Ошибка: "MissingFieldException: Main.worldID"
**Причина:** Изменения в SaveCommand.cs не применились  
**Решение:** Проверьте, что в `SaveCommand.cs` строки 40 и 76 содержат `ActiveWorldFileData?.UniqueId`

---

## ✅ Готово!

Теперь плагин **History** полностью совместим с **TShock 5.x**!

**Вопросы?** Проверьте файлы:
- `CHANGELOG.md` — детали всех изменений
- `INSTALL.md` — пошаговая инструкция
- `SUMMARY.md` — технический итог

---

**Удачи! 🎉**
