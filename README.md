<p align="center">
  <img src="icon.png" width="100" alt="WiSniff logo">
</p>

<h1 align="center">WiSniff</h1>

<p align="center">
  A minimalist Linux GUI for enabling Wi-Fi monitor mode while keeping your internet connection active.
</p>

---

## Features

<table>
  <tr>
    <th>Feature</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>Graphical Interface</td>
    <td>Built with YAD for simplicity and ease of use</td>
  </tr>
  <tr>
    <td>Secure Password Input</td>
    <td>Hidden input field for Wi-Fi credentials</td>
  </tr>
  <tr>
    <td>Live Status Feedback</td>
    <td>Detects if any interface is already in monitor mode</td>
  </tr>
  <tr>
    <td>Custom Interface Selection</td>
    <td>Select your internet and sniffing interfaces independently</td>
  </tr>
  <tr>
    <td>Launcher Support</td>
    <td>Includes .desktop file and custom icon for menu/desktop use</td>
  </tr>
  <tr>
    <td>Hardware Compatibility</td>
    <td>Tested with Realtek-based Alfa adapters (e.g., AWUS036ACH)</td>
  </tr>
</table>

---

## Installation

### Option 1: Clone with Git

```bash
git clone https://github.com/ipapidi/WiSniff.git
cd WiSniff
chmod +x wisniff.sh
./wisniff.sh
```

### Option 2: Download Manually

1. [Download the ZIP](https://github.com/ipapidi/WiSniff/archive/refs/heads/main.zip)
2. Extract the contents
3. Open a terminal in the folder and run:

```bash
chmod +x wisniff.sh
./wisniff.sh
```

---

## Requirements

Install required packages:

```bash
sudo apt update
sudo apt install yad network-manager iw aircrack-ng
```

---

## File Overview

<table>
  <tr>
    <th>File</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><code>wisniff.sh</code></td>
    <td>Main script that launches the GUI</td>
  </tr>
  <tr>
    <td><code>sniff-gui-yad.sh</code></td>
    <td>YAD-based graphical interface logic</td>
  </tr>
  <tr>
    <td><code>WiSniff.desktop</code></td>
    <td>Launcher file for desktop/menu integration</td>
  </tr>
  <tr>
    <td><code>logo.png</code></td>
    <td>Custom icon used in the app menu</td>
  </tr>
  <tr>
    <td><code>README.md</code></td>
    <td>This documentation file</td>
  </tr>
</table>

---

## Usage Notes

- Use the dropdowns in the GUI to select your desired interfaces and SSID
- Internet remains connected via your internal card
- The network card is placed in monitor mode for sniffing
- Works best with Debian-based systems such as Linux Mint and Kali

---

## License

This project is licensed under the MIT License.  
See the [LICENSE](LICENSE) file for full terms.

---

## Disclaimer

This tool is intended for educational and authorized penetration testing use only.  
**Unauthorized sniffing of Wi-Fi traffic is illegal in most jurisdictions. Use responsibly.**

---

## Author

**Ioli Papidi**  
GitHub: [@ipapidi](https://github.com/ipapidi)
