@echo off
chcp 65001 >nul
echo 检查项目结构...
echo.

echo 当前目录: %CD%
echo.

echo 查找Java文件:
dir /s *.java
echo.

echo 查找JavaFX SDK:
set JAVAFX_PATH=C:\Users\64621\Downloads\openjfx-24.0.2_windows-x64_bin-sdk\javafx-sdk-24.0.2\lib
if exist "%JAVAFX_PATH%" (
    echo JavaFX SDK找到!
    dir "%JAVAFX_PATH%\*.jar"
) else (
    echo JavaFX SDK未找到!
)

echo.
pause