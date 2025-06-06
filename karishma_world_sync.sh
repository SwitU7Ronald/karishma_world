#!/bin/bash

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
read -rp "Type 1 or 2: " choice

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
        read -rp "Type 1 or 2: " pullChoice
        echo
        if [[ "$pullChoice" == "1" ]]; then
            echo "📦 Backing up your current world just in case..."
            git stash --quiet

            echo
            echo "🌍 Downloading latest world from GitHub..."
            echo
            git pull --rebase origin main --quiet
            echo
            echo "✅ Your world is now updated to the latest version!"

            echo
            echo "🔁 Restoring your local work..."
            git stash pop --quiet
            echo

            echo "💬 Last update message from your friend:"
            git log -1 --pretty=format:"%an: %s"
            echo
            echo "🕹️ You're ready to play!"
            exit 0
        else
            echo "🔙 Cancelled. Returning to main menu."
            echo
            exec "$0"
        fi
    else
        echo
        echo "🌍 Checking for updates from GitHub..."
        echo
        git pull --rebase origin main --quiet
        echo "✅ You already have the latest world!"
        echo
        echo "💬 Last update message from your friend:"
        git log -1 --pretty=format:"%an: %s"
        echo
        echo "🕹️ Ready to start your Minecraft server!"
        exit 0
    fi

elif [[ "$choice" == "2" ]]; then
    echo
    echo "💾 Saving your updated world for everyone..."
    echo "👤 Your name: $COMMIT_NAME"
    echo
    read -rp "📝 What did you build or change? " DESCRIPTION
    echo

    if [[ -z "$DESCRIPTION" ]]; then
        DESCRIPTION="()"
    else
        DESCRIPTION="($DESCRIPTION)"
    fi

    git add .
    git commit -m "Save Latest Karishma World By $COMMIT_NAME - $DESCRIPTION" > /dev/null
    git push origin main --quiet

    echo
    echo "✅ Your world is now saved online!"
    echo
    echo "💬 Friends will see this message:"
    echo "\"$COMMIT_NAME: $DESCRIPTION\""
    echo
    exit 0

else
    echo
    echo "❌ Please type 1 or 2 to choose."
    exit 1
fi

