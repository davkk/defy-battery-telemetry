import time

import serial

port = "/dev/ttyACM0"
baud_rate = 9600

ser = serial.Serial(port, baud_rate, timeout=1)
print(int(time.time() * 1000), end=" ")


def read(ser):
    return ser.read_until(".".encode("utf-8"))[:-1].strip()


for side in ["left", "right"]:
    ser.write(f"wireless.battery.{side}.level\n".encode("utf-8"))
    print(int(read(ser)), end=" ")

for side in ["left", "right"]:
    ser.write(f"wireless.battery.{side}.status\n".encode("utf-8"))
    print(int(read(ser)), end=" ")

print()
