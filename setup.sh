#!/bin/bash

BANNER_FILE="$HOME/.banner.py"
BIN_DIR="$PREFIX/bin"
CMD_NAME="banner"
REPO_URL="https://github.com/JubairSenseiDev/t-ban/raw/refs/heads/main/banner.py"

clear
echo -e "\e[1;36m──────────────────────────────────\e[0m"
echo -e "\e[1;32m    SENSEI X BANNER - SETUP SCRIPT     \e[0m"
echo -e "\e[1;36m──────────────────────────────────\e[0m"
echo ""

update_name() {
    echo -e "\e[1;33m[*] Opening name setup...\e[0m"
    banner --reset
}

uninstall_banner() {
    echo -e "\e[1;31m[*] Uninstalling SENSEI X BANNER...\e[0m"
    rm -f "$BIN_DIR/$CMD_NAME" "$HOME/.sensei_config.json" "$BANNER_FILE"
    sed -i '/banner/d' ~/.bashrc ~/.zshrc 2>/dev/null
    echo -e "\e[1;32m[+] Uninstallation Complete! Banner is removed.\e[0m"
    exit 0
}

install_banner() {
    echo -e "\e[1;33m[*] Installing required packages...\e[0m"
    pkg install curl python figlet procps ncurses-utils -y
    
    echo -e "\e[1;33m[*] Installing Python dependencies...\e[0m"
    pip install rich requests

    echo -e "\e[1;33m[*] Downloading script...\e[0m"
    curl -sL -o "$BANNER_FILE" "$REPO_URL"

    # Creating a global command 'banner' in $PREFIX/bin with purely BASH logic
    echo -e "\e[1;33m[*] Creating global command '$CMD_NAME'...\e[0m"
    
    cat << 'EOF' > "$BIN_DIR/$CMD_NAME"
#!/bin/bash

CONFIG_FILE="$HOME/.sensei_config.json"

if [ "$1" == "--reset" ]; then
    clear
    echo -e "\e[1;36mWelcome to SENSEI X\e[0m"
    read -p $'\e[1;32mEnter your new name: \e[0m' NEW_NAME
    
    # If no name is provided, use default
    NEW_NAME=${NEW_NAME:-SENSEI X}
    
    echo "{\"name\": \"$NEW_NAME\"}" > "$CONFIG_FILE"
    
    echo -e "\n\e[1;32m√ Name successfully updated to: $NEW_NAME\e[0m"
    exit 0
fi

# Run the python script if not resetting
python3 "$HOME/.banner.py"
EOF

    chmod +x "$BIN_DIR/$CMD_NAME"

    # Shell Detection (Bash or Zsh)
    if [[ "$SHELL" == *"zsh"* ]]; then
        RC_FILE="$HOME/.zshrc"
    else
        RC_FILE="$HOME/.bashrc" # Default fallback for bash
    fi

    # Auto-start setup
    if ! grep -q "$CMD_NAME" "$RC_FILE" 2>/dev/null; then
        echo -e "\e[1;33m[*] Setting up auto-start in $RC_FILE...\e[0m"
        echo "" >> "$RC_FILE"
        echo "$CMD_NAME" >> "$RC_FILE"
    else
        echo -e "\e[1;32m[*] Auto-start is already configured in $RC_FILE.\e[0m"
    fi

    echo ""
    echo -e "\e[1;32m[+] Installation Complete!\e[0m"
    echo -e "\e[1;33m[*] Now, let's set your name...\e[0m"
    sleep 2
    
    # Run the setup logically with the new reset command
    banner --reset
}

# Check if command 'banner' already exists
if command -v $CMD_NAME &> /dev/null; then
    echo -e "\e[1;32m[!] T-BAN is already installed on your system.\e[0m"
    echo ""
    echo "Select an option:"
    echo -e "  \e[1;36m1)\e[0m Update/Change Name"
    echo -e "  \e[1;36m2)\e[0m Reinstall or Update Script"
    echo -e "  \e[1;31m3)\e[0m Uninstall Banner"
    echo -e "  \e[1;36m4)\e[0m Exit"
    echo ""
    read -p "Enter choice [1-4]: " choice

    case $choice in
        1) update_name ;;
        2) install_banner ;;
        3) uninstall_banner ;;
        4) echo -e "\e[1;32mExiting...\e[0m"; exit 0 ;;
        *) echo -e "\e[1;31mInvalid choice!\e[0m"; exit 1 ;;
    esac
else
    # First time installation
    install_banner
fi
