# T-BAN (Termux Banner)

A dynamic, visually stunning startup banner for Termux written in Python. It automatically fetches and displays real-time system and network statistics inside a clean, centered interface using the `rich` library.

## 🌟 Features
* **Global Command:** Install it once and run it from anywhere just by typing `banner`.
* **Smart Setup Menu:** Auto-detects if it's already installed and gives you a menu to easily change your name or update the script.
* **Auto Shell Detection:** Automatically adds the startup command to your `.bashrc` or `.zshrc` depending on what you use.
* **Custom User Greeting:** Asks for your name on the first run and saves it securely. 
* **Dynamic ASCII Art:** Uses `figlet` to generate your name in ASCII.
* **Hardware & System Stats:** Displays OS version, Shell, CPU cores, Uptime, RAM usage, and Disk space in real-time.
* **Network Status:** Checks if you are online and fetches your Public IP and Geolocation.

## ⚙️ Installation

You don't need to clone any repository. Just copy and paste this single command into your Termux to install it instantly:

```bash
curl -sL https://raw.githubusercontent.com/JubairSenseiDev/t-ban/main/setup.sh | bash
```

**Note:** The setup script will automatically install it as a system command and set it to run automatically every time you open a new Termux session.

## 🚀 Usage

Whenever you open a new Termux session, the banner will load automatically.

Because T-BAN installs as a global command, you can launch it manually from any directory by simply typing:
```bash
banner
```

### How to Change Your Name?
If you want to change the name on the banner or fix a typo, you can run:
```bash
banner --reset
```
Alternatively, you can run the installation command again to access the interactive update menu.

## 📦 Requirements
* `python` 3.x
* `figlet` 
* `rich` & `requests` (Python Packages)
