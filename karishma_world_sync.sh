#!/bin/bash

# Your name here
COMMIT_NAME="Sweetu"

echo "==============================="
echo "🎮 Karishma World Sync"
echo "==============================="
echo "What do you want to do?"
echo "1. Load latest world from online (before playing)"
echo "2. Save your world to online (after playing)"
read -rp "Type 1 or 2: " choice

if [[ "$choice" == "1" ]]; then
    # Check for local changes
    if [[ -n $(git status --porcelain) ]]; then
        echo "⚠️ Your world looks different than the one online."
        echo "Maybe you forgot to save last time,"
        echo "or maybe your friend played and saved a new world online."
        echo
        echo "👉 Press 1 to load your friend's latest world."
        echo "🔙 Press 2 to cancel and go back."
        read -rp "Type 1 or 2: " pullChoice
        if [[ "$pullChoice" == "1" ]]; then
            echo "📦 Saving your current work just in case..."
            git stash
            echo "🌍 Downloading latest world from GitHub..."
            git pull --rebase origin main
            echo "🔁 Restoring your saved work..."
            git stash pop
            echo
            echo "✅ You now have the latest world!"
            echo "💬 Last update made by a friend:"
            git log -1 --pretty=format:"%an: %s"
            echo
            echo "🕹️ Ready to play!"
            exit 0
        else
            echo "🔙 Back to main menu. No changes made."
            exec "$0"
        fi
    else
        echo "🌍 Downloading latest world from GitHub..."
        git pull --rebase origin main
        echo "✅ You already have the latest world!"
        echo "💬 Last update made by a friend:"
        git log -1 --pretty=format:"%an: %s"
        echo
        echo "You can start your Minecraft server now 😊"
        exit 0
    fi

elif [[ "$choice" == "2" ]]; then
    echo "💾 Saving your world for everyone..."
    echo "👤 Your name: $COMMIT_NAME"
    read -rp "✏️ What did you build or change in Karishma World? " DESCRIPTION

    git add .
    git commit -m "Save Latest Karishma World By $COMMIT_NAME - $DESCRIPTION"
    git push origin main

    echo "✅ Your world is now saved online!"
    echo "🌍 Friends will see this when they load the world:"
    echo "\"$COMMIT_NAME: $DESCRIPTION\""
    exit 0

else
    echo "❌ Please type 1 or 2 to choose."
    exit 1
fi

