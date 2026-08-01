# T-BAN (Termux Banner)

![](https://raw.githubusercontent.com/JubairSenseiDev/t-ban/refs/heads/main/Screenshot_2026_0801_134741.png)

A dynamic, visually stunning startup banner for Termux written in Python. It automatically fetches and displays real-time system and network statistics inside a clean, centered interface using the `rich` library.

## 🌟 Features
* **Global Command:** Install it once and run it from anywhere just by typing `banner`.
* **Smart Setup Menu:** Auto-detects if it's already installed and gives you an interactive menu to easily change your name, update the script, or uninstall it.
* **Auto Shell Detection:** Automatically adds the startup command to your `.bashrc` or `.zshrc` depending on what you use.
* **Custom User Greeting:** Asks for your name on the first run and saves it securely (handled smoothly via Bash for zero lag). 
* **Dynamic ASCII Art:** Uses `figlet` to generate your name in ASCII.
* **Hardware & System Stats:** Displays OS version, Shell, CPU cores, Uptime, RAM usage, and Disk space in real-time.
* **Network Status:** Checks if you are online and fetches your Public IP and Geolocation.
* **Built-in Uninstaller:** Easily remove the banner and all its traces directly from the setup menu.

## ⚙️ Installation

You don't need to clone any repository. Just copy and paste this single command into your Termux to install the banner instantly:

```bash
curl -sL https://raw.githubusercontent.com/JubairSenseiDev/t-ban/main/setup.sh -o setup.sh && bash setup.sh
```

**Note:** The setup script will automatically install it as a system command and set it to run automatically every time you open a new Termux session.

---

## 🎨 Pro Terminal Styling (Zsh + Powerlevel10k)

Want to make your Termux look extremely professional with **auto-suggestions (watermark commands)**, **syntax highlighting**, and the **Powerlevel10k** theme? 

We have a fully automated script for that! Just run this command:

```bash
curl -sL https://raw.githubusercontent.com/JubairSenseiDev/t-ban/main/p10k.sh -o p10k.sh && bash p10k.sh
```

This will safely install `Zsh`, `Oh-My-Zsh`, `Powerlevel10k`, and essential plugins while ensuring your T-BAN setup remains perfectly intact.

---

## 🚀 Usage

Whenever you open a new Termux session, the banner will load automatically.

Because T-BAN installs as a global command, you can launch it manually from any directory by simply typing:
```bash
banner
```

### How to Change Your Name?
If you want to change the name on the banner or fix a typo, you can quickly reset it by running:
```bash
banner --reset
```
Alternatively, you can run the installation command again to access the interactive update menu.

### 🗑️ How to Uninstall

### 1. Uninstall T-BAN (The Banner)
**Method 1: Using Setup Menu (Recommended)**
Simply run the installation command again and select option **3** (`Uninstall Banner`) from the interactive menu. It will safely remove all files and configs.

**Method 2: Manual Uninstallation**
If you prefer to remove it manually, run this command in your Termux:
```bash
rm -f $PREFIX/bin/banner ~/.sensei_config.json ~/.banner.py && sed -i '/banner/d' ~/.bashrc ~/.zshrc 2>/dev/null
```

### 2. Uninstall Pro Terminal (Zsh + P10k)
If you installed the Powerlevel10k terminal styling and want to revert back to the default Termux shell (Bash), run this single command and then restart Termux:
```bash
chsh -s bash && rm -rf ~/.oh-my-zsh ~/.zshrc ~/.p10k.zsh ~/.zhistory && [ -f ~/.zshrc.backup ] && mv ~/.zshrc.backup ~/.zshrc; echo -e "\n✅ Zsh & P10k Uninstalled. Please restart Termux!"
```

## 📦 Requirements
* `python` 3.x
* `figlet` & `curl`
* `rich` & `requests` (Python Packages)
