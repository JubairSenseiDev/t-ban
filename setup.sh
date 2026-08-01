#!/bin/bash

BANNER_FILE="$HOME/.banner.py"
REPO_URL="https://github.com/JubairSenseiDev/t-ban/raw/refs/heads/main/banner.py"

clear
echo -e "\e[1;36m──────────────────────────────────\e[0m"
echo -e "\e[1;32m      SENSEI X BANNER - SETUP SCRIPT     \e[0m"
echo -e "\e[1;36m──────────────────────────────────\e[0m"
echo ""

# নাম পরিবর্তন করার ফাংশন
update_name() {
    echo -e "\e[1;33m[*] Opening name setup...\e[0m"
    python "$BANNER_FILE" --reset
}

# ইনস্টল/আপডেট করার ফাংশন
install_banner() {
    echo -e "\e[1;33m[*] Installing required packages...\e[0m"
    pkg install curl python figlet procps ncurses-utils -y
    
    echo -e "\e[1;33m[*] Installing Python dependencies...\e[0m"
    pip install rich requests

    echo -e "\e[1;33m[*] Downloading banner.py to hidden file...\e[0m"
    curl -sL -o "$BANNER_FILE" "$REPO_URL"

    # Shell Detection (Bash or Zsh)
    if [[ "$SHELL" == *"zsh"* ]]; then
        RC_FILE="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        RC_FILE="$HOME/.bashrc"
    else
        RC_FILE="$HOME/.bashrc" # fallback
    fi

    # Duplicate এড়ানোর জন্য চেক করা হচ্ছে
    if ! grep -q "python $BANNER_FILE" "$RC_FILE" 2>/dev/null; then
        echo -e "\e[1;33m[*] Setting up auto-start in $RC_FILE...\e[0m"
        echo "" >> "$RC_FILE"
        echo "python $BANNER_FILE" >> "$RC_FILE"
    else
        echo -e "\e[1;32m[*] Auto-start is already configured in $RC_FILE.\e[0m"
    fi

    echo ""
    echo -e "\e[1;32m[+] Installation Complete!\e[0m"
    echo -e "\e[1;33m[*] Now, let's set your name...\e[0m"
    sleep 2
    
    # নাম সেট করার জন্য স্ক্রিপ্ট রান করা
    python "$BANNER_FILE"
}

# চেক করা হচ্ছে আগে থেকে ইনস্টল করা আছে কিনা
if [ -f "$BANNER_FILE" ]; then
    echo -e "\e[1;32m[!] T-BAN is already installed on your system.\e[0m"
    echo ""
    echo "Select an option:"
    echo -e "  \e[1;36m1)\e[0m Update/Change Name"
    echo -e "  \e[1;36m2)\e[0m Reinstall or Update Script"
    echo -e "  \e[1;36m3)\e[0m Exit"
    echo ""
    read -p "Enter choice [1-3]: " choice

    case $choice in
        1) update_name ;;
        2) install_banner ;;
        3) echo -e "\e[1;32mExiting...\e[0m"; exit 0 ;;
        *) echo -e "\e[1;31mInvalid choice!\e[0m"; exit 1 ;;
    esac
else
    # প্রথমবার হলে সরাসরি ইনস্টল হবে
    install_banner
fi
