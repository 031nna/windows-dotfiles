import os
import subprocess
import shutil

from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent

WSL_DISTRO = "Ubuntu-24.04"
## how to run on windows
# cd "C:\Users\meren\Desktop\windot-main"
# python setup.py


# Path to the hosts file
hosts_path = r"C:\Windows\System32\drivers\etc\hosts"

# The line to add to the hosts file
hostname = 'giggl.local'
ip_address = '127.0.0.1'
entry = f"{ip_address} {hostname}\n"

def update_hosts_file():
    try:
        # Check if we have admin privileges, as the hosts file requires admin access
        if not os.access(hosts_path, os.W_OK):
            print("Permission denied. Please run the script as administrator.")
            return
        
        # Open the hosts file and check for the entry
        with open(hosts_path, 'r+') as file:
            content = file.read()

            # Check if the entry already exists
            if hostname not in content:
                # If not, append the new entry to the end of the file
                file.write(entry)
                print(f"Successfully added {hostname} to the hosts file.")
            else:
                print(f"{hostname} is already in the hosts file.")
    except FileNotFoundError:
        print(f"Hosts file not found at {hosts_path}. Make sure you're on a Windows machine.")
    except PermissionError:
        print("Permission denied. Please run the script as administrator.")
    except Exception as e:
        print(f"An error occurred: {e}")

def flush_dns_cache():
    """Flush DNS cache to apply changes immediately"""
    try:
        # subprocess.run("ipconfig /flushdns", check=True, shell=True)
        # Run ipconfig /flushdns using PowerShell
        subprocess.run(['PowerShell.exe', '-Command', 'ipconfig /flushdns'], check=True)
        print("DNS cache flushed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"An error occurred while flushing DNS cache: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

def run_cmd(cmd):
    try:
        subprocess.run(cmd, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"⚠️ Command failed: {cmd}")
        print(e)

def run_choco_command(command):
    choco_path = (
        shutil.which("choco")
        or r"C:\ProgramData\chocolatey\bin\choco.exe"
    )

    if not os.path.isfile(choco_path):
        print(f"❌ Chocolatey not found. Skipping: {command}")
        return False

    try:
        subprocess.run(
            [choco_path, *command.split()],
            check=True
        )
        return True
    except subprocess.CalledProcessError as e:
        print(f"⚠️ Chocolatey command failed: {command}: {e}")
        return False

def clear_recycle_bin():
    try:
        subprocess.run([
            "powershell.exe",
            "-Command",
            "try { Clear-RecycleBin -Force -ErrorAction Stop } catch { Write-Host 'Recycle Bin is already empty or not available.' }"
        ], check=True)
    except subprocess.CalledProcessError as e:
        print("⚠️ Skipped Recycle Bin clean-up:", e)

def install_chocolatey():
    print("\n🍫 Installing Chocolatey...")

    choco_path = shutil.which("choco")
    if not choco_path:
        try:
            run_cmd(r'''PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"''')
            print("✅ Chocolatey installation initiated. Please wait a moment...")
        except Exception as e:
            print("❌ Chocolatey installation failed:", e)
    else:
        print("✅ Chocolatey is already installed.")

# def install_chocolatey():
#     print("\n🍫 Checking Chocolatey...")

#     if shutil.which("choco") or os.path.isfile(
#         r"C:\ProgramData\chocolatey\bin\choco.exe"
#     ):
#         print("✅ Chocolatey is already installed.")
#         return

#     ps_command = (
#         "Set-ExecutionPolicy Bypass -Scope Process -Force; "
#         "[System.Net.ServicePointManager]::SecurityProtocol = "
#         "[System.Net.ServicePointManager]::SecurityProtocol -bor 3072; "
#         "iex ((New-Object System.Net.WebClient).DownloadString("
#         "'https://community.chocolatey.org/install.ps1'))"
#     )

#     try:
    #     subprocess.run(
    #         [
    #             "powershell.exe",
    #             "-NoProfile",
    #             "-ExecutionPolicy", "Bypass",
    #             "-Command", ps_command
    #         ],
    #         check=True
    #     )
    #     print("✅ Chocolatey installed.")
    # except subprocess.CalledProcessError as e:
    #     print(f"❌ Chocolatey installation failed: {e}")
    #     raise

def install_ubuntu_2404():
    try:
        subprocess.run(["wsl", "--install", "-d", "Ubuntu-24.04"], check=True)
        print("✅ Ubuntu 24.04 is being installed.")
    except subprocess.CalledProcessError as e:
        print("❌ Failed to install Ubuntu 24.04:", e)


def is_wsl_ready():
    try:
        result = subprocess.run(
            [
                "wsl.exe",
                "-d", WSL_DISTRO,
                "--",
                "sh", "-c", "id -u && test -d \"$HOME\""
            ],
            capture_output=True,
            text=True,
            timeout=20
        )

        return result.returncode == 0

    except (subprocess.SubprocessError, OSError):
        return False


def configure_wsl():
    print("\n🐧 Configuring Ubuntu WSL...")

    if not is_wsl_ready():
        print("⚠️ WSL is not initialized or ready.")
        return False

    script = BASE_DIR / "wsl" / "setup.sh"

    if not script.is_file():
        print(f"❌ Missing script: {script}")
        return False

    try:
        # Convert Windows path to WSL path
        # C:\Users\... -> /mnt/c/Users/...
        windows_path = script.resolve()
        drive = windows_path.drive.rstrip(":").lower()

        wsl_script = (
            f"/mnt/{drive}/"
            f"{windows_path.relative_to(windows_path.anchor).as_posix()}"
        )

        print(f"📂 WSL script: {wsl_script}")

        # Execute setup.sh inside Ubuntu
        subprocess.run(
            [
                "wsl.exe",
                "-d", WSL_DISTRO,
                "--",
                "bash", wsl_script
            ],
            check=True,
            timeout=300
        )

        print("✅ WSL configured successfully.")
        return True

    except subprocess.TimeoutExpired:
        print("❌ WSL configuration timed out.")
        return False

    except subprocess.CalledProcessError as e:
        print(f"❌ WSL configuration failed (exit code {e.returncode}).")
        return False

    except (OSError, ValueError) as e:
        print(f"❌ Unable to prepare WSL script path: {e}")
        return False


def install_packages():
    print("\n📦 Installing Desktop Applications and WSL...")

    # Update choco
    run_choco_command("upgrade chocolatey -y")

    # Install Applications
    run_choco_command("install docker-desktop -y")
    run_choco_command("install brave -y")
    run_choco_command("install wsl2 -y")
    run_choco_command("install vscode -y")
    run_choco_command("install googlechrome -y")
    run_choco_command("install 7zip -y")
    run_choco_command("install git -y")


def install_entertainmment_packages():
    print("\n📦 Installing Desktop Applications and WSL...")

    # Update choco
    run_choco_command("upgrade chocolatey -y")
    
    # Install device drivers
    run_choco_command("install nvidia-display-driver -y")
    run_choco_command("install amd-ryzen-chipset-driver -y")
    run_choco_command("install realtek-hd-audio-driver -y")
    run_choco_command("install intel-chipset-device-software -y")

    # Install Applications
    run_choco_command("install lghub -y")
    run_choco_command("install slack -y")
    run_choco_command("install steam -y")
    run_choco_command("install zwift -y")
    run_choco_command("install xbox -y")

def main():
    # install_chocolatey()
    install_packages()
    # update_hosts_file()

    if not is_wsl_ready():
        install_ubuntu_2404()

    configure_wsl()
    # flush_dns_cache()
    # clear_recycle_bin()
    print("\n🎉 Done! Your Packages are installed.")

if __name__ == "__main__":
    main()
