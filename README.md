# History Plugin для TShock 5.x

> **Исправленная версия** оригинального плагина [MarioE/History](https://github.com/MarioE/History) для совместимости с **TShock 5.x** и **Terraria 1.4.4+**

---

## 📋 Что это?

**History** — плагин для TShock, который логирует все действия игроков на сервере (размещение/удаление блоков, использование предметов) и позволяет:
- 🔍 Просматривать историю изменений
- ⏮️ Откатывать действия игроков (rollback/undo)
- 🗄️ Хранить данные в SQLite или MySQL

---

## ⚠️ Проблема оригинального плагина

Оригинальный плагин выдавал ошибку в TShock 5:

```
System.MissingFieldException: Field not found: 'Terraria.Main.worldID'.
```

**Причина:** В Terraria 1.4.4+ API было изменено:
- `Main.worldID` (int) → `Main.ActiveWorldFileData.UniqueId` (Guid)

---

## ✅ Что исправлено

1. ✅ Замена `Main.worldID` на `Main.ActiveWorldFileData.UniqueId.ToString()`
2. ✅ Изменение типа колонки `WorldID` в БД: `Int32` → `VarChar(100)`
3. ✅ Обновление путей референсов в `.csproj`

Подробнее см. [CHANGELOG.md](CHANGELOG.md)

---

## 📦 Установка

### Вариант 1: Готовый .dll (если доступен)

1. Скачайте `History.dll` из [Releases](../../releases)
2. Скопируйте в папку `ServerPlugins/` вашего TShock сервера
3. Выполните миграцию БД (см. ниже)
4. Перезапустите сервер

### Вариант 2: Компиляция из исходников

#### 🌐 Удалённая компиляция (БЕЗ УСТАНОВОК — рекомендуется):

**GitHub Actions** соберёт DLL за вас автоматически:

```bash
# 1. Инициализируйте репозиторий:
git init && git add . && git commit -m "Fix History for TShock 5.x"

# 2. Создайте репозиторий на https://github.com/new

# 3. Отправьте код:
git remote add origin https://github.com/ВАШ_USERNAME/HistoryFixed.git
git push -u origin main

# 4. GitHub Actions автоматически соберёт DLL!
# Скачайте из: Actions → Build History Plugin → Artifacts
```

📄 **Подробно:** [QUICK_GITHUB_BUILD.md](QUICK_GITHUB_BUILD.md) | [REMOTE_BUILD.md](REMOTE_BUILD.md)

---

#### 💻 Локальная компиляция на macOS:

⚠️ **Требуется Mono!** См. детали в [COMPILE_INSTRUCTIONS.md](COMPILE_INSTRUCTIONS.md)

**Быстрая сборка:**
```bash
# Автоматическая установка Mono и компиляция:
./install-mono-and-build.sh

# ИЛИ вручную:
brew install mono
msbuild History.sln /p:Configuration=Release
```

**Требования:**
- Visual Studio 2019+ / Rider / VS Code + .NET SDK
- .NET Framework 4.5+

**Шаги:**

1. Клонируйте репозиторий:
```bash
git clone https://github.com/YOUR_USERNAME/HistoryFixed.git
cd HistoryFixed
```

2. Замените DLL в папке `References/` на файлы из вашего TShock 5:
   - `TShockAPI.dll`
   - `TerrariaServer.exe`
   - `Mono.Data.Sqlite.dll`
   - `MySql.Data.dll`

3. Откройте `History.sln` и соберите проект:
```bash
# Visual Studio
Build → Build Solution (F6)

# Или через MSBuild
msbuild History.sln /p:Configuration=Release
```

4. Готовый `History.dll` будет в `History/bin/`

---

## 🗄️ Миграция базы данных

Если у вас **уже есть** старая БД History, выполните миграцию:

### SQLite

```sql
-- 1. Создать новую таблицу с правильной структурой
CREATE TABLE History_new (
    Time INTEGER,
    Account VARCHAR(50),
    Action INTEGER,
    XY INTEGER,
    Data INTEGER,
    Style INTEGER,
    Paint INTEGER,
    WorldID VARCHAR(100),  -- Было INTEGER, стало VARCHAR
    Text VARCHAR(500),
    Alternate INTEGER,
    Random INTEGER,
    Direction INTEGER
);

-- 2. Скопировать данные (WorldID преобразуется в строку)
INSERT INTO History_new 
SELECT Time, Account, Action, XY, Data, Style, Paint, 
       CAST(WorldID AS TEXT), 
       Text, Alternate, Random, Direction 
FROM History;

-- 3. Заменить таблицы
DROP TABLE History;
ALTER TABLE History_new RENAME TO History;
```

### MySQL

```sql
ALTER TABLE History MODIFY COLUMN WorldID VARCHAR(100);
```

---

## 🎮 Использование

После установки доступны команды:

```bash
/history <user> <radius>  # Просмотр истории игрока
/rollback <user> <time>   # Откат изменений
/undo                     # Отменить последнее действие
/prune <days>             # Очистить старые записи
```

Подробнее: [оригинальная документация](https://github.com/MarioE/History#usage)

---

## 🐛 Известные проблемы

- [ ] **Миграция WorldID:** Старые записи с числовым WorldID будут преобразованы в строку. Это **необратимо**.
- [ ] **Производительность:** Плагин использует синхронные SQL-запросы (не async).

---

## 🤝 Совместимость

| Платформа | Статус |
|-----------|--------|
| TShock 5.x (Terraria 1.4.4+) | ✅ Работает |
| TShock 4.x (Terraria 1.3.x) | ❌ Несовместим |

---

## 📝 Лицензия

Лицензия оригинального плагина сохранена. См. [LICENSE](LICENSE) (если есть в оригинальном репо).

---

## 🙏 Благодарности

- **MarioE** — автор оригинального плагина
- **Cracker64 & Zaicon** — поддержка оригинала
- **Pryaxis Team** — разработка TShock

---

## 📧 Поддержка

- 🐛 **Нашли баг?** Откройте [Issue](../../issues)
- 💬 **Вопросы?** Спросите в [TShock Discord](https://discord.gg/tshock)
- 🔧 **Pull Request?** Добро пожаловать!

---

**2024** | Патч для TShock 5.x
