#!/bin/bash

clear
echo -e "\e[1;36m───────────────────────────────────────────\e[0m"
echo -e "\e[1;32m    TERMUX ZSH + POWERLEVEL10K SETUP       \e[0m"
echo -e "\e[1;36m───────────────────────────────────────────\e[0m"
echo ""

# 1. Update and install prerequisites
echo -e "\e[1;33m[*] Installing Zsh, Git, and required packages...\e[0m"
pkg update -y && pkg install zsh git curl wget ncurses-utils -y

# 2. Install Oh My Zsh (Unattended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "\e[1;33m[*] Installing Oh My Zsh...\e[0m"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "\e[1;32m[*] Oh My Zsh is already installed.\e[0m"
fi

# 3. Install Powerlevel10k
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo -e "\e[1;33m[*] Downloading Powerlevel10k Theme...\e[0m"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi

# 4. Install Auto-suggestions (জলছাপ সাজেশন)
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo -e "\e[1;33m[*] Installing Auto-suggestions plugin...\e[0m"
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

# 5. Install Syntax Highlighting (কমান্ড কালারিং)
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo -e "\e[1;33m[*] Installing Syntax Highlighting plugin...\e[0m"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

# 6. Configure .zshrc
echo -e "\e[1;33m[*] Configuring settings...\e[0m"
cp ~/.zshrc ~/.zshrc.backup 2>/dev/null

# Set theme and plugins
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
sed -i 's/^plugins=(.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# 7. Add existing T-BAN to new Zsh (so the banner still works!)
if command -v banner &> /dev/null; then
    if ! grep -q "banner" ~/.zshrc; then
        echo "" >> ~/.zshrc
        echo "# Load SENSEI X BANNER" >> ~/.zshrc
        echo "banner" >> ~/.zshrc
    fi
fi

# 8. Setup Nerd Font (Crucial for Powerlevel10k icons in Termux)
echo -e "\e[1;33m[*] Setting up Nerd Font for Termux (Requires for P10K icons)...\e[0m"
mkdir -p ~/.termux
curl -fLo ~/.termux/font.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
termux-reload-settings 2>/dev/null

# 9. Change default shell to Zsh
echo -e "\e[1;33m[*] Changing default shell to Zsh...\e[0m"
chsh -s zsh

echo ""
echo -e "\e[1;32m[+] Super Setup Complete!\e[0m"
echo -e "\e[1;36m───────────────────────────────────────────\e[0m"
echo -e "\e[1;33m[*] NEXT STEPS:\e[0m"
echo -e "1. We are launching your new shell now."
echo -e "2. The \e[1;32mPowerlevel10k setup wizard\e[0m will start automatically."
echo -e "3. Just answer the Yes/No questions (y/n/1/2) to choose your prompt style!"
echo -e "\e[1;36m───────────────────────────────────────────\e[0m"
sleep 3

# Launch Zsh automatically
exec zsh
