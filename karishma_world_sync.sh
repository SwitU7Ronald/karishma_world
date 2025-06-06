#!/bin/zsh

COMMIT_NAME="Sweetu"

echo
echo "==============================="
echo "🎮 Karishma World Sync"
echo "==============================="
echo
echo "What do you want to do?"
echo
echo "1. Load latest world from online (before playing)"
echo "2. Save your world to online (after playing)"
echo
read "choice?Type 1 or 2: "

echo

echo "-----------------------------"

if [[ "$choice" == "1" ]]; then
    if [[ -n $(git status --porcelain) ]]; then
        echo
        echo "⚠️ Your world files look different than the one online."
        echo "Maybe you forgot to save last time,"
        echo "or maybe a friend played and saved new updates."
        echo
        echo "👉 Press 1 to load the updated world from your friend."
        echo "🔙 Press 2 to cancel and go back."
        echo
        read "pullChoice?Type 1 or 2: "
        echo
        echo "-----------------------------"
        if [[ "$pullChoice" == "1" ]]; then
            echo "📦 Backing up your current world just in case..."
            git stash --quiet

            echo "-----------------------------"
            echo "🌍 Downloading latest world from GitHub..."
            git pull --rebase origin main --quiet

            echo "-----------------------------"
            echo "🔁 Restoring your local work..."
            git stash pop --quiet

            echo "-----------------------------"
            echo "✅ Your world is now updated to the latest version!"

            echo "-----------------------------"
            echo "💬 Last update message from your friend:"
            echo "-----------------------------"
            git log -1 --pretty=format:"%an: %s"
            echo
            echo "-----------------------------"
            echo "🕹️ You're ready to play!"
            echo "-----------------------------"
            exit 0
        else
            echo
            echo "🔙 Cancelled. Returning to main menu."
            echo
            exec "$0"
        fi
    else
        echo "-----------------------------"
        echo "🌍 Checking for updates from GitHub..."
        git pull --rebase origin main --quiet
        echo "-----------------------------"
        echo "✅ You already have the latest world!"
        echo "-----------------------------"
        echo
        echo "💬 Last update message from your friend:"
        echo "-----------------------------"
        git log -1 --pretty=format:"%an: %s"
        echo
        echo "-----------------------------"
        echo "🕹️ Ready to start your Minecraft server!"
        echo "-----------------------------"
        exit 0
    fi

elif [[ "$choice" == "2" ]]; then
    echo
    echo "💾 Saving your updated world for everyone..."
    echo "👤 Your name: $COMMIT_NAME"
    echo
    read "DESCRIPTION?📝 What did you build or change? "
    echo
    if [[ -z "$DESCRIPTION" ]]; then
        DESCRIPTION="(blank description)"
    else
        DESCRIPTION="($DESCRIPTION)"
    fi

    echo "-----------------------------"
    git add .
    git commit -m "Save Latest Karishma World By $COMMIT_NAME - $DESCRIPTION" > /dev/null
    git push origin main --quiet
    echo "✅ Your world is now saved online!"
    echo "-----------------------------"
    echo
    echo "💬 Friends will see this message:"
    echo "-----------------------------"
    echo "\"$COMMIT_NAME: $DESCRIPTION\""
    echo "-----------------------------"
    exit 0

else
    echo
    echo "❌ Please type 1 or 2 to choose."
    echo "-----------------------------"
    exit 1
fi
