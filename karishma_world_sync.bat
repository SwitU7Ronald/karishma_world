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
echo 🔍 Checking for local changes...

:: Detect uncommitted changes
set "changes="
for /f %%i in ('git status --porcelain') do (
    set "changes=1"
    goto check_remote
)

:check_remote
:: Fetch the latest from origin
git fetch origin main >nul

:: Get commit hashes
for /f %%i in ('git rev-parse HEAD') do set "LOCAL=%%i"
for /f %%i in ('git rev-parse origin/main') do set "REMOTE=%%i"

:: CASE 1: You have local uncommitted changes
if defined changes (
    echo ⚠️  You have unsaved local changes.
    echo 💡 Maybe you forgot to save, or someone else updated the world.
    echo.
    echo 👉  Press 1 to pull the latest world (your changes will be backed up)
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
)

:: CASE 2: Remote is newer
if not "%LOCAL%"=="%REMOTE%" (
    echo 🔄 A newer version of the world is available on GitHub!
    echo.
    echo 👉  Press 1 to pull and update your world
    echo 🔙  Press 2 to cancel and go back
    set /p remoteChoice=Your choice: 
    if "%remoteChoice%"=="1" (
        echo 🌍 Pulling latest world from GitHub...
        git pull --rebase origin main >nul
        goto show_log
    ) else (
        echo 🔙 Returning to main menu...
        timeout /t 2 >nul
        goto main_menu
    )
)

:: CASE 3: Already up-to-date
echo ✅ Your world is already up to date!
echo -----------------------------
echo 💬 Last update message from your friend:
git log -1 --pretty=format:"%%an: %%s"
echo -----------------------------
echo.
echo 👉  Press 1 to go back to main menu
echo 🔚  Press 2 to exit
set /p upToDateChoice=Your choice: 
if "%upToDateChoice%"=="1" (
    goto main_menu
) else (
    exit /b
)

:show_log
echo -----------------------------
echo ✅ World updated successfully!
echo 💬 Last update message from your friend:
git log -1 --pretty=format:"%%an: %%s"
echo -----------------------------
echo 🕹️  You're ready to play!
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
