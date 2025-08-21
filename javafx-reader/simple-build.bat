@echo off
chcp 65001 >nul
echo 简单构建脚本...

set JAVAFX_PATH=C:\Users\64621\Downloads\openjfx-24.0.2_windows-x64_bin-sdk\javafx-sdk-24.0.2\lib
set OUTPUT_DIR=dist

echo 清理旧文件...
if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"
if exist "temp" rmdir /s /q "temp"
mkdir "%OUTPUT_DIR%"
mkdir "temp"

echo 检查JavaFX文件...
if not exist "%JAVAFX_PATH%\javafx-base.jar" (
    echo 错误: 找不到 javafx-base.jar
    pause
    exit /b 1
)

echo 编译Main.java...
javac -d temp -cp "%JAVAFX_PATH%\javafx-base.jar;%JAVAFX_PATH%\javafx-controls.jar;%JAVAFX_PATH%\javafx-graphics.jar" src/main/java/com/reader/Main.java

if errorlevel 1 (
    echo 编译失败! 检查错误信息...
    pause
    exit /b 1
)

echo 创建JAR文件...
jar cvfe "%OUTPUT_DIR%\reader.jar" com.reader.Main -C temp .

echo 复制必要的库文件...
mkdir "%OUTPUT_DIR%\lib"
copy "%JAVAFX_PATH%\javafx-base.jar" "%OUTPUT_DIR%\lib\"
copy "%JAVAFX_PATH%\javafx-controls.jar" "%OUTPUT_DIR%\lib\"
copy "%JAVAFX_PATH%\javafx-graphics.jar" "%OUTPUT_DIR%\lib\"

echo 创建启动脚本...
(
echo @echo off
echo java -cp "reader.jar;lib\javafx-base.jar;lib\javafx-controls.jar;lib\javafx-graphics.jar" com.reader.Main
echo pause
) > "%OUTPUT_DIR%\run.bat"

echo 构建完成!
echo 请运行 dist\run.bat
pause