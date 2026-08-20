# PythonOSC
import pythonosc
from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import BlockingOSCUDPServer
# Numpy
import numpy as np
# misc libraries
import math
import time

# Debug
debug = False
gravity_frames = 0
gyro_frames = 0
buffer_length = 100
debug_wheel = True

# Latest sensor values and angles
latest_gravity = np.zeros(3)
latest_gyro = np.zeros(3)

# Wheel calibration
wheel_angle_offset = 0.0
wheel_angle_scale = 1.0

wheel_angle = 0.0
last_update_time = time.time()

# Gravity handler
def gravity_handler(address, *args):
    global gravity_frames
    global latest_gravity
    latest_gravity = np.array(args)
    gravity_frames += 1
    if gravity_frames >= buffer_length and debug:
       pass
       gravity_frames = 0
       print(f"{address}: {args}")

#Gyro handler and wheel calculations
def gyro_handler(address, *args):
    global gyro_frames
    global latest_gyro
    global wheel_angle
    global last_update_time

    latest_gyro = np.array(args)

    now = time.time()
    delta = now - last_update_time
    last_update_time = now

    gx, gy, gz = latest_gravity
    gyro_z = latest_gyro[2]

    accel_wheel_angle = (math.atan2(gy, gx) / math.pi + 0.5)
    accel_wheel_angle = ((accel_wheel_angle + 1.0) % 2.0) - 1.0

    wheel_angle = 0.65 * (wheel_angle + (gyro_z * delta / math.pi)) + 0.35 * accel_wheel_angle
    wheel_angle = ((wheel_angle + 1.0) % 2.0) - 1.0

    gyro_frames += 1
    if gyro_frames >= buffer_length and debug_wheel:
        gyro_frames = 0
        print(f"wheel_angle: {wheel_angle}")

## Calibration handlers
def landscape_handler(address, *args):
    global wheel_angle_offset
    wheel_angle_offset = wheel_angle
    print(f"landscape_handler: {wheel_angle_offset}")

def cw_handler(address, *args):
    global wheel_angle_scale
    raw_at_90 = wheel_angle - wheel_angle_offset
    if raw_at_90 != 0:
        wheel_angle_scale = 0.5 / raw_at_90
    print(f"cw_handler: {wheel_angle_scale}")

# OSC dispatcher mapping
dispatcher = Dispatcher()
dispatcher.map("/gravity", gravity_handler)
dispatcher.map("/gyro", gyro_handler)
dispatcher.map("/landscape", landscape_handler)
dispatcher.map("/cw", cw_handler)

# OSC server
server = BlockingOSCUDPServer(("0.0.0.0", 4646), dispatcher)
server.serve_forever()