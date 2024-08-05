import os
import time
from subprocess import call, CalledProcessError

# Define the threshold battery level
THRESHOLD = 10

# Function to get current battery level
def get_battery_level():
    try:
        with open("/sys/class/power_supply/BAT0/capacity", "r") as file:
            battery_level = int(file.read().strip())
        return battery_level
    except Exception as e:
        print(f"Error reading battery level: {e}")
        return None

# Function to beep
def beep():
    duration = 0.1  # seconds
    freq = 1000  # Hz
    for _ in range(3):
        try:
            call(["beep", "-f", str(freq), "-l", str(int(duration * 1000))])
        except CalledProcessError as e:
            print(f"Error during beep: {e}")
        time.sleep(0.2)

# Main loop
while True:
    battery_level = get_battery_level()
    if battery_level is not None and battery_level <= THRESHOLD:
        beep()
    time.sleep(60)  # Check every 60 seconds