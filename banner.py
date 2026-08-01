from rich.console import Console
from rich.panel import Panel
from rich.text import Text
from rich.live import Live
from rich.align import Align
import os
import platform
import subprocess
import shutil
import requests
import time
import json
import threading

console = Console()
console.clear()
NAME = "SENSEI X"

# ================= TERMINAL =================
def term_width():
    try:
        return shutil.get_terminal_size().columns
    except:
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
    except:
        return text

# ================= BACKEND TASKS =================
result = {}

def backend_collect():
    # Network + IP
    try:
        r = requests.get("https://ipinfo.io/json", timeout=4)
        result["online"] = True
        result["ipinfo"] = r.json()
    except:
        result["online"] = False
        result["ipinfo"] = {}

    # System
    try:
        result["android"] = subprocess.check_output(
            ["getprop", "ro.build.version.release"], text=True
        ).strip()
    except:
        result["android"] = "N/A"

    try:
        result["cores"] = subprocess.check_output(["nproc"], text=True).strip()
    except:
        result["cores"] = "?"

    try:
        result["uptime"] = subprocess.check_output(
            ["uptime", "-p"], text=True
        ).strip().replace("up ", "")
    except:
        result["uptime"] = "N/A"

    try:
        result["pkgs"] = subprocess.check_output(
            ["bash", "-lc", "ls $PREFIX/bin | wc -l"],
            text=True
        ).strip()
    except:
        result["pkgs"] = "N/A"

    try:
        line = subprocess.check_output(["free", "-m"], text=True).splitlines()[1].split()
        result["ram"] = f"{line[2]}MB / {line[1]}MB"
    except:
        result["ram"] = "N/A"

    try:
        line = subprocess.check_output(
            ["df", "-h", os.path.expanduser("~")],
            text=True
        ).splitlines()[1].split()
        result["disk"] = f"{line[2]} / {line[1]}"
    except:
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

def add(label, value, style="bright_cyan"):
    info.append(f"{label:<12}", style="bold yellow")
    info.append(" : ", style="dim")
    info.append(f"{value}\n", style=style)

add("User", NAME)
add("OS", f"Android {result['android']} ({platform.machine()} | {result['cores']}-core)")
add("Shell", os.environ.get("SHELL", "zsh").split("/")[-1])
add("Host", platform.node())

if result["online"]:
    add("Network", "Online", style="bold green")
    add("Public IP", result["ipinfo"].get("ip", "N/A"))
    loc = f"{result['ipinfo'].get('city','')}, {result['ipinfo'].get('country','')}".strip(", ")
    add("Location", loc if loc else "N/A")
else:
    add("Network", "Offline", style="bold red")

add("Uptime", result["uptime"])
add("Packages", result["pkgs"])
add("RAM", result["ram"])
add("Disk", result["disk"])

info_panel = Panel(
    info,
    border_style="green",
    padding=(0, 2),
)

console.print(logo)
console.print()
console.print(info_panel)
