@echo off
:: =======================================
:: Karishma World Sync Script (Windows)
:: =======================================

:: IMPORTANT: Change this to your GitHub name or system username
set "COMMIT_NAME=YourName"

echo ==========================================
echo        Karishma World Sync Tool
echo ==========================================
echo.
echo 1. Pull latest world from GitHub
echo 2. Save your world and push to GitHub
echo 3. Exit
echo.

set /p choice=Choose an option (1/2/3): 

if "%choice%"=="1" goto pull
if "%choice%"=="2" goto push
if "%choice%"=="3" goto end

echo Invalid option. Exiting.
goto end

:pull
echo.
echo [INFO] Pulling latest changes from GitHub...
git stash >nul 2>&1
git pull origin main
git stash pop >nul 2>&1
echo [DONE] Latest world pulled successfully.
pause
goto end

:push
echo.
set /p "commitMsg=Enter a description of your changes: "
if "%commitMsg%"=="" (
    set "commitMsg=(blank description)"
)

echo.
echo [INFO] Adding and committing changes...
git add .
git commit -m "Save Latest Karishma World By %COMMIT_NAME% - %commitMsg%"
git push origin main
echo [DONE] World saved and pushed to GitHub.
pause
goto end

:end
exit
