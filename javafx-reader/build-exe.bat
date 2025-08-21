@echo off
chcp 65001 >nul
echo 开始构建JavaFX阅读器...

REM 设置JavaFX SDK路径
set JAVAFX_PATH=C:\Users\64621\Downloads\openjfx-24.0.2_windows-x64_bin-sdk\javafx-sdk-24.0.2\lib

REM 检查JavaFX路径是否存在
if not exist "%JAVAFX_PATH%" (
    echo 错误: JavaFX SDK路径不存在!
    echo 请检查路径: %JAVAFX_PATH%
    pause
    exit /b 1
)

echo 检测到JavaFX路径: %JAVAFX_PATH%

REM 设置输出目录
set OUTPUT_DIR=dist

REM 清理输出目录
if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"
mkdir "%OUTPUT_DIR%"

REM 清理临时目录
if exist "temp" rmdir /s /q "temp"
mkdir "temp"

REM 编译Java文件（使用正确的classpath分隔符 ; ）
echo 正在编译源代码...
javac -d temp -cp "%JAVAFX_PATH%\javafx-controls.jar;%JAVAFX_PATH%\javafx-fxml.jar;%JAVAFX_PATH%\javafx-web.jar;%JAVAFX_PATH%\javafx-graphics.jar;%JAVAFX_PATH%\javafx-base.jar" src/main/java/com/reader/*.java

if errorlevel 1 (
    echo 编译失败! 检查详细错误...
    pause
    exit /b 1
)

REM 创建可执行JAR
echo 创建JAR文件...
jar cvfe "%OUTPUT_DIR%\reader.jar" com.reader.Main -C temp .

if errorlevel 1 (
    echo JAR创建失败!
    pause
    exit /b 1
)

REM 复制JavaFX库文件
echo 复制JavaFX库文件...
if not exist "%OUTPUT_DIR%\lib" mkdir "%OUTPUT_DIR%\lib"

REM 复制所有必要的JavaFX JAR文件
copy "%JAVAFX_PATH%\javafx-base.jar" "%OUTPUT_DIR%\lib\"
copy "%JAVAFX_PATH%\javafx-controls.jar" "%OUTPUT_DIR%\lib\"
copy "%JAVAFX_PATH%\javafx-fxml.jar" "%OUTPUT_DIR%\lib\"
copy "%JAVAFX_PATH%\javafx-graphics.jar" "%OUTPUT_DIR%\lib\"
copy "%JAVAFX_PATH%\javafx-web.jar" "%OUTPUT_DIR%\lib\"

REM 复制资源文件
echo 复制资源文件...
if exist "src\main\resources" (
    xcopy /E /I /Y "src\main\resources" "%OUTPUT_DIR%\resources\"
) else if exist "resources" (
    xcopy /E /I /Y "resources" "%OUTPUT_DIR%\resources\"
)

REM 创建启动脚本
echo 创建启动脚本...
(
echo @echo off
echo chcp 65001 ^>nul
echo title JavaFX阅读器
echo.
echo setlocal enabledelayedexpansion
echo.
echo REM 设置工作目录
echo set "WORKDIR=%%~dp0"
echo cd /d "!WORKDIR!"
echo.
echo REM 设置classpath
echo set "CLASSPATH=reader.jar"
echo set "CLASSPATH=!CLASSPATH!;lib\javafx-base.jar"
echo set "CLASSPATH=!CLASSPATH!;lib\javafx-controls.jar"
echo set "CLASSPATH=!CLASSPATH!;lib\javafx-fxml.jar"
echo set "CLASSPATH=!CLASSPATH!;lib\javafx-graphics.jar"
echo set "CLASSPATH=!CLASSPATH!;lib\javafx-web.jar"
echo.
echo REM 检查Java是否存在
echo where java ^>nul 2^>^&1
echo if errorlevel 1 (
echo     echo 错误: 未找到Java运行时环境!
echo     echo 请安装Java 17或更高版本
echo     pause
echo     exit /b 1
echo )
echo.
echo REM 启动程序
echo echo 正在启动JavaFX阅读器...
echo java -cp "!CLASSPATH!" com.reader.Main
echo.
echo if errorlevel 1 (
echo     echo 启动失败!
echo     echo 错误代码: !errorlevel!
echo     pause
echo )
echo pause
) > "%OUTPUT_DIR%\run.bat"

echo.
echo 构建成功完成！
echo 程序位于: %OUTPUT_DIR% 文件夹
echo.
echo 运行方法:
echo 1. 进入 dist 文件夹
echo 2. 双击 run.bat 启动程序
echo.
pause