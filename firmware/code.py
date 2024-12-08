# This file is part of the SAO DMM project (https://github.com/flummer/dmm-sao)
#
# SPDX-FileCopyrightText: Copyright (c) 2024 Thomas Flummer for HXR.DK
#
# SPDX-License-Identifier: MIT

import board
import busio
import time
import displayio
import adafruit_displayio_ssd1306
import pwmio
import memorymap
from analogio import AnalogIn
from digitalio import DigitalInOut, Direction, Pull
from adafruit_display_text import label
from adafruit_bitmap_font import bitmap_font

# Pin usage:
# -------------------------
# Screen SCL: GPIO15 / DISPLAY_SCL
# Screen SDA: GPIO14 / DISPLAY_SDA
# Buzzer A: GPIO22 / BUZZER_A
# Buzzer B: GPIO23 / BUZZER_B
# Vin Measure: A3 / GPIO29 / MEASURE_VIN
# Res Measure: A2  / GPIO28 / MEASURE_RES
# ENC_A: GPIO16 / ENC_A
# ENC_B: GPIO17 / ENC_B
# Fn: GPIO18 / BUTTON_FN
# SAO SCL: GPIO5 / SAO_SCL
# SAO SDA: GPIO4 / SAO_SDA
# SAO GPIO1: A0 / GPIO26 / SAO_GPIO1
# SAO GPIO2: A1 / GPIO27 / SAO_GPIO2

## Release display, as Circuitpython will be using it during reboot when saving
displayio.release_displays()

# Initialize display I2C
i2c_screen = busio.I2C(board.DISPLAY_SCL, board.DISPLAY_SDA)
display_bus = displayio.I2CDisplay(i2c_screen, device_address=0x3C)
display = adafruit_displayio_ssd1306.SSD1306(display_bus, width=128, height=64, rotation=180)

# Initialize SAO I2C (doesn't work at this stage, as there are no pullups unless connected to a badge)
#i2c_sao = busio.I2C(board.SAO_SCL, board.SAO_SDA)

# Load fonts (need to be on the device flash)
bigfont = bitmap_font.load_font("firecracker40.bdf")
smallfont = bitmap_font.load_font("firecracker16.bdf")

# Setup different pins
gpio1_in = AnalogIn(board.SAO_GPIO1)
gpio2_in = AnalogIn(board.SAO_GPIO2)

res_in = AnalogIn(board.MEASURE_RES)
sao_vin = AnalogIn(board.MEASURE_VIN)

enc_a = DigitalInOut(board.ENC_A)
enc_a.direction = Direction.INPUT
enc_b = DigitalInOut(board.ENC_B)
enc_b.direction = Direction.INPUT

fn = DigitalInOut(board.BUTTON_FN)
fn.direction = Direction.INPUT
fn.pull = Pull.UP

# Configure the two buzzer pins to use a frequency of 1333 Hz, and both channels to off
buzzer = pwmio.PWMOut(board.BUZZER_A, frequency = 1333, duty_cycle = 0)
buzzer_b = pwmio.PWMOut(board.BUZZER_B, frequency = 1333, duty_cycle = 0)

# Helper functions to calculate voltages and resistance from the analog readings using constants matching the resistor dividers in the hardware
def get_voltage(pin):
    return (pin.value * 3.3) / 65536

def get_resistance(pin):
    if pin.value < 65536:
        return -(pin.value * 100) / (pin.value - 65536)
    else:
        return 100000

def get_input_voltage(pin):
    return ((pin.value-32250) * 3.3) / 10642

# Helper function to invert the B channel of the PWM slice used to control the buzzer. When used, the buzzer will be louder.
def rp2040_set_pwm_polarity(sliceNo, channel, invert):
    pwm_csr = memorymap.AddressRange(start = 0x40050000 + 0x14 * sliceNo, length = 0x4)
    pwm_ctrl = int.from_bytes(pwm_csr[0:4], "little")
    if invert:
        pwm_ctrl = pwm_ctrl | 0x1 << (2 + channel)
    else:
        pwm_ctrl = pwm_ctrl & ~(0x1 << (2 + channel))
    pwm_csr[0:4] = pwm_ctrl.to_bytes(4, "little")

# Make the display context
splash = displayio.Group()
display.root_group = splash

# Draw a label
text = "-"
caption = label.Label(smallfont, text=text, color=0xFFFF00, x=0, y=10)
splash.append(caption)

text = "-"
measurement = label.Label(bigfont, text=text, color=0xFFFF00, x=40, y=32)
splash.append(measurement)

text = ""
io1caption = label.Label(smallfont, text=text, color=0xFFFF00, x=0, y=30)
splash.append(io1caption)

text = ""
io2caption = label.Label(smallfont, text=text, color=0xFFFF00, x=0, y=50)
splash.append(io2caption)

text = ""
io1 = label.Label(smallfont, text=text, color=0xFFFF00, x=60, y=30)
splash.append(io1)

text = ""
io2 = label.Label(smallfont, text=text, color=0xFFFF00, x=60, y=50)
splash.append(io2)

res_mode = 1
io_mode = 1

# Main program loop
while True:
    if enc_a.value & enc_b.value: # Resistance and LED mode
        if res_mode == 1: # Resistance measurement sub mode
            caption.text = "Ohm"
            if get_resistance(res_in) > 20000:
                measurement.text = "OL"
            elif get_resistance(res_in) > 800:
                measurement.text = "%0.1f k" % (get_resistance(res_in)/1000)
            else:
                measurement.text = "%0.0f" % (get_resistance(res_in))
        elif res_mode == 2: # LED Test sub mode
            caption.text = "LED"
            if get_voltage(res_in) > 3.25:
                measurement.text = "OL"
            else:
                measurement.text = "%0.2fv" % (get_voltage(res_in))
        elif res_mode == 3: # Continuity sub mode
            caption.text = "Cont."
            if get_resistance(res_in) > 20000:
                measurement.text = "OL"
            elif get_resistance(res_in) > 800:
                measurement.text = "%0.1f k" % (get_resistance(res_in)/1000)
            else:
                measurement.text = "%0.0f" % (get_resistance(res_in))
            if get_resistance(res_in) < 20:
                buzzer.duty_cycle = 32000
                rp2040_set_pwm_polarity(3, 1, True)
                buzzer_b.duty_cycle = 32000
            else:
                buzzer.duty_cycle = 0
                rp2040_set_pwm_polarity(3, 1, False)
                buzzer_b.duty_cycle = 0
        elif res_mode == 4: # Continuity with less volumen on the buzzer sub mode
            caption.text = "Cont. L"
            if get_resistance(res_in) > 20000:
                measurement.text = "OL"
            elif get_resistance(res_in) > 800:
                measurement.text = "%0.1f k" % (get_resistance(res_in)/1000)
            else:
                measurement.text = "%0.0f" % (get_resistance(res_in))
            if get_resistance(res_in) < 20:
                buzzer.duty_cycle = 32000
            else:
                buzzer.duty_cycle = 0
                buzzer_b.duty_cycle = 0
        io1caption.text = ""
        io2caption.text = ""
        io1.text = ""
        io2.text = ""
        if not fn.value:
            res_mode += 1
            if res_mode > 4:
                res_mode = 1
            time.sleep(0.2)

    elif enc_a.value & (not enc_b.value): # Vin reading mode
        caption.text = "Vin"
        measurement.text = "%0.2fv" % (get_input_voltage(sao_vin))
        io1caption.text = ""
        io2caption.text = ""
        io1.text = ""
        io2.text = ""

    elif (not enc_a.value) & (not enc_b.value): # GPIO mode
        if io_mode == 1: # Digital view sub mode
            caption.text = "I/O digital"
            measurement.text = ""
            io1caption.text = "GPIO1"
            io2caption.text = "GPIO2"
            if get_voltage(gpio1_in) > 2.00:
                io1.text = "HIGH"
            else:
                io1.text = "LOW"
            if get_voltage(gpio2_in) > 2.00:
                io2.text = "HIGH"
            else:
                io2.text = "LOW"
        elif io_mode == 2: # Analog view sub mode
            caption.text = "I/O analog"
            measurement.text = ""
            io1caption.text = "GPIO1"
            io2caption.text = "GPIO2"
            io1.text = "%0.2fv" % (get_voltage(gpio1_in))
            io2.text = "%0.2fv" % (get_voltage(gpio2_in))
        if not fn.value:
            io_mode += 1
            if io_mode > 2:
                io_mode = 1
            time.sleep(0.2)

    elif (not enc_a.value) & enc_b.value: # I2C mode (WIP)
        caption.text = "I2C"
        measurement.text = ""

    time.sleep(0.05)