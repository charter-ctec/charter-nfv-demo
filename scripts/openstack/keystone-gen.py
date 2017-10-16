import signal
import subprocess

import time   # For the demo only

def signal_handler(signal, frame):
    global interrupted
    interrupted = True

signal.signal(signal.SIGINT, signal_handler)


interrupted = False
while True:
    subprocess.call(["openstack", "token", "issue"])
    print("Token Recieved! Continuing unless instructed otherwise...")
    time.sleep(1)
    print("Requesting new token:")

    if interrupted:
        print("Keystone is going to drop a messy load. Don't say I didn't warn you!")
        break
