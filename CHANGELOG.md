# История изменений / Changelog

## Версия: TShock 5.x Compatible (Terraria 1.4.4+)

### Исправления / Fixes

**Проблема:** Плагин History выдавал ошибку при сохранении мира в TShock 5:
```
System.MissingFieldException: Field not found: 'Terraria.Main.worldID'.
   at History.Commands.SaveCommand.Execute()
   at History.History.OnSaveWorld(WorldSaveEventArgs e)
```

**Причина:** В Terraria 1.4.4+ поле `Main.worldID` (тип `int`) было удалено и заменено на `Main.ActiveWorldFileData.UniqueId` (тип `Guid`).

---

### Внесённые изменения / Changes Made

#### 1. **SaveCommand.cs** (строки 40 и 76)

**Было:**
```csharp
command.Parameters[7].Value = Main.worldID;
```

**Стало:**
```csharp
command.Parameters[7].Value = Main.ActiveWorldFileData?.UniqueId.ToString() ?? "Unknown";
```

**Пояснение:**
- `Main.ActiveWorldFileData` — новый API для получения информации о мире
- `UniqueId` — уникальный GUID мира (тип `Guid`)
- `.ToString()` — преобразование Guid в строку
- `?? "Unknown"` — fallback на случай, если данные не доступны

---

#### 2. **History.cs** (строка 1651)

**Было:**
```csharp
new SqlColumn("WorldID", MySqlDbType.Int32),
```

**Стало:**
```csharp
new SqlColumn("WorldID", MySqlDbType.VarChar) { Length = 100 }, // TShock 5.x: Guid string
```

**Пояснение:**
- Изменён тип колонки в базе данных с `Int32` на `VarChar(100)`
- Guid в строковом виде имеет формат `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` (36 символов)
- Запас до 100 символов для совместимости

---

#### 3. **History.csproj** (критическое исправление!)

**🔴 ВАЖНО для TShock 5.x:**

TShock 5.x работает на **x64** архитектуре, а старый плагин был собран для **x86**.

**Было:**
```xml
<PlatformTarget>x86</PlatformTarget>
<Reference Include="TerrariaServer, Version=1.3.0.6, Culture=neutral, processorArchitecture=x86">
<Reference Include="TShockAPI, Version=4.3.9.0, Culture=neutral, processorArchitecture=x86">
```

**Стало:**
```xml
<PlatformTarget>x64</PlatformTarget>
<Reference Include="TerrariaServer, Version=1.3.0.6, Culture=neutral">
<Reference Include="TShockAPI, Version=4.3.9.0, Culture=neutral">
```

**Пояснение:**
- Изменена целевая платформа с **x86** на **x64** (строки 25 и 34)
- Удалена привязка к архитектуре x86 в референсах (строки 47 и 51)
- Теперь плагин совместим с 64-битной версией TShock 5

**Ошибка без этого исправления:**
```
[Server API] Error History.dll was built for X86 but expected it to be compatible with X64.
System.InvalidOperationException: Failed to load assembly "History.dll".
```

---

### ⚠️ Важно / Important

**Миграция базы данных:**
Если у вас уже есть существующая база данных History с колонкой `WorldID` типа `INTEGER`, вам нужно выполнить миграцию:

**Для SQLite:**
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
    WorldID VARCHAR(100),  -- Изменено с INTEGER на VARCHAR
    Text VARCHAR(500),
    Alternate INTEGER,
    Random INTEGER,
    Direction INTEGER
);

-- Скопировать данные (WorldID преобразуется в строку)
INSERT INTO History_new SELECT 
    Time, Account, Action, XY, Data, Style, Paint, 
    CAST(WorldID AS TEXT), 
    Text, Alternate, Random, Direction 
FROM History;

-- Заменить таблицы
DROP TABLE History;
ALTER TABLE History_new RENAME TO History;
```

**Для MySQL:**
```sql
ALTER TABLE History MODIFY COLUMN WorldID VARCHAR(100);
```

---

### Совместимость / Compatibility

| Версия | Статус |
|--------|--------|
| TShock 5.x (Terraria 1.4.4+ / x64) | ✅ Поддерживается |
| TShock 4.x (Terraria 1.3.x / x86) | ❌ Несовместим (используйте оригинальный плагин) |

---

### Установка / Installation

#### Вариант 1: Использование готового .dll (если собран)

1. Скопируйте `History.dll` в папку `ServerPlugins` вашего TShock сервера
2. Выполните миграцию базы данных (см. выше)
3. Перезапустите сервер

#### Вариант 2: Компиляция из исходников

**Требования:**
- Visual Studio 2019+ или Rider
- .NET Framework 4.5+
- DLL из TShock 5.x (**x64 версии!**):
  - `TShockAPI.dll`
  - `TerrariaServer.exe`
  - `Mono.Data.Sqlite.dll`
  - `MySql.Data.dll`

**Шаги:**
1. Замените файлы в папке `References/` на DLL из вашей версии TShock 5 (**убедитесь, что это x64 версии!**)
2. Откройте `History.sln` в Visual Studio/Rider
3. Build → Build Solution (или F6)
4. Готовый `History.dll` будет в `History/bin/`

**Проверка архитектуры после сборки:**
```bash
# Windows (PowerShell)
dumpbin /headers History.dll | findstr machine

# Linux/Mac
file History.dll

# Должно показать: x64 / AMD64 / PE32+
```

---

### Тестирование / Testing

После установки проверьте:
1. ✅ Сервер запускается без ошибок архитектуры
2. ✅ Команда `/history` работает
3. ✅ При сохранении мира (`/save`) нет ошибок `MissingFieldException`
4. ✅ История действий записывается в базу данных

---

**Автор оригинала:** MarioE  
**Поддержка:** Maintained by Cracker64 & Zaicon  
**Патч для TShock 5:** Исправление совместимости с Terraria 1.4.4+ (x64) (2024)

---

### Благодарности / Credits

- **MarioE** — автор оригинального плагина History
- **Pryaxis Team** — разработка TShock 5
- Сообщество TShock за тестирование и фидбек

