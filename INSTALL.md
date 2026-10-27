# 🚀 Быстрый старт / Quick Start

## Для пользователей / For Users

### Шаг 1: Получить исправленный плагин

**Опция A:** Скачать готовый `.dll` (если доступен)
- Перейдите в [Releases](../../releases)
- Скачайте `History.dll`

**Опция B:** Собрать самостоятельно
- Требуется Visual Studio или Rider
- См. инструкцию ниже

---

### Шаг 2: Установить плагин

1. **Остановите** TShock сервер
2. Скопируйте `History.dll` в папку `ServerPlugins/`
3. **Если у вас уже была старая версия History:**
   - Выполните миграцию БД (см. [CHANGELOG.md](CHANGELOG.md))
4. Запустите сервер

---

### Шаг 3: Проверить работу

В консоли сервера должно появиться:
```
History v1.x.x.x (by Maintained by Cracker64 & Zaicon) initiated.
```

Протестируйте команду:
```bash
/history
```

---

## Для разработчиков / For Developers

### Требования

- **Visual Studio 2019+** или **JetBrains Rider**
- **.NET Framework 4.5+**
- **TShock 5.x DLL файлы:**
  - `TShockAPI.dll`
  - `TerrariaServer.exe`
  - `Mono.Data.Sqlite.dll`
  - `MySql.Data.dll`

---

### Сборка проекта

#### 1. Клонировать репозиторий

```bash
git clone https://github.com/YOUR_USERNAME/HistoryFixed.git
cd HistoryFixed
```

#### 2. Обновить референсы

Замените файлы в папке `References/` на DLL из вашей установки TShock 5:

```bash
# Пример путей (Windows)
cp "C:\TShock\TShockAPI.dll" References/
cp "C:\TShock\TerrariaServer.exe" References/
cp "C:\TShock\ServerPlugins\Mono.Data.Sqlite.dll" References/
cp "C:\TShock\ServerPlugins\MySql.Data.dll" References/
```

#### 3. Открыть и собрать проект

**Visual Studio:**
1. Откройте `History.sln`
2. Выберите конфигурацию **Release**
3. Build → Build Solution (`F6`)

**Rider:**
1. Откройте `History.sln`
2. Build → Build Solution

**MSBuild (командная строка):**
```bash
msbuild History.sln /p:Configuration=Release
```

#### 4. Найти готовый .dll

```bash
# Путь к собранному файлу:
History/bin/History.dll
```

---

### Структура изменений

```
HistoryFixed/
├── History/
│   ├── Commands/
│   │   └── SaveCommand.cs          ✅ Исправлено: Main.worldID → Main.ActiveWorldFileData.UniqueId
│   ├── History.cs                  ✅ Исправлено: WorldID INT → VARCHAR(100)
│   └── History.csproj              ✅ Обновлены пути референсов
├── References/                     📦 DLL зависимости (нужно обновить)
├── CHANGELOG.md                    📝 Полный список изменений
├── README.md                       📖 Основная документация
└── INSTALL.md                      🚀 Этот файл
```

---

## ⚠️ Важные замечания

### Миграция базы данных

Если у вас **уже есть история** в старой версии плагина:

1. **Сделайте бэкап БД:**
   ```bash
   # SQLite
   cp tshock/history.sqlite tshock/history.sqlite.backup
   
   # MySQL
   mysqldump -u root -p tshock_db History > history_backup.sql
   ```

2. **Выполните миграцию** (см. SQL-скрипты в [CHANGELOG.md](CHANGELOG.md))

3. **Проверьте работу:**
   ```bash
   /history <игрок> 10
   ```

---

### Совместимость

| Компонент | Минимальная версия |
|-----------|-------------------|
| TShock | 5.0+ |
| Terraria | 1.4.4+ |
| .NET Framework | 4.5+ |
| SQLite | 3.x |
| MySQL | 5.7+ (опционально) |

---

## 🐛 Troubleshooting

### Ошибка: "Could not load file or assembly..."

**Решение:** Убедитесь, что все DLL из TShock 5 находятся в папке сервера:
```
ServerPlugins/
├── History.dll
├── TShockAPI.dll
├── Mono.Data.Sqlite.dll
└── MySql.Data.dll
```

---

### Ошибка: "Field not found: 'Terraria.Main.worldID'"

**Причина:** Вы используете старую версию плагина.

**Решение:** Убедитесь, что вы используете **исправленную** версию (`Main.ActiveWorldFileData.UniqueId`).

Проверьте файл:
```bash
grep -n "ActiveWorldFileData" History/Commands/SaveCommand.cs
```

Должно быть 2 совпадения (строки 40 и 76).

---

### Ошибка при записи в БД: "Data type mismatch"

**Причина:** Колонка `WorldID` в старой БД имеет тип `INTEGER`, а плагин пытается записать строку.

**Решение:** Выполните миграцию БД (см. [CHANGELOG.md](CHANGELOG.md)).

---

## 📞 Поддержка

- 🐛 **Баг-репорты:** [GitHub Issues](../../issues)
- 💬 **Вопросы:** [TShock Discord](https://discord.gg/tshock)
- 📚 **Документация:** [TShock Docs](https://ikebukuro.tshock.co/)

---

**Happy coding!** 🎮
