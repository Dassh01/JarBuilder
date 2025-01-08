@echo off
setlocal
REM get main file from users
set /p userInput=Enter the full path to the main class name (e.g., com.example.Main):
REM Set relative directories as variables
set BUILD_DIR=build
set SRC_DIR=src\java
set OUT_DIR=out
set MAIN_CLASS=%userInput%
set MANIFEST_FILE=%OUT_DIR%/manifest.txt

REM Create the output and build directories if they don't exist
if not exist %OUT_DIR% (
    echo NO OUTPUT DIRECTORY FOUND. CREATING OUTPUT DIRECTORY.
    mkdir %OUT_DIR%
)

if not exist %BUILD_DIR% (
    echo NO BUILD DIRECTORY FOUND. CREATING BUILD DIRECTORY.
    mkdir %BUILD_DIR%
)

REM Create the manifest file
echo Main-Class: %MAIN_CLASS% > %MANIFEST_FILE%

REM Compilation time!
echo COMPILING.
for /r %SRC_DIR% %%f in (*.java) do (
    echo COMPILING %%f
    javac -sourcepath %SRC_DIR% -d %OUT_DIR% "%%f"
)

REM Verify compilation success
if %errorlevel% neq 0 (
    echo COMPILATION FAILED.
    pause
    exit /b %errorlevel%
)

REM Create the JAR file with the manifest
echo CREATING JAR FILE.
REM Ask to create jar file with parameters c,f,m
REM c = create a new jar file (duh)
REM f = specify filename of jar being created
REM m = include a manifest file
jar cfm %BUILD_DIR%\ZooLights.jar %MANIFEST_FILE% -C %OUT_DIR% .

REM Verify JAR creation success
if %errorlevel% neq 0 (
    echo JAR CREATION FAILED.
    pause
    exit /b %errorlevel%
)

REM Run the JAR file
echo RUNNING JAR FILE.
java -jar %BUILD_DIR%\ZooLights.jar

REM Hang the program in case we error
pause

endlocal