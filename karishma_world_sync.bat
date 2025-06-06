@echo off
setlocal enabledelayedexpansion

set "COMMIT_NAME=Lotso"

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
set /p choice="Type 1 or 2: "

echo.
echo -----------------------------

if "%choice%"=="1" (
    rem Check if there are uncommitted changes
    git status --porcelain > temp_status.txt
    set /p changes=<temp_status.txt
    del temp_status.txt

    if not "!changes!"=="" (
        echo.
        echo ⚠️ Your world files look different than the one online.
        echo Maybe you forgot to save last time,
        echo or maybe a friend played and saved new updates.
        echo.
        echo 👉 Press 1 to load the updated world from your friend.
        echo 🔙 Press 2 to cancel and go back.
        echo.
        set /p pullChoice="Type 1 or 2: "
        echo.
        echo -----------------------------

        if "%pullChoice%"=="1" (
            echo 📦 Backing up your current world just in case...
            git stash --quiet

            echo -----------------------------
            echo 🌍 Downloading latest world from GitHub...
            git pull --rebase origin main --quiet

            echo -----------------------------
            echo 🔁 Restoring your local work...
            git stash pop --quiet

            echo -----------------------------
            echo ✅ Your world is now updated to the latest version!

            echo -----------------------------
            echo 💬 Last update message from your friend:
            echo -----------------------------
            for /f "delims=" %%i in ('git log -1 --pretty=format:"%%an: %%s"') do echo %%i
            echo.
            echo -----------------------------
            echo 🕹️ You're ready to play!
            echo -----------------------------
            goto :EOF
        ) else (
            echo.
            echo 🔙 Cancelled. Returning to main menu.
            echo.
            call "%~f0"
            goto :EOF
        )
    ) else (
        echo -----------------------------
        echo 🌍 Checking for updates from GitHub...
        git pull --rebase origin main --quiet
        echo -----------------------------
        echo ✅ You already have the latest world!
        echo -----------------------------
        echo.
        echo 💬 Last update message from your friend:
        echo -----------------------------
        for /f "delims=" %%i in ('git log -1 --pretty=format:"%%an: %%s"') do echo %%i
        echo.
        echo -----------------------------
        echo 🕹️ Ready to start your Minecraft server!
        echo -----------------------------
        goto :EOF
    )
) else if "%choice%"=="2" (
    echo.
    echo 💾 Saving your updated world for everyone...
    echo 👤 Your name: %COMMIT_NAME%
    echo.
    set /p DESCRIPTION=📝 What did you build or change? 

    if "%DESCRIPTION%"=="" (
        set DESCRIPTION=(blank description)
    ) else (
        set DESCRIPTION=(%DESCRIPTION%)
    )

    echo -----------------------------
    git add .
    git commit -m "Save Latest Karishma World By %COMMIT_NAME% - %DESCRIPTION%" > nul
    git push origin main --quiet
    echo ✅ Your world is now saved online!
    echo -----------------------------
    echo.
    echo 💬 Friends will see this message:
    echo -----------------------------
    echo "%COMMIT_NAME%: %DESCRIPTION%"
    echo -----------------------------
    goto :EOF
) else (
    echo.
    echo ❌ Please type 1 or 2 to choose.
    echo -----------------------------
    exit /b 1
)
