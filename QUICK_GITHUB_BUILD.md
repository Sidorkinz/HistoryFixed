# ⚡ Быстрая компиляция через GitHub (5 минут)

Вам не нужно ничего устанавливать на Mac! GitHub соберёт DLL за вас.

---

## Шаг 1: Инициализируйте Git (30 секунд)

```bash
cd /Users/sidorkinz/.cline/data/workspaces/chat/HistoryFixed
git init
git add .
git commit -m "Fix History plugin for TShock 5.x"
```

---

## Шаг 2: Создайте репозиторий на GitHub (1 минута)

1. Зайдите на https://github.com/new
2. Введите название: **HistoryFixed**
3. Выберите **Public** (обязательно для бесплатных Actions)
4. НЕ создавайте README, .gitignore или LICENSE
5. Нажмите **Create repository**

---

## Шаг 3: Отправьте код (30 секунд)

GitHub покажет команды, выполните их:

```bash
git remote add origin https://github.com/ВАШ_USERNAME/HistoryFixed.git
git branch -M main
git push -u origin main
```

---

## Шаг 4: Дождитесь сборки (2-3 минуты)

1. На странице репозитория зайдите во вкладку **Actions**
2. Увидите запущенный workflow "Build History Plugin"
3. Дождитесь зелёной галочки ✅

---

## Шаг 5: Скачайте готовый DLL (10 секунд)

1. Нажмите на завершённый workflow
2. Прокрутите вниз до раздела **Artifacts**
3. Скачайте **History-Plugin.zip**
4. Распакуйте → внутри готовый **History.dll**

---

## ✅ Готово!

Теперь:
1. Скопируйте `History.dll` в `ServerPlugins/` вашего TShock сервера
2. Выполните SQL миграцию (см. CHANGELOG.md)
3. Перезапустите сервер

---

## 🔄 Бонус: Автоматические релизы

Чтобы создавать релизы с готовыми DLL:

```bash
git tag v1.0.0
git push origin v1.0.0
```

GitHub Actions автоматически создаст Release с прикреплённым DLL!

---

## ❓ Проблемы?

**Actions не запустились?**
- Проверьте, что репозиторий Public
- Зайдите в Settings → Actions → General → Allow all actions

**Workflow упал с ошибкой?**
- Откройте лог workflow и найдите красную строку
- Чаще всего это проблема с путями к DLL в References/

**Не можете найти Artifacts?**
- Artifacts появляются только после успешной сборки
- Проверьте, что workflow завершился с зелёной галочкой

---

**Нужна помощь?** См. полную документацию в REMOTE_BUILD.md
