#!/bin/bash

# Main installer script for GameVaultPanel

function show_menu() {
    echo "Welcome to GameVaultPanel Installer"
    echo "1. Install Panel"
    echo "2. Install Node"
    echo "3. Start Panel"
    echo "4. Stop Panel"
    echo "5. Restart Panel"
    echo "6. Maintenance"
    echo "7. Docker Node"
    echo "8. Cloudflare Configuration"
    echo "9. Make User"
    echo "10. Delete User"
    echo "11. Delete Panel"
    echo "12. Backup"
    echo "13. Security"
    echo "0. Exit"
}

while true; do
    show_menu
    read -p "Select an option: " option
    case $option in
        1) ./scripts/install-panel.sh ;;  
        2) ./scripts/install-node.sh ;;  
        3) ./scripts/start-panel.sh ;;  
        4) ./scripts/stop-panel.sh ;;  
        5) ./scripts/restart-panel.sh ;;  
        6) ./scripts/maintenance.sh ;;  
        7) ./scripts/docker-node.sh ;;  
        8) ./scripts/cloudflare.sh ;;  
        9) ./scripts/make-user.sh ;;  
        10) ./scripts/delete-user.sh ;;  
        11) ./scripts/delete-panel.sh ;;  
        12) ./scripts/backup.sh ;;  
        13) ./scripts/security.sh ;;  
        0) exit ;;  
        *) echo "Invalid option. Please try again." ;;  
    esac
done

