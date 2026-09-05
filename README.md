<img width="1920" height="1080" alt="Frame 6" src="https://github.com/user-attachments/assets/ff6231be-5797-4b97-8fbd-3a3ff1ccffa9" />


# TiltOSC

[![License](https://img.shields.io/github/license/wol-existss/TiltOSC)](https://github.com/wol-existss/TiltOSC) [![GitHub Issues](https://img.shields.io/github/issues/wol-existss/TiltOSC)](https://github.com/wol-existss/TiltOSC/issues) [![Last Commit](https://img.shields.io/github/last-commit/wol-existss/TiltOSC)](https://github.com/wol-existss/TiltOSC/commits/main) [![Stars](https://img.shields.io/github/stars/wol-existss/TiltOSC)](https://github.com/wol-existss/TiltOSC/stargazers) [![Repo Size](https://img.shields.io/github/repo-size/wol-existss/TiltOSC)](https://github.com/wol-existss/TiltOSC)

TiltOSC is an hyper-efficient, low-latency OSC pipeline that converts your phone's motion sensor data into usable controller output, whether that be for racing games, simulators, and any app or game that supports a gamepad.

## Table of Contents

- [How does it work?](#how-does-it-work)
- [Why OSC? Why not Bluetooth?](#why-osc-why-not-bluetooth)
- [Feature checklist](#feature-checklist)
- [Getting Started](#getting-started)
    - [Desktop client installation](#desktop-client-installation)
    - [Desktop client usage](#desktop-client-usage)
    - [Mobile client installation](#mobile-client-installation)
    - [Android installation](#android-installation)
    - [Mobile client usage](#mobile-client-usage)
- [Other information](#other-information)
    - [Why does TiltOSC require a desktop server and a mobile client?](#why-does-tiltosc-require-a-desktop-server-and-a-mobile-client)
    - [What is under the hood?](#what-is-under-the-hood)
    - [Why Godot?](#why-godot)
- [Third-Party Software & Licenses](#third-party-software--licenses)
- [I've encountered an issue, what now?](#ive-encountered-an-issue-what-now)

## How does it work?

TiltOSC uses your phone's accelerometer and gyroscope to determine the orientation of the device. From there, the data is sent via OSC to the desktop server, where it is converted into mouse movements, joystick inputs, wheel rotations, and more! If you don't want to use the phone's motion sensors as controls, you can also use TiltOSC as a normal controller app without using the tilt functionality for various games.

## Why was it created?
TiltOSC was originally created to be a stand-in for a physical steering wheel. Such apparatus can be expensive and I wasn't sure if I would even stick with such a hobby.TiltOSC is a continuation of a lost project called PhoneSteer that tried to fill that gap That version had memory leaks, was slow and annoying to use, and depended on a paid, proprietary mobile app, whereas TiltOSC is built from the ground up using 100% open source software.

## Why OSC? Why not Bluetooth?

OSC sends data directly through a dedicated port in raw text. This means that, in nature, TiltOSC has almost no noticeable latency. Bluetooth, on the other hand, introduces significant latency due to practices such as packet scheduling, frequency hopping, among others.

## Feature checklist

**Settings and customization**

- [x] V-sync toggle in settings menu
- [x] Multiple polling rates — 30, 60, 90, 120, unlimited
- [x] Calibration system (landscape, clockwise, reset, quick-calibration)
- [x] Broadcast-kill functionality

**Control scheme**

- [x] Full controller layout
- [x] Face button cluster (Y/X/B/A)
- [x] D-pad
- [x] Shoulder buttons and analog-style triggers
- [x] Dual joysticks

**Desktop client**

- [x] Full desktop launcher UI
- [x] Bridge between desktop UI and backend (JSON config + process management)
- [x] Configurable backend controller emulator
- [x] Start / Stop / Restart backend controls
- [x] Live network address indicator

# Getting Started

# Desktop client installation
First, ensure you have ViGEm BUS installed. If you don't already have it, [you can grab the latest version here](https://github.com/nefarius/ViGEmBus/releases)

To install the desktop client, download the corresponding zip file from the latest release. Once it has been downloaded, you should see the `TiltOSC.exe` file. Opening this will summon the Desktop launcher.


_**Note: the zip must be extracted for the launcher to work.**_[^1]

## Desktop client usage

Once you have entered, you may choose your settings and click "Start TiltOSC" to commence the controller emulation background process. TiltOSC will stay alive even if the launcher is closed, and can either be quit by pressing "Stop TiltOSC" in the launcher or forcefully stopping the `tilt_osc.exe` process in Task Manager.

Advanced users may bind the OSC signals to professional software, but it is *not* the intended use of TiltOSC.

# Mobile client installation

## Android installation

To begin, ensure that "Install unknown apps" is enabled. The app installation should be relatively easy. Click or press and hold the APK in your device's file manager until a popup menu appears with an option to install it. This varies from device to device.

## iOS installation
Unfortunately, at this time, there is **not** a native iOS build due to the weirdly restrictive developer program. If you have a machine running a modern version of macOS, you can either download the XCode project files or clone the repository to perform the build using XCode or Godot respectively.
Advanced users may install the compiled app onto a jailbroken device to achieve regular functionality.

## Mobile client usage

The mobile client ***must*** be configured before it can connect. To begin, click the settings button at the bottom right corner of the screen. Where the box states "Destination," enter the IP and port shown on the desktop client and press the save button.[^2]

Then, you can set your polling rate. Note that the polling rate will be capped at your display's refresh rate unless "Enable VSync" is disabled.[^3]

You'll see a space for calibrating TiltOSC. It's recommended to calibrate at least once each time TiltOSC is opened, either by clicking the calibration buttons in the settings menu or with the quick-calibration button available in the main menu at the top-middle of the screen.

## Other information

### Why does TiltOSC require a desktop server and a mobile client?

The mobile client sends OSC packets. The packets are not actually capable of performing actions on their own. Because of this, the desktop client reads the incoming packets and converts them into mouse movement, joystick output, etc.

### What is under the hood?

The mobile client uses Godot to write and send OSC packets, while the desktop backend is written in Python. The desktop launcher (settings UI, process management) is a native C++/Qt application. The mobile client sends OSC packets using godOSC. Joystick and controller output is emulated using vgamepad and ViGEmBus.

### Why Godot?

The mobile client uses Godot because it features everything needed; it can send OSC packets, and it has an expansive library of buttons, sliders, checkboxes, and more. Godot also facilitates easy porting to desktop, Android, iOS, and alternative Linux-based mobile operating systems.

### Does this affect performance?
The main TiltOSC script consumes around 20 mb of RAM on average. It is extremely lightweight and consumes a negligible amount of CPU resources. The launcher can also be closed and TiltOSC's backend can remain open.

## Third-Party Software & Licenses

### Integrated Dependencies

These libraries are integrated into TiltOSC or are linked:
### Mobile
- **godOSC** is used under the CC0-1.0 License (public domain dedication)
### Desktop back end
- **python-osc** is used under the Unlicense
- **numpy** is used under the BSD 3-Clause License
- **vgamepad** is used under the MIT License
- **pystray** is used under the GNU Lesser General Public License v3 (LGPLv3)
- **Pillow** is used under the MIT-CMU License
- **six** is used under the MIT License
- **Qt6** (Core, Gui, Widgets, Qml, Quick, QmlModels, Network, Debug) is used under the GNU Lesser General Public License v3 (LGPLv3), via dynamic linking
### Drivers required by TiltOSC
- **ViGEmBus** is used under the MIT License



A copy of the LGPLv3 license text can be found at [gnu.org/licenses/lgpl-3.0.en.html](https://www.gnu.org/licenses/lgpl-3.0.en.html).

### Development Tools
The following tools were used to build TiltOSC but are not bundled or linked into downloadable builds:

- **Godot Engine** is used under the MIT License (mobile client development)
- **Qt Design Studio** is used under the GNU Lesser General Public License v3 (LGPLv3) / open-source terms (UI design and certain C++ libraries for desktop launcher)
- **PyInstaller** is used under the GPLv2

## I've encountered an issue, what now?

[^1]: **`TiltOSC.exe` won't open, or nothing happens when you click it.** Ensure the folder is unzipped. Navigate into the `_internal` folder and launch `LauncherApp.exe` directly. If launching LauncherApp.exe directly fixes the issue, the issue is very likely specific to the outer launcher wrapper. Please open a GitHub issue with details on your OS version and the steps you took.

[^2]:"The mobile client won't connect to the desktop client!"
[^2]:Various things can cause this:
[^2]:- One or both devices are connected to a VPN
[^2]:- A firewall is applied to one or either device
[^2]:- The ports on either device don't match
[^2]:- The devices aren't connected to the same Wi-Fi network
[^2]:The IP displayed is a best-guess based off of its reachability. If you're sure that none of the above caused this, open terminal and run:
[^2]:`ipconfig`
[^2]:Try each of the adapters' IPs displayed. 

Please note that, in some rare cases, i.e., on public networks, devices are *not* permitted to communicate with each other. In such cases, TiltOSC may not function correctly. There is a low chance that switching to port 443 or 53 will fix this, but OSC routing over internet will be added in a future release.

[^3]: "**VSync won't disable / polling rate seems capped regardless of settings.**" On some devices with certain graphics drivers, VSync cannot be disabled at the system level, and Godot will fall back to your display's refresh rate. This is unfortunately not within my control.


