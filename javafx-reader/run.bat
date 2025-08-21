@echo off
chcp 65001 >nul
echo 正在启动JavaFX阅读器...

REM 设置JavaFX SDK路径（根据你的实际路径修改）
set JAVAFX_PATH=C:\Users\64621\Downloads\openjfx-24.0.2_windows-x64_bin-sdk\javafx-sdk-24.0.2\lib

REM 编译源代码
if not exist "bin" mkdir bin
javac -d bin --module-path "%JAVAFX_PATH%" --add-modules javafx.controls,javafx.fxml,javafx.web src/com/reader/*.java

REM 运行程序
java --module-path "%JAVAFX_PATH%" --add-modules javafx.controls,javafx.fxml,javafx.web -cp bin com.reader.Main

pause