@echo off
setlocal enabledelayedexpansion

set "COMMIT_NAME=Sweetu"

echo.
echo ===============================
echo 🎮 Karishma World Sync
echo ===============================
echo.
echo What do you want to do?
echo.
echo 1. Load latest world from online (before playing)
echo 2. Save your world to online (after playing)
echo.
set /p choice=Type 1 or 2: 
echo.
echo -----------------------------

if "%choice%"=="1" (
    git status --porcelain >nul 2>&1
    if errorlevel 1 (
        echo ❌ Git error. Make sure you're in a Git repo.
        pause
        exit /b
    )

    set CHANGES=
    for /f "delims=" %%i in ('git status --porcelain') do set "CHANGES=1"

    if defined CHANGES (
        echo ⚠️ Your world files look different than the one online.
        echo Maybe you forgot to save last time,
        echo or maybe a friend played and saved new updates.
        echo.
        echo 👉 Press 1 to load the updated world from your friend.
        echo 🔙 Press 2 to cancel and go back.
        echo.
        set /p pullChoice=Type 1 or 2: 
        echo.
        echo -----------------------------

        if "%pullChoice%"=="1" (
            echo 📦 Backing up your current world just in case...
            git stash >nul

            echo -----------------------------
            echo 🌍 Downloading latest world from GitHub...
            git pull --rebase origin main >nul

            echo -----------------------------
            echo 🔁 Restoring your local work...
            git stash pop >nul

            echo -----------------------------
            echo ✅ Your world is now updated to the latest version!
            echo -----------------------------
            echo 💬 Last update message from your friend:
            echo -----------------------------
            git log -1 --pretty=format:"%%an: %%s"
            echo.
            echo -----------------------------
            echo 🕹️ You're ready to play!
            echo -----------------------------
        ) else (
            echo.
            echo 🔙 Cancelled. Returning to main menu.
            echo.
            call "%~f0"
        )
    ) else (
        echo -----------------------------
        echo 🌍 Checking for updates from GitHub...
        git pull --rebase origin main >nul
        echo -----------------------------
        echo ✅ You already have the latest world!
        echo -----------------------------
        echo.
        echo 💬 Last update message from your friend:
        echo -----------------------------
        git log -1 --pretty=format:"%%an: %%s"
        echo.
        echo -----------------------------
        echo 🕹️ Ready to start your Minecraft server!
        echo -----------------------------
    )
    exit /b
)

if "%choice%"=="2" (
    echo.
    echo 💾 Saving your updated world for everyone...
    echo 👤 Your name: %COMMIT_NAME%
    echo.
    set /p DESCRIPTION=📝 What did you build or change? 

    if "%DESCRIPTION%"=="" (
        set "DESCRIPTION=()"
    ) else (
        set "DESCRIPTION=(%DESCRIPTION%)"
    )

    echo -----------------------------
    git add .
    git commit -m "Save Latest Karishma World By %COMMIT_NAME% - %DESCRIPTION%" >nul
    git push origin main >nul
    echo ✅ Your world is now saved online!
    echo -----------------------------
    echo.
    echo 💬 Friends will see this message:
    echo -----------------------------
    echo "%COMMIT_NAME%: %DESCRIPTION%"
    echo -----------------------------
    exit /b
)

echo.
echo ❌ Please type 1 or 2 to choose.
echo -----------------------------
exit /b

