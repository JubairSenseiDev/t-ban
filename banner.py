import os
import sys
import platform
import subprocess
import shutil
import requests
import time
import json
import threading
from rich.console import Console
from rich.panel import Panel
from rich.text import Text
from rich.live import Live
from rich.align import Align

console = Console()

# ================= CONFIG & USERNAME =================
CONFIG_FILE = os.path.expanduser("~/.sensei_config.json")

def get_username():
    is_reset = "--reset" in sys.argv

    # যদি ইউজার নাম রিসেট করতে চায়, আগের ফাইল মুছে ফেলবে
    if is_reset and os.path.exists(CONFIG_FILE):
        os.remove(CONFIG_FILE)

    # যদি রিসেট না হয় এবং আগে থেকে সেভ করা নাম থাকে, তবে সেটি লোড করবে
    if not is_reset and os.path.exists(CONFIG_FILE):
        try:
            with open(CONFIG_FILE, "r") as f:
                return json.load(f).get("name", "SENSEI X")
        except Exception:
            pass

    # নতুন নাম চাইবে
    console.clear()
    console.print("[bold cyan]Welcome to SENSEI X[/]")
    name = console.input("[bold green]Enter your new name:[/] ").strip() or "SENSEI X"

    # নতুন নাম ফাইলে সেভ করবে
    with open(CONFIG_FILE, "w") as f:
        json.dump({"name": name}, f)

    # যদি কমান্ড banner --reset হয়, তবে নাম সেভ করে এখানেই স্ক্রিপ্ট বন্ধ করে দিবে!
    if is_reset:
        console.print(f"\n[bold green]✅ Name successfully updated to: {name}[/]")
        sys.exit(0)

    return name

# ================= INITIALIZATION =================
NAME = get_username()
console.clear()

# ================= TERMINAL =================
def term_width():
    try:
        return shutil.get_terminal_size().columns
    except Exception:
        return 80

TERM_W = term_width()
SAFE_W = TERM_W - 10

# ================= ASCII =================
def pick_font():
    if TERM_W < 70:
        return "big"
    elif TERM_W < 100:
        return "standard"
    else:
        return "small"

def generate_ascii(text):
    try:
        raw = subprocess.check_output(
            ["figlet", "-f", pick_font(), text],
            text=True
        ).rstrip("\n")
        return "\n".join(line[:SAFE_W] for line in raw.splitlines())
    except Exception:
        return text

# ================= BACKEND TASKS =================
result = {}

def backend_collect():
    # Network + IP
    try:
        r = requests.get("https://ipinfo.io/json", timeout=4)
        result["online"] = True
        result["ipinfo"] = r.json()
    except Exception:
        result["online"] = False
        result["ipinfo"] = {}

    # System
    try:
        result["android"] = subprocess.check_output(
            ["getprop", "ro.build.version.release"], text=True
        ).strip()
    except Exception:
        result["android"] = "N/A"

    try:
        result["cores"] = subprocess.check_output(["nproc"], text=True).strip()
    except Exception:
        result["cores"] = "?"

    try:
        result["uptime"] = subprocess.check_output(
            ["uptime", "-p"], text=True
        ).strip().replace("up ", "")
    except Exception:
        result["uptime"] = "N/A"

    # HANG FIX: No bash loop, pure python reading
    try:
        prefix = os.environ.get("PREFIX", "/data/data/com.termux/files/usr")
        result["pkgs"] = str(len(os.listdir(f"{prefix}/bin")))
    except Exception:
        result["pkgs"] = "N/A"

    try:
        line = subprocess.check_output(["free", "-m"], text=True).splitlines()[1].split()
        result["ram"] = f"{line[2]}MB / {line[1]}MB"
    except Exception:
        result["ram"] = "N/A"

    try:
        line = subprocess.check_output(
            ["df", "-h", os.path.expanduser("~")],
            text=True
        ).splitlines()[1].split()
        result["disk"] = f"{line[2]} / {line[1]}"
    except Exception:
        result["disk"] = "N/A"

# ================= LOADING UI =================
def loading_screen():
    frames = [
        "[bold cyan]Initializing system…[/]",
        "[bold cyan]Checking network…[/]",
        "[bold cyan]Loading environment…[/]",
        "[bold cyan]Preparing interface…[/]",
    ]
    with Live(Align.center(frames[0], vertical="middle"),
              refresh_per_second=6, console=console) as live:
        for i in range(12):
            live.update(Align.center(frames[i % len(frames)], vertical="middle"))
            time.sleep(0.3)

# ================= RUN BACKEND IN PARALLEL =================
t = threading.Thread(target=backend_collect)
t.start()
loading_screen()
t.join()

# ================= FINAL UI =================
console.clear()

# Logo
logo = Panel(
    Text(generate_ascii(NAME), style="bold cyan", no_wrap=True),
    title=f"[bold white]{NAME}[/bold white]",
    border_style="cyan",
    padding=(0, 2),
)

# Info
info = Text()

def add_info(label, value, style="bright_cyan"):
    info.append(f"{label:<12}", style="bold yellow")
    info.append(" : ", style="dim")
    info.append(f"{value}\n", style=style)

add_info("User", NAME)
add_info("OS", f"Android {result.get('android', 'N/A')} ({platform.machine()} | {result.get('cores', '?')}-core)")
add_info("Shell", os.environ.get("SHELL", "zsh").split("/")[-1])
add_info("Host", platform.node())

if result.get("online"):
    add_info("Network", "Online", style="bold green")
    add_info("Public IP", result.get("ipinfo", {}).get("ip", "N/A"))
    loc = f"{result.get('ipinfo', {}).get('city', '')}, {result.get('ipinfo', {}).get('country', '')}".strip(", ")
    add_info("Location", loc if loc else "N/A")
else:
    add_info("Network", "Offline", style="bold red")

add_info("Uptime", result.get("uptime", "N/A"))
add_info("Packages", result.get("pkgs", "N/A"))
add_info("RAM", result.get("ram", "N/A"))
add_info("Disk", result.get("disk", "N/A"))

info_panel = Panel(
    info,
    border_style="green",
    padding=(0, 2),
)

console.print(logo)
console.print()
console.print(info_panel)
