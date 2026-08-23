<img width="3090" height="838" alt="Untitled" src="https://github.com/user-attachments/assets/d6f2648e-76ba-47a7-a06e-5c2c71d43826" />

TiltOSC is a two part application that converts your phone's motion sensors into usable controller output.

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
- [ ] Add menu restructuring system
- [ ] Add a popup system for certain settings, i.e., "The polling rate will be limited to your display's current refresh rate unless V-sync is disabled."
- [ ] Add a "don't show again" button to warnings
- [ ] Add a configuration reset button
- [ ] Depend on gyroscope for orientation
- [ ] Flip wheel wraparound
- [ ] Flip pitch wraparound
- [ ] Add a button to pause tracking to prevent soft locking the python program
#### Warnings
- [ ] V-sync: **Disabling** V-sync may cause performance issues on certain devices. Proceed at your own risk. **Enabling** V-sync will limit the polling rate to your display's refresh rate.
- [ ] Enabling gyroscope dependence causes cross-talk, resulting in random escalations in pitch when reaching extreme rotations when rotating wheel-wise.
#### Control scheme
- [ ] Each button, slider, etc. is assigned a number. From the desktop, each input will have a value and intractable number, allowing easy configuration
##### Buttons
- [ ] Basic button
- [ ] Persistent slider
- [ ] Temporary slider
- [ ] Toggle switch
- [ ] Toggle button
### Desktop client
- [ ] Add modes for interpretation of data (i.e., wheel turn, pitch only, all axis)
- [ ] Add refresh limiter
- [ ] Add configuration menu to assign a key bind or action to each axis or intractable button
- [ ] Add joystick and wheel emulation as options for wheel tilt
- [ ] Add joystick emulation as option for all axis 
- [ ] Add a kill and/or pause key bind to prevent the app from soft locking the device

## Other information

### Why does TiltOSC require a desktop server *and* a mobile client?
The mobile client sends OSC packets. The packets are not actually capable of performing actions on their own. Thus, the desktop client reads the incoming packets and converts them into mouse movement, joystick output, etc.

### What is under the hood?
The mobile client uses Godot to write and send OSC packets, while the desktop server uses Python. The mobile client sends OSC packets using GodOSC.

#### Why Godot?
The mobile client uses Godot because it features everything needed. It can send OSC packets, it has an expansive library of buttons, sliders, check-boxes, and more. Godot also facilitates easy porting to desktop, Android, iOS, and alternative Linux-based mobile operating systems.

The desktop client's backend is programmed using Python, yet the UI uses Godot. This is to ensure maximal stability, continuity between the UI's appearance, and because Godot alone is incapable of emulating wheel and joystick outputs.

