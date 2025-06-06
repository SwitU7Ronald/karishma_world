@echo off
chcp 65001 >nul
title Karishma World Sync - Windows
setlocal EnableDelayedExpansion

:: ========== USER CONFIG ==========
set "COMMIT_NAME=LoTsoxD"
:: =================================

:main_menu
cls
echo ╔══════════════════════════════════════════════════════════════╗
echo ║              🎮 Karishma World Sync - Windows                ║
echo ╠══════════════════════════════════════════════════════════════╣
echo ║ What would you like to do?                                   ║
echo ║                                                              ║
echo ║  1. 📥 Load latest world from GitHub (before playing)         ║
echo ║  2. 💾 Save your world to GitHub (after playing)              ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

set /p choice=👉 Type 1 or 2 and press [Enter]: 
if "%choice%"=="1" goto pull
if "%choice%"=="2" goto push

echo ❌ Invalid option. Please type 1 or 2.
pause
goto main_menu

:pull
cls
echo 🔍 Checking local changes...

:: Detect local changes
set "changes="
for /f %%i in ('git status --porcelain') do (
    set "changes=1"
    goto has_changes
)

:has_changes
:: Check if remote has changes
git fetch origin main >nul
for /f %%i in ('git rev-parse HEAD') do set "LOCAL=%%i"
for /f %%i in ('git rev-parse origin/main') do set "REMOTE=%%i"

if defined changes (
    echo ⚠️  You have local changes not yet saved.
    echo 💡 Maybe you forgot to save, or someone pushed new updates.
    echo.
    echo 👉  Press 1 to pull latest world (your changes will be backed up)
    echo 🔙  Press 2 to cancel and go back
    set /p pullChoice=Your choice: 
    if "%pullChoice%"=="1" (
        echo 📦 Stashing your local changes...
        git stash >nul

        echo 🌍 Pulling latest version from GitHub...
        git pull --rebase origin main >nul

        echo 🔁 Re-applying your local changes...
        git stash pop >nul

        goto show_log
    ) else (
        echo 🔙 Returning to main menu...
        timeout /t 2 >nul
        goto main_menu
    )
) else if not "%LOCAL%"=="%REMOTE%" (
    echo 🔄 A new version is available online!
    echo.
    echo 👉  Press 1 to pull latest world
    echo 🔙  Press 2 to cancel and go back
    set /p updateChoice=Your choice: 
    if "%updateChoice%"=="1" (
        git pull --rebase origin main >nul
        goto show_log
    ) else (
        echo 🔙 Returning to main menu...
        timeout /t 2 >nul
        goto main_menu
    )
) else (
    echo ✅ You already have the latest world!
    goto show_log
)

:show_log
echo -----------------------------
echo 💬 Last update message from your friend:
git log -1 --pretty=format:"%%an: %%s"
echo -----------------------------
echo 🕹️  You’re ready to play Minecraft!
pause
goto main_menu

:push
cls
echo 💾 Saving your updated world for everyone...
echo 👤 Your name: %COMMIT_NAME%
echo.

set /p "DESCRIPTION=📝 What did you build or change? "
if "%DESCRIPTION%"=="" set "DESCRIPTION=blank description"
set "DESCRIPTION=(%DESCRIPTION%)"

echo 📦 Committing your changes...
git add .
git commit -m "Save Latest Karishma World By %COMMIT_NAME% - %DESCRIPTION%" >nul
git push origin main >nul

echo ✅ Your world is now saved online!
echo 💬 Friends will see this message:
echo "%COMMIT_NAME%: %DESCRIPTION%"
pause
goto main_menu
