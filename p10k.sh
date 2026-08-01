#!/bin/bash

# Termux-only guard: PREFIX must point at the Termux usr dir.
case "$PREFIX" in
    *com.termux*) ;;
    *) echo -e "\e[1;31m[!] This script is for Termux only. Aborting.\e[0m"; exit 1 ;;
esac

clear
echo -e "\e[1;36m───────────────────────────────────────────\e[0m"
echo -e "\e[1;32m    TERMUX ZSH + POWERLEVEL10K SETUP       \e[0m"
echo -e "\e[1;36m───────────────────────────────────────────\e[0m"
echo ""

# 1. Update and install prerequisites
echo -e "\e[1;33m[*] Installing Zsh, Git, and required packages...\e[0m"
pkg update -y && pkg install zsh git curl wget ncurses-utils -y
if ! command -v zsh >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1; then
    echo -e "\e[1;31m[!] zsh/git not installed. Check internet, run 'pkg update', then retry.\e[0m"
    exit 1
fi

# 2. Install Oh My Zsh (Unattended). RUNZSH/CHSH=no so the installer does not
# spawn a subshell or change the shell mid-script.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "\e[1;33m[*] Installing Oh My Zsh...\e[0m"
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "\e[1;32m[*] Oh My Zsh is already installed.\e[0m"
fi

# Fallback: if the installer did not create ~/.zshrc, seed one from the template
# (or a minimal file) so the sed/migration steps below have something to work on.
if [ ! -f "$HOME/.zshrc" ]; then
    echo -e "\e[1;33m[*] ~/.zshrc missing; creating from template...\e[0m"
    if [ -f "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" ]; then
        cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
    else
        printf 'export ZSH="$HOME/.oh-my-zsh"\nZSH_THEME="robbyrussell"\nplugins=(git)\nsource $ZSH/oh-my-zsh.sh\n' > "$HOME/.zshrc"
    fi
fi

# 3. Install Powerlevel10k
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo -e "\e[1;33m[*] Downloading Powerlevel10k Theme...\e[0m"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" || echo -e "\e[1;31m[!] Powerlevel10k clone failed; theme may not load.\e[0m"
fi

# 4. Install Auto-suggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo -e "\e[1;33m[*] Installing Auto-suggestions plugin...\e[0m"
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || echo -e "\e[1;31m[!] Auto-suggestions clone failed.\e[0m"
fi

# 5. Install Syntax Highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo -e "\e[1;33m[*] Installing Syntax Highlighting plugin...\e[0m"
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || echo -e "\e[1;31m[!] Syntax-highlighting clone failed.\e[0m"
fi

# Only enable plugins that actually cloned successfully, so a failed clone
# does not make zsh error out on every startup.
ENABLED_PLUGINS="git"
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && ENABLED_PLUGINS="$ENABLED_PLUGINS zsh-autosuggestions"
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && ENABLED_PLUGINS="$ENABLED_PLUGINS zsh-syntax-highlighting"

# 6. Configure .zshrc
echo -e "\e[1;33m[*] Configuring settings...\e[0m"
# Back up the original .zshrc only once, so re-running never overwrites the
# pristine backup with an already-modified file.
[ -f ~/.zshrc.backup ] || cp ~/.zshrc ~/.zshrc.backup 2>/dev/null

sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
sed -i "s/^plugins=(.*/plugins=($ENABLED_PLUGINS)/" ~/.zshrc

# 7. Migrate settings from .bashrc to .zshrc (অটোমেটিক কপি করার লজিক)
echo -e "\e[1;33m[*] Migrating configurations from .bashrc to .zshrc...\e[0m"
MIGRATE_TAG="# --- Imported from .bashrc ---"
if [ -f ~/.bashrc ] && ! grep -qF "$MIGRATE_TAG" ~/.zshrc 2>/dev/null; then
    echo "" >> ~/.zshrc
    echo "$MIGRATE_TAG" >> ~/.zshrc
    # PS1 বা Bash এর নির্দিষ্ট প্রম্পট কমান্ডগুলো বাদ দিয়ে বাকি সব কপি করবে
    grep -v -E '^(PS1|PROMPT_COMMAND|shopt|complete|bash|banner)' ~/.bashrc >> ~/.zshrc
fi

# banner autostart .zshrc-te thik ekbar nishchit kora hocche
grep -qxF 'banner' ~/.zshrc 2>/dev/null || echo 'banner' >> ~/.zshrc

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
echo -e "1. Close and reopen Termux (or type \e[1;32mzsh\e[0m) to start your new shell."
echo -e "2. The \e[1;32mPowerlevel10k setup wizard\e[0m will start automatically the first time."
echo -e "3. Just answer the Yes/No questions (y/n/1/2) to choose your prompt style!"
echo -e "\e[1;36m───────────────────────────────────────────\e[0m"

# Launch Zsh WITHOUT 'exec': if zsh crashes/exits, we fall back to the current
# bash session instead of killing the terminal (which caused a black screen).
if [ -t 0 ]; then
    zsh || echo -e "\e[1;31m[!] Zsh exited. You are back in bash. Type 'zsh' to retry.\e[0m"
fi
