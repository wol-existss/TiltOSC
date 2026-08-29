<img width="3090" height="838" alt="Untitled" src="https://github.com/user-attachments/assets/d6f2648e-76ba-47a7-a06e-5c2c71d43826" />

## TiltOSC
TiltOSC is an efficient and streamlined OSC pipeline that converts your phone's motion sensor data into usable controller output.

## How does it work?
TiltOSC uses your phone's accelerometer and gyroscope to determine the orientation of the device. From there, the data is sent via OSC to the desktop server, where it is converted into mouse movements, joystick inputs, wheel rotations, and more!

## Why OSC? Why not Bluetooth?
OSC sends data directly through a dedicated port in raw text. This means that, in nature, TiltOSC has almost no noticeable latency. Bluetooth, on the other hand, introduces significant latency due to a practices such as packet scheduling, frequency hopping, among others.

## How feature complete is TiltOSC?
A feature checklist for TiltOSC is as follows:

#### Settings and customization
- [X] Add a V-sync toggle to settings menu
- [x] Add different polling rates - 30, 60, 120, unmetered...
- [x] Enable button numbering - Somewhat complete
- [x] Add a calibration system
- [x] Add a broadcast-kill functionality
#### Control scheme
- [x] Full controller layout
##### Buttons
- [x] Basic button
- [x] Button cluster
- [x] DPad
- [x] Left/right triggers and shoulder buttons
- [x] Joystick
### Desktop client
- [x] Full desktop UI
- [ ] Bridge between desktop UI and backend
- [x] Configurable back end controller emulator
- [x] Translation for all inputs
- [x] Emulation pause system

## Other information

### Why does TiltOSC require a desktop server *and* a mobile client?
The mobile client sends OSC packets. The packets are not actually capable of performing actions on their own. Thus, the desktop client reads the incoming packets and converts them into mouse movement, joystick output, etc.

### What is under the hood?
The mobile client uses Godot to write and send OSC packets, while the desktop server uses Python. The mobile client sends OSC packets using GodOSC. Joystick movements are emulated using ViGEm Bus.

#### Why Godot?
The mobile client uses Godot because it features everything needed. It can send OSC packets, it has an expansive library of buttons, sliders, check-boxes, and more. Godot also facilitates easy porting to desktop, Android, iOS, and alternative Linux-based mobile operating systems.

The desktop client's backend is programmed using Python, yet the UI uses Godot. This is to ensure maximal stability, continuity between the UI's appearance, and because Godot alone is incapable of emulating wheel and joystick outputs.

