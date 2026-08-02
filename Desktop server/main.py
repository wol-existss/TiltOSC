import pythonosc
from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import BlockingOSCUDPServer

wheel_frames = 0
pitch_frames = 0
buffer_length = 100

def wheel_handler(address, *args):
    global wheel_frames
    wheel_frames += 1
    if wheel_frames >= buffer_length:
        wheel_frames = 0
        print(f"{address}: {args}")

def pitch_handler(address, *args):
    global pitch_frames
    pitch_frames += 1
    if pitch_frames >= buffer_length:
        pitch_frames = 0
        print(f"{address}: {args}")


dispatcher = Dispatcher()
dispatcher.map("/wheel", wheel_handler)
dispatcher.map("/pitch", pitch_handler)

server = BlockingOSCUDPServer(("0.0.0.0", 4646), dispatcher)
server.serve_forever()