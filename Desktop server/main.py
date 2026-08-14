# PythonOSC
import pythonosc
from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import BlockingOSCUDPServer
# Numpy
import numpy as np

# Debug
debug = False
gravity_frames = 0
gyro_frames = 0
buffer_length = 100

# Latest sensor values
latest_gravity = np.zeros(3)
latest_gyro = np.zeros(3)

def gravity_handler(address, *args):
    global gravity_frames
    global latest_gravity
    latest_gravity = np.array(args)
    gravity_frames += 1
    if gravity_frames >= buffer_length and debug:
        gravity_frames = 0
        print(f"{address}: {args}")

def gyro_handler(address, *args):
    global gyro_frames
    global latest_gyro
    latest_gyro = np.array(args)
    gyro_frames += 1
    if gyro_frames >= buffer_length and debug:
        gyro_frames = 0
        print(f"{address}: {args}")


"""
OSC handling
"""

# dispatcher
dispatcher = Dispatcher()
dispatcher.map("/gravity", gravity_handler)
dispatcher.map("/gyro", gyro_handler)

# OSC server
server = BlockingOSCUDPServer(("0.0.0.0", 4646), dispatcher)
server.serve_forever()