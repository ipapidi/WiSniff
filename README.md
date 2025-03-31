<p align="center">
  <img src="logo.png" width="100" alt="WiSniff logo"/>
</p>

# WiSniff

**WiSniff** is a minimalistic GUI tool for Linux that helps you:
- Put your network card into monitor mode
- Maintain internet access on your primary adapter
- Easily switch between sniffing and normal modes
- Choose interfaces and SSIDs from a dropdown
- View live status in a simple graphical window

---

## Features
- Monitor mode activation with one click
- GUI made with YAD
- Dropdowns for card selection and SSID
- Preserves normal Wi-Fi while sniffing with second adapter
- Automatically reconnects to Wi-Fi network
- Custom desktop launcher and icon
- `.desktop` integration

---

## Requirements

- Linux Mint, Kali, or similar Debian-based distro
- YAD (`sudo apt install yad`)
- `aircrack-ng`, `iw`, and `nmcli` tools installed
- Monitor-mode capable adapter

---

## Installation

### Option 1: Git Clone

```bash
git clone https://github.com/ipapidi/WiSniff.git
cd WiSniff
chmod +x wisniff.sh
./wisniff.sh

> WiSniff is designed for Debian-based Linux systems (tested on Linux Mint).
