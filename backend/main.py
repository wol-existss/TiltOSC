# PythonOSC
import pythonosc
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

    # Latest sensor readdings
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
    calibrated_angle = max(-1.0, min(1.0, calibrated_angle))  # Clamped due to scale functionality potentially resulting in exceedence of ±1.0

    # Gamepad output
    gamepad.left_joystick_float(x_value_float=calibrated_angle, y_value_float=0.0)
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

# OSC dispatcher mapping
dispatcher = Dispatcher()
dispatcher.map("/gravity", gravity_handler)             # Sensors
dispatcher.map("/gyro", gyro_handler)
dispatcher.map("/landscape", landscape_handler)         # Calibration
dispatcher.map("/cw", cw_handler)
dispatcher.map("/reset", reset_calibration)
dispatcher.map("/kill_desktop", kill_desktop_handler)   # Force quit

# OSC server
server = BlockingOSCUDPServer(("0.0.0.0", 4646), dispatcher)
server.serve_forever()