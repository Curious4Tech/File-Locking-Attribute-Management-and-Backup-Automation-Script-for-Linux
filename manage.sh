#!/bin/bash

# Fancy banner
cat << "EOF"
===========================================================
   _       _   _   _   _   _   _   _   _   _   _   _  
  | |     | |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| | 
  | |     | LOCK, ATTRIBUTE, AND BACKUP MANAGEMENT  |
  |_|     |_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_| 
===========================================================
EOF

# Prompt user for the file or directory path
read -p "Enter the full path of the file or directory: " PATH_TO_MANAGE

# Check if the path exists; if not, prompt for creation
if [ ! -e "$PATH_TO_MANAGE" ]; then
    read -p "The path does not exist. Do you want to create it? (y/n): " CREATE_CHOICE
    if [ "$CREATE_CHOICE" = "y" ]; then
        if [[ "$PATH_TO_MANAGE" == */ ]]; then
            mkdir -p "$PATH_TO_MANAGE" && echo "Directory created: $PATH_TO_MANAGE"
        else
            sudo touch "$PATH_TO_MANAGE" && echo "File created: $PATH_TO_MANAGE"
        fi
    else
        echo "Exiting... Path does not exist."
        exit 1
    fi
fi

# Check if it's a file or a directory
if [ -d "$PATH_TO_MANAGE" ]; then
    TYPE="directory"
elif [ -f "$PATH_TO_MANAGE" ]; then
    TYPE="file"
else
    echo "Invalid path. Not a file or directory."
    exit 1
fi

# Main menu
echo "Choose an action for the $TYPE:"
echo "1) Set Attributes (Immutable, Append-only)"
echo "2) Lock/Unlock with flock"
echo "3) Schedule Backup with Cron"
read -p "Enter choice: " MAIN_CHOICE

case $MAIN_CHOICE in
    1) # Set Attributes
        echo "Choose an attribute for the $TYPE:"
        echo "1) Make Immutable (+i)"
        echo "2) Make Append-only (+a)"
        echo "3) Remove All Attributes (-i -a)"
        read -p "Enter choice: " ATTR_CHOICE

        case $ATTR_CHOICE in
            1)
                sudo chattr +i "$PATH_TO_MANAGE"
                echo "$TYPE is now immutable."
                ;;
            2)
                sudo chattr +a "$PATH_TO_MANAGE"
                echo "$TYPE is now append-only."
                ;;
            3)
                sudo chattr -i -a "$PATH_TO_MANAGE"
                echo "All attributes removed from $TYPE."
                ;;
            *)
                echo "Invalid choice."
                ;;
        esac
        ;;
    2) # Lock/Unlock with flock
        echo "Choose an action for the $TYPE:"
        echo "1) Lock"
        echo "2) Unlock"
        read -p "Enter choice: " LOCK_CHOICE

        case $LOCK_CHOICE in
            1)
                echo "Locking the $TYPE..."
                if [ "$TYPE" = "file" ]; then
                    exec 200>"$PATH_TO_MANAGE"
                    flock -x 200 || { echo "Failed to lock $PATH_TO_MANAGE"; exit 1; }
                else
                    exec 200>"$PATH_TO_MANAGE/.lock"
                    flock -x 200 || { echo "Failed to lock $PATH_TO_MANAGE"; exit 1; }
                fi
                echo "$TYPE is locked. Press Ctrl+C to unlock."
                sleep infinity
                ;;
            2)
                echo "Unlocking the $TYPE..."
                exec 200>&-
                echo "$TYPE unlocked."
                ;;
            *)
                echo "Invalid choice."
                ;;
        esac
        ;;
    3) # Schedule Backup with Cron
        echo "Setting up a cron job for backup..."
        read -p "Enter the full path of the backup location: " BACKUP_LOCATION
        if [ ! -d "$BACKUP_LOCATION" ]; then
            echo "Backup location does not exist. Creating..."
            mkdir -p "$BACKUP_LOCATION" && echo "Backup location created: $BACKUP_LOCATION"
        fi

        echo "How often would you like to back up?"
        echo "1) Every 10 minutes"
        echo "2) Every 30 minutes"
        echo "3) Every 40 minutes"
        echo "4) Hourly"
        echo "5) Daily"
        echo "6) Weekly"
        read -p "Enter choice: " BACKUP_CHOICE

        case $BACKUP_CHOICE in
            1)
                SCHEDULE="*/10 * * * *"
                ;;
            2)
                SCHEDULE="*/30 * * * *"
                ;;
            3)
                SCHEDULE="*/40 * * * *"
                ;;
            4)
                SCHEDULE="0 * * * *"
                ;;
            5)
                SCHEDULE="0 0 * * *"
                ;;
            6)
                SCHEDULE="0 0 * * 0"
                ;;
            *)
                echo "Invalid choice."
                exit 1
                ;;
        esac

        CRON_CMD="rsync -av --delete \"$PATH_TO_MANAGE\" \"$BACKUP_LOCATION\""
        CRON_JOB="$SCHEDULE $CRON_CMD"

        # Add cron job
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        echo "Backup job scheduled: $CRON_JOB"
        ;;
    *)
        echo "Invalid choice."
        ;;
esac

