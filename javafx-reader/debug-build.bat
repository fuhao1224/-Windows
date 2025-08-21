@echo off
chcp 65001 >nul
echo 调试模式构建...

set JAVAFX_PATH=C:\Users\64621\Downloads\openjfx-24.0.2_windows-x64_bin-sdk\javafx-sdk-24.0.2\lib
set OUTPUT_DIR=dist

echo 当前目录: %CD%
echo JavaFX路径: %JAVAFX_PATH%
echo.

echo 检查JavaFX JAR文件...
if exist "%JAVAFX_PATH%\javafx-base.jar" echo ✓ javafx-base.jar 存在
if exist "%JAVAFX_PATH%\javafx-controls.jar" echo ✓ javafx-controls.jar 存在
if exist "%JAVAFX_PATH%\javafx-fxml.jar" echo ✓ javafx-fxml.jar 存在
if exist "%JAVAFX_PATH%\javafx-graphics.jar" echo ✓ javafx-graphics.jar 存在
if exist "%JAVAFX_PATH%\javafx-web.jar" echo ✓ javafx-web.jar 存在
echo.

echo 编译测试...
javac -version
echo.

REM 先尝试编译一个简单的测试文件
echo 创建测试文件...
(
echo import javafx.application.Application;
echo import javafx.scene.Scene;
echo import javafx.scene.control.Label;
echo import javafx.scene.layout.StackPane;
echo import javafx.stage.Stage;
echo.
echo public class Test extends Application {
echo     public void start(Stage stage) {
echo         Label label = new Label("测试成功!");
echo         Scene scene = new Scene(new StackPane(label), 300, 200);
echo         stage.setScene(scene);
echo         stage.show();
echo     }
echo
echo     public static void main(String[] args) {
echo         launch(args);
echo     }
echo }
) > Test.java

echo 编译测试文件...
javac -cp "%JAVAFX_PATH%\javafx-controls.jar;%JAVAFX_PATH%\javafx-graphics.jar;%JAVAFX_PATH%\javafx-base.jar" Test.java

if errorlevel 1 (
    echo 测试编译失败! 检查JavaFX路径
    del Test.java
    pause
    exit /b 1
)

echo 测试编译成功!
del Test.java Test.class

echo 开始编译主程序...
javac -d temp -cp "%JAVAFX_PATH%\javafx-controls.jar;%JAVAFX_PATH%\javafx-fxml.jar;%JAVAFX_PATH%\javafx-web.jar;%JAVAFX_PATH%\javafx-graphics.jar;%JAVAFX_PATH%\javafx-base.jar" src/main/java/com/reader/*.java

if errorlevel 1 (
    echo 主程序编译失败!
    pause
    exit /b 1
)

echo 编译成功!
mkdir %OUTPUT_DIR%
jar cvfe %OUTPUT_DIR%\reader.jar com.reader.Main -C temp .

echo 复制库文件...
mkdir %OUTPUT_DIR%\lib
copy "%JAVAFX_PATH%\*.jar" "%OUTPUT_DIR%\lib\"

echo 构建完成!
pause