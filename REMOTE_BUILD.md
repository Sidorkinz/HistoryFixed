# 🚀 Удалённая компиляция без установки на Mac

Вам **не нужно** устанавливать Mono, Docker или что-либо ещё!

---

## ✅ Вариант 1: GitHub Actions (РЕКОМЕНДУЕТСЯ)

### Шаг 1: Создайте GitHub репозиторий

```bash
cd /Users/sidorkinz/.cline/data/workspaces/chat/HistoryFixed

# Инициализируйте Git (если ещё не сделано)
git init

# Добавьте все файлы
git add .
git commit -m "Fix History plugin for TShock 5.x"

# Создайте репозиторий на GitHub.com и добавьте remote:
git remote add origin https://github.com/YOUR_USERNAME/HistoryFixed.git
git branch -M main
git push -u origin main
```

### Шаг 2: GitHub Actions автоматически соберёт DLL

После push'а в GitHub:
1. Зайдите в ваш репозиторий на GitHub.com
2. Перейдите во вкладку **Actions**
3. Workflow начнёт работать автоматически
4. После завершения (2-3 минуты) скачайте **History-Plugin.zip** в разделе Artifacts

**Готовый DLL** будет внутри архива!

---

## ⚡ Вариант 2: Ручной запуск через GitHub Actions

Если не хотите коммитить:

1. Создайте репозиторий на GitHub
2. Загрузите файлы через веб-интерфейс
3. Перейдите в **Actions** → **Build History Plugin** → **Run workflow**
4. Скачайте собранный DLL из Artifacts

---

## 🌐 Вариант 3: AppVeyor (альтернатива GitHub Actions)

1. Зарегистрируйтесь на https://ci.appveyor.com (бесплатно для публичных проектов)
2. Подключите ваш GitHub репозиторий
3. AppVeyor автоматически соберёт проект
4. Скачайте DLL из Artifacts

**Файл конфигурации:** `.appveyor.yml` (уже создан в проекте)

---

## 🔧 Вариант 4: Replit (онлайн IDE)

1. Зайдите на https://replit.com
2. Создайте новый Repl (язык: C#)
3. Загрузите файлы проекта
4. Установите Mono: `sudo apt-get install mono-complete`
5. Запустите: `msbuild History.sln /p:Configuration=Release`
6. Скачайте DLL из `History/bin/Release/`

---

## 🐳 Вариант 5: Online Docker (без установки Docker)

### Play with Docker (бесплатно 4 часа)

1. Зайдите на https://labs.play-with-docker.com
2. Создайте новую сессию
3. Загрузите проект:
```bash
git clone https://github.com/YOUR_USERNAME/HistoryFixed.git
cd HistoryFixed
docker build -t history-build .
docker create --name history-container history-build
docker cp history-container:/build/History/bin/Release/History.dll ./History.dll
```
4. Скачайте `History.dll` через веб-интерфейс

---

## 🖥️ Вариант 6: Удалённый Windows VPS (временный)

Создайте бесплатную временную Windows VM:

- **Azure Free Tier**: 750 часов бесплатно в месяц
- **AWS Free Tier**: 750 часов бесплатно первый год
- **Google Cloud Free Tier**: $300 кредитов на 90 дней

**После подключения:**
```powershell
# Установите Git
winget install Git.Git

# Клонируйте проект
git clone https://github.com/YOUR_USERNAME/HistoryFixed.git
cd HistoryFixed

# Установите Visual Studio Build Tools
winget install Microsoft.VisualStudio.2022.BuildTools

# Соберите проект
msbuild History.sln /p:Configuration=Release
```

---

## 📊 Сравнение вариантов

| Метод | Скорость | Сложность | Бесплатно? |
|-------|----------|-----------|------------|
| **GitHub Actions** | ⚡⚡⚡ 2-3 мин | 🟢 Легко | ✅ Да |
| AppVeyor | ⚡⚡ 3-5 мин | 🟡 Средне | ✅ Да |
| Replit | ⚡⚡ 3-5 мин | 🟡 Средне | ✅ Да |
| Play with Docker | ⚡ 5-10 мин | 🔴 Сложно | ✅ Да (4ч) |
| Cloud VPS | ⚡⚡⚡ 1-2 мин | 🔴 Сложно | ⚠️ Кредиты |

---

## 🎯 Моя рекомендация: GitHub Actions

**Преимущества:**
- ✅ Полностью бесплатно
- ✅ Автоматическая сборка при каждом коммите
- ✅ Можно запускать вручную
- ✅ Хранит историю сборок
- ✅ Можно создавать Releases с готовыми DLL
- ✅ Никаких установок на вашей машине

**Workflow уже создан:** `.github/workflows/build.yml`

---

## 📝 Пошаговая инструкция для GitHub Actions

### 1. Инициализируйте Git репозиторий:

```bash
cd /Users/sidorkinz/.cline/data/workspaces/chat/HistoryFixed
git init
git add .
git commit -m "Fix History plugin for TShock 5.x"
```

### 2. Создайте репозиторий на GitHub:

- Зайдите на https://github.com/new
- Введите название: `HistoryFixed`
- Выберите Public (для бесплатных Actions)
- НЕ создавайте README, .gitignore или LICENSE
- Нажмите **Create repository**

### 3. Добавьте remote и отправьте код:

```bash
git remote add origin https://github.com/ВАШ_USERNAME/HistoryFixed.git
git branch -M main
git push -u origin main
```

### 4. GitHub Actions запустится автоматически!

- Зайдите в **Actions** вкладку
- Увидите работающий workflow "Build History Plugin"
- Дождитесь завершения (зелёная галочка ✅)

### 5. Скачайте готовый DLL:

- Нажмите на завершённый workflow
- Прокрутите вниз до раздела **Artifacts**
- Скачайте **History-Plugin.zip**
- Распакуйте → внутри готовый `History.dll`

---

## ⏱️ Сколько времени займёт?

- Настройка GitHub репозитория: **2 минуты**
- Компиляция через Actions: **2-3 минуты**
- **Итого: ~5 минут** от начала до готового DLL

---

## 🔄 Бонус: Автоматические релизы

Чтобы создавать релизы с готовыми DLL автоматически:

```bash
# Создайте тег версии:
git tag v1.0.0
git push origin v1.0.0

# GitHub Actions автоматически:
# 1. Соберёт проект
# 2. Создаст Release v1.0.0
# 3. Прикрепит History.dll к релизу
```

Пользователи смогут скачивать готовый DLL из Releases!

---

## 💡 Какой способ выбрать?

**Если есть GitHub аккаунт** → GitHub Actions (самый простой)  
**Если нужно один раз быстро** → Replit (без регистрации)  
**Если проект приватный** → AppVeyor Free или Azure Free Tier  
**Если нужны регулярные сборки** → GitHub Actions + автоматические релизы

---

**Хотите, чтобы я помог настроить GitHub репозиторий прямо сейчас?** 🚀
