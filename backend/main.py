# PythonOSC
from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import BlockingOSCUDPServer
# Numpy
import numpy as np
# vgamepad
import vgamepad as vg
# Misc libraries
import math
import time

# Debug
master_debug = False
debug_gravity = False
debug_gyro = False
debug_wheel = False
debug_calibration = False
debug_controller = False
# Debug buffer
gravity_frames = 0
gyro_frames = 0
buffer_length = 100
# Latest sensor values and outputs
latest_gravity = np.zeros(3)
latest_gyro = np.zeros(3)
wheel_angle = 0.0

# Wheel calibration
wheel_angle_offset = 0.0
wheel_angle_scale = 1.0
calibrated_angle = 0.0

# Gamepad
gamepad = vg.VX360Gamepad()

# Miscellaneous
kill_flag = False

last_update_time = time.time()

# Master debug handler
if master_debug:
    debug_gravity = True
    debug_gyro = True
    debug_wheel = True
    debug_calibration = True

## Settings
# Enable left stick, overwriting the tilt output
use_digital_lstick = True
use_digital_rstick = True

invert_y_axis = True

receive_port = 4646 # OSC packet recieving port

controller_enabled = True

# Button address table for XUSB_BUTTON
button_map = {
    "/y_button": vg.XUSB_BUTTON.XUSB_GAMEPAD_Y,
    "/x_button": vg.XUSB_BUTTON.XUSB_GAMEPAD_X,
    "/b_button": vg.XUSB_BUTTON.XUSB_GAMEPAD_B,
    "/a_button": vg.XUSB_BUTTON.XUSB_GAMEPAD_A,
    "/lb": vg.XUSB_BUTTON.XUSB_GAMEPAD_LEFT_SHOULDER,
    "/rb": vg.XUSB_BUTTON.XUSB_GAMEPAD_RIGHT_SHOULDER,
    "/up_button": vg.XUSB_BUTTON.XUSB_GAMEPAD_DPAD_UP,
    "/down_button": vg.XUSB_BUTTON.XUSB_GAMEPAD_DPAD_DOWN,
    "/left_button": vg.XUSB_BUTTON.XUSB_GAMEPAD_DPAD_LEFT,
    "/right_button": vg.XUSB_BUTTON.XUSB_GAMEPAD_DPAD_RIGHT,
    "/back": vg.XUSB_BUTTON.XUSB_GAMEPAD_BACK,
    "/guide": vg.XUSB_BUTTON.XUSB_GAMEPAD_GUIDE,
    "/start": vg.XUSB_BUTTON.XUSB_GAMEPAD_START,
}

# Gravity handler
def gravity_handler(address, *args):
    global gravity_frames
    global latest_gravity
    latest_gravity = np.array(args)
    gravity_frames += 1
    if gravity_frames >= buffer_length and debug_gravity:
       pass
       gravity_frames = 0
       print(f"{address}: {args}")

# Gyro handler and wheel calculations
def gyro_handler(address, *args):
    global gyro_frames
    global latest_gyro
    global wheel_angle
    global last_update_time
    global calibrated_angle

    latest_gyro = np.array(args)

    # Timer
    now = time.time()
    delta = now - last_update_time
    last_update_time = now

    # Latest sensor readings
    gx, gy, gz = latest_gravity
    gyro_z = latest_gyro[2]

    # Wheel angle calculation math
    accel_wheel_angle = (math.atan2(gy, gx) / math.pi + 0.5)
    accel_wheel_angle = ((accel_wheel_angle + 1.0) % 2.0) - 1.0

    ## Wheel output filter
    wheel_angle = 0.65 * (wheel_angle + (gyro_z * delta / math.pi)) + 0.35 * accel_wheel_angle
    wheel_angle = ((wheel_angle + 1.0) % 2.0) - 1.0

    # Debug
    gyro_frames += 1
    if gyro_frames >= buffer_length and debug_wheel:
        gyro_frames = 0
        print(f"wheel_angle: {wheel_angle}")

    # Offset logic
    calibrated_angle = (wheel_angle - wheel_angle_offset) * wheel_angle_scale
    calibrated_angle = max(-1.0, min(1.0, calibrated_angle))  # Clamped due to scale functionality potentially resulting in exceedance of ±1.0

    # Gamepad output
    if not use_digital_lstick:
        gamepad.left_joystick_float(x_value_float=calibrated_angle, y_value_float=0.0)
        if controller_enabled:
            gamepad.update()

# Calibration handlers
def landscape_handler(address, *args):
    global wheel_angle_offset
    wheel_angle_offset = wheel_angle

    if debug_calibration:
        print(f"landscape_handler: {wheel_angle_offset}")

def cw_handler(address, *args):
    global wheel_angle_scale
    raw_at_90 = wheel_angle - wheel_angle_offset
    if raw_at_90 != 0:
        wheel_angle_scale = 0.5 / raw_at_90
        if debug_calibration:
            print(f"cw_handler: {wheel_angle_scale}")

def reset_calibration(address, *args):
    global wheel_angle_offset
    global wheel_angle_scale
    wheel_angle_offset = 0.0
    wheel_angle_scale = 1.0

    if debug_calibration:
        print("reset_calibration")

def kill_desktop_handler(address, *args):
    print("killed TiltOSC")
    kill_flag = True
    import os
    os._exit(0)

# Controller button handler
# Shared handler for all digital buttons (press/release)
def controller_button_handler(address, *args):
    value = args[0] # Get float from OSC message, where 1.0 is pressed and 0.0 is released.
    xusb_button = button_map[address] # Look up the XUSB_BUTTON value in the table
    # Rounds to nearest 0.5
    if value >= 0.5:
        gamepad.press_button(button=xusb_button)
    else:
        gamepad.release_button(button=xusb_button)
    if controller_enabled:
        gamepad.update()
    # Output if debug calib is on
    if debug_calibration:
        print(f"{address}: {value}")

# Trigger handlers, convert digital input to analogue output
def lt_handler(address, *args):
    value = args[0]  # Get float from OSC message
    gamepad.left_trigger_float(value_float=value)  # Set left trigger position on the virtual gamepad
    if controller_enabled:
        gamepad.update()  # Push the updated trigger state

def rt_handler(address, *args):
    value = args[0] # Same as last function
    gamepad.right_trigger_float(value_float=value)
    if controller_enabled:
        gamepad.update()

# Joystick handlers
def lstick_handler(address, *args):
    # Only used as left stick stand-in if digital_lstick is enabled
    if use_digital_lstick:
        x = args[0] # Extract X and Y axis values (-1.0 to 1.0) from the OSC message
        y = -args[1] if invert_y_axis else args[1]  # Invert Y axis if invert_y_axis is enabled
        gamepad.left_joystick_float(x_value_float=x, y_value_float=y)  # Set left stick position on the virtual gamepad
        if controller_enabled:
            gamepad.update()  # Push the updated stick position to the OS

def rstick_handler(address, *args):
    if use_digital_rstick: # The variable is solely for the settings menu.
        x = args[0]
        y = -args[1] if invert_y_axis else args[1]
        gamepad.right_joystick_float(x_value_float=x, y_value_float=y)
        if controller_enabled:
            gamepad.update()

# OSC dispatcher mapping
dispatcher = Dispatcher()
dispatcher.map("/gravity", gravity_handler)             # Sensors
dispatcher.map("/gyro", gyro_handler)
dispatcher.map("/landscape", landscape_handler)         # Calibration
dispatcher.map("/cw", cw_handler)
dispatcher.map("/reset", reset_calibration)
dispatcher.map("/kill_desktop", kill_desktop_handler)   # Forced termination

## Dispatcher mapping for controller packets

# Handlers for each trigger
dispatcher.map("/lt", lt_handler)
dispatcher.map("/rt", rt_handler)

# Shoulder buttons
dispatcher.map("/lb", controller_button_handler)
dispatcher.map("/rb", controller_button_handler)

# Cluster buttons
dispatcher.map("/y_button", controller_button_handler)
dispatcher.map("/x_button", controller_button_handler)
dispatcher.map("/b_button", controller_button_handler)
dispatcher.map("/a_button", controller_button_handler)

# Directional buttons
dispatcher.map("/up_button", controller_button_handler)
dispatcher.map("/down_button", controller_button_handler)
dispatcher.map("/left_button", controller_button_handler)
dispatcher.map("/right_button", controller_button_handler)

# Joysticks
dispatcher.map("/lstick", lstick_handler)
dispatcher.map("/rstick", rstick_handler)

# Auxiliary buttons
dispatcher.map("/back", controller_button_handler)
dispatcher.map("/guide", controller_button_handler)
dispatcher.map("/start", controller_button_handler)

# OSC server
server = BlockingOSCUDPServer(("0.0.0.0", receive_port), dispatcher)
server.serve_forever()