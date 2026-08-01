# T-BAN (Termux Banner)

A dynamic, visually stunning startup banner for Termux written in Python. It automatically fetches and displays real-time system and network statistics inside a clean, centered interface using the `rich` library.

## 🌟 Features
* **Smart Setup Menu:** Auto-detects if it's already installed and gives you a menu to easily change your name or update the script.
* **Auto Shell Detection:** Automatically adds the startup command to your `.bashrc` or `.zshrc` depending on what you use.
* **Custom User Greeting:** Asks for your name on the first run and saves it securely. 
* **Dynamic ASCII Art:** Uses `figlet` to generate your name in ASCII.
* **Hardware & System Stats:** Displays OS version, Shell, CPU cores, Uptime, RAM usage, and Disk space in real-time.
* **Network Status:** Checks if you are online and fetches your Public IP and Geolocation.

## ⚙️ Installation

You can install this simply by running the setup script:

```bash
git clone [https://github.com/JubairSenseiDev/t-ban.git](https://github.com/JubairSenseiDev/t-ban.git)
cd t-ban
chmod +x setup.sh
./setup.sh
```

**Note:** The setup script will automatically download the banner script to a hidden file (`~/.banner.py`) and set it to run automatically every time you open a new Termux session.

## 🚀 Usage

Whenever you open a new Termux session, the banner will load automatically.

### How to Change Your Name?
If you want to change the name on the banner or reinstall the script, just run the setup script again:
```bash
./setup.sh
```
A menu will appear like this:
1) Update/Change Name
2) Reinstall or Update Script
3) Exit

Simply press `1` to set a new name!

### Manual Command
If you ever want to run the banner manually or reset the name without the setup script, you can run:
```bash
python ~/.banner.py
python ~/.banner.py --reset
```

## 📦 Requirements
* `python` 3.x
* `figlet` 
* `rich` & `requests` (Python Packages)
