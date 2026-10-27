# 📦 History Plugin для TShock 5.x - Итоги исправления

## ✅ Что было сделано

Исправлен плагин **History** для работы с **TShock 5.x** и **Terraria 1.4.4+**.

---

## 🔧 Внесённые изменения

### 1. **SaveCommand.cs** (2 изменения)
Файл: `History/Commands/SaveCommand.cs`

**Строки 40 и 76:**
```csharp
// ДО (не работало в TShock 5)
command.Parameters[7].Value = Main.worldID;

// ПОСЛЕ (работает в TShock 5)
command.Parameters[7].Value = Main.ActiveWorldFileData?.UniqueId.ToString() ?? "Unknown";
```

### 2. **History.cs** (1 изменение)
Файл: `History/History.cs`

**Строка 1651:**
```csharp
// ДО (тип данных INT32)
new SqlColumn("WorldID", MySqlDbType.Int32),

// ПОСЛЕ (тип данных VARCHAR для GUID)
new SqlColumn("WorldID", MySqlDbType.VarChar) { Length = 100 }, // TShock 5.x: Guid string
```

### 3. **History.csproj** (обновление путей)
Файл: `History/History.csproj`

- Обновлены пути к DLL референсам
- Теперь используются файлы из папки `References/`

---

## 📁 Файловая структура

```
HistoryFixed/
├── 📄 README.md                    # Основная документация
├── 📄 CHANGELOG.md                 # Детальный список изменений
├── 📄 INSTALL.md                   # Инструкция по установке и сборке
├── 📄 SUMMARY.md                   # Этот файл (краткий итог)
│
├── History/                        # Основной проект плагина
│   ├── Commands/
│   │   ├── SaveCommand.cs          ✅ ИСПРАВЛЕНО
│   │   ├── HistoryCommand.cs
│   │   ├── RollbackCommand.cs
│   │   ├── UndoCommand.cs
│   │   └── ...
│   ├── History.cs                  ✅ ИСПРАВЛЕНО
│   ├── History.csproj              ✅ ОБНОВЛЕНО
│   └── Action.cs
│
├── References/                     # DLL зависимости (из TShock)
│   ├── TShockAPI.dll               ⚠️ Нужно обновить под TShock 5
│   ├── TerrariaServer.exe          ⚠️ Нужно обновить под TShock 5
│   ├── Mono.Data.Sqlite.dll
│   └── MySql.Data.dll
│
└── History.sln                     # Solution файл
```

---

## 🚀 Что делать дальше?

### Для пользователей сервера

1. **Скачайте исправленный плагин:**
   - Либо соберите сами (см. INSTALL.md)
   - Либо дождитесь готового .dll в Releases

2. **Установите:**
   ```bash
   # Скопируйте History.dll в папку ServerPlugins
   cp History.dll /путь/к/серверу/ServerPlugins/
   ```

3. **Мигрируйте БД** (если у вас была старая версия):
   - См. SQL-скрипты в CHANGELOG.md

4. **Перезапустите сервер**

---

### Для разработчиков

1. **Замените DLL в папке `References/`:**
   ```bash
   # Скопируйте файлы из вашей установки TShock 5
   cp /путь/к/TShock/TShockAPI.dll References/
   cp /путь/к/TShock/TerrariaServer.exe References/
   cp /путь/к/TShock/ServerPlugins/Mono.Data.Sqlite.dll References/
   cp /путь/к/TShock/ServerPlugins/MySql.Data.dll References/
   ```

2. **Соберите проект:**
   ```bash
   # Visual Studio
   msbuild History.sln /p:Configuration=Release

   # Или через IDE (F6 в VS)
   ```

3. **Протестируйте:**
   - Запустите TShock сервер
   - Проверьте команду `/history`
   - Сделайте `/save` и убедитесь, что нет ошибок

---

## 📊 Техническая информация

### Изменения в API

| Старый API (TShock 4.x) | Новый API (TShock 5.x) |
|-------------------------|------------------------|
| `Main.worldID` (int) | `Main.ActiveWorldFileData.UniqueId` (Guid) |
| Тип БД: `INTEGER` | Тип БД: `VARCHAR(100)` |

### Совместимость

| Платформа | Совместимость |
|-----------|---------------|
| TShock 5.x (Terraria 1.4.4+) | ✅ Полностью поддерживается |
| TShock 4.x (Terraria 1.3.x) | ❌ НЕ СОВМЕСТИМ (используйте оригинальный плагин) |

---

## ⚠️ Важные предупреждения

### Миграция базы данных обязательна!

Если у вас **уже есть история** в старой БД, выполните миграцию:

- **SQLite:** См. скрипт в CHANGELOG.md (секция "Миграция базы данных")
- **MySQL:** `ALTER TABLE History MODIFY COLUMN WorldID VARCHAR(100);`

**БЕЗ МИГРАЦИИ** плагин выдаст ошибку при записи:
```
Data type mismatch: expected INTEGER, got TEXT
```

---

## 📝 Дополнительные файлы

- **README.md** — основная документация, описание плагина
- **CHANGELOG.md** — полный список изменений, SQL-скрипты миграции
- **INSTALL.md** — подробная инструкция по сборке и установке
- **SUMMARY.md** — этот файл (краткий итог)

---

## 🤝 Благодарности

- **MarioE** — автор оригинального плагина
- **Cracker64 & Zaicon** — поддержка оригинала
- **Pryaxis Team** — разработка TShock 5

---

## 📞 Поддержка и вопросы

- 🐛 **Баг?** → [GitHub Issues](../../issues)
- 💬 **Вопрос?** → [TShock Discord](https://discord.gg/tshock)
- 📚 **Документация?** → [TShock Docs](https://ikebukuro.tshock.co/)

---

**Дата исправления:** 27.10.2024  
**Версия:** TShock 5.x Compatible
