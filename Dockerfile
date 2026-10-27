# Dockerfile для компиляции History плагина
FROM mono:latest

WORKDIR /build

# Копируем проект
COPY . .

# Компилируем
RUN msbuild History.sln /p:Configuration=Release /p:Platform="Any CPU"

# Готовый DLL будет в History/bin/History.dll
CMD ["bash"]
