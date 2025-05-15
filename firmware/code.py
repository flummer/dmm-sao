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
from adafruit_progressbar.progressbar import HorizontalProgressBar

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

# Make the display contexts
logo = displayio.Group()
bitmap = displayio.OnDiskBitmap("/hxrdk.bmp")
tile_grid = displayio.TileGrid(bitmap, pixel_shader=bitmap.pixel_shader)
logo.append(tile_grid)
progressbar = HorizontalProgressBar((0, 63), (display.width, 1), bar_color=0xffffff, fill_color=0x0, border_thickness=0, margin_size=0, value=0)
logo.append(progressbar)
display.root_group = logo

progressbar.value = 5

caution = displayio.Group()
bitmap = displayio.OnDiskBitmap("/caution.bmp")
tile_grid = displayio.TileGrid(bitmap, pixel_shader=bitmap.pixel_shader)
caution.append(tile_grid)

progressbar.value = 10

text = "Caution"
caution_caption = label.Label(smallfont, text=text, color=0xFFFF00, x=40, y=15)
caution.append(caution_caption)

progressbar.value = 15

text = "Read manual"
manual_caption = label.Label(smallfont, text=text, color=0xFFFF00, x=40, y=45)
caution.append(manual_caption)

progressbar.value = 20

# Resistance, LED and Continuity panel
res_panel = displayio.Group()
text = "-"
res_caption = label.Label(smallfont, text=text, color=0xFFFF00, x=0, y=10)
res_panel.append(res_caption)

text = "OL"
res_measurement = label.Label(bigfont, text=text, color=0xFFFF00, x=40, y=32)
res_panel.append(res_measurement)

progressbar.value = 30

# Vin panel
vin_panel = displayio.Group()
text = "Vin"
vin_caption = label.Label(smallfont, text=text, color=0xFFFF00, x=0, y=10)
vin_panel.append(vin_caption)

text = "-"
vin_measurement = label.Label(bigfont, text=text, color=0xFFFF00, x=40, y=32)
vin_panel.append(vin_measurement)

progressbar.value = 40

# I/O panel
io_panel = displayio.Group()
text = "I/O Digital"
io_caption = label.Label(smallfont, text=text, color=0xFFFF00, x=0, y=10)
io_panel.append(io_caption)

text = "GPIO1"
io1_caption = label.Label(smallfont, text=text, color=0xFFFF00, x=0, y=30)
io_panel.append(io1_caption)

text = "GPIO2"
io2_caption = label.Label(smallfont, text=text, color=0xFFFF00, x=0, y=50)
io_panel.append(io2_caption)

progressbar.value = 50

text = ""
io1 = label.Label(smallfont, text=text, color=0xFFFF00, x=60, y=30)
io_panel.append(io1)

text = ""
io2 = label.Label(smallfont, text=text, color=0xFFFF00, x=60, y=50)
io_panel.append(io2)

progressbar.value = 60

# I2C panel
i2c_panel = displayio.Group()
text = "I2C"
i2c_caption = label.Label(smallfont, text=text, color=0xFFFF00, x=0, y=10)
i2c_panel.append(i2c_caption)
text = ""
i2c_output1 = label.Label(smallfont, text=text, color=0xFFFF00, x=0, y=30)
i2c_panel.append(i2c_output1)
text = ""
i2c_output2 = label.Label(smallfont, text=text, color=0xFFFF00, x=0, y=50)
i2c_panel.append(i2c_output2)

progressbar.value = 70

# Pre rendering text strings (while showing logo)
res_caption.hidden = True
res_caption.text = "LED"
res_caption.text = "Cont."
res_caption.text = "Cont. L"
res_caption.text = ""
res_caption.hidden = False

progressbar.value = 80

io_caption.hidden = True
io_caption.text = "I/O Analog"
io_caption.text = ""
io_caption.hidden = False

progressbar.value = 85

i2c_caption.hidden = True
i2c_caption.text = "I2C Scanning..."
i2c_caption.text = ""
i2c_caption.hidden = False

progressbar.value = 90

caution_caption.text = "Achtung!"
manual_caption.text = "Handbuch lesen"

progressbar.value = 94

caution_caption.text = "Advarsel!"
manual_caption.text = "Læs vejledning"

progressbar.value = 98

caution_caption.text = "Caution!"
manual_caption.text = "Read manual"

progressbar.value = 100

# Switch to showing caution in EN, DE, DA (cycles until Fn pressed)
display.root_group = caution
caution_sequence = 0

while fn.value:
    if caution_sequence < 30:
        caution_caption.text = "Caution!"
        manual_caption.text = "Read manual"
    elif caution_sequence < 60:
        caution_caption.text = "Achtung!"
        manual_caption.text = "Handbuch lesen"
    else:
        caution_caption.text = "Advarsel!"
        manual_caption.text = "Læs vejledning"

    if caution_sequence > 90:
        caution_sequence = 0

    caution_sequence += 1
    time.sleep(0.05)

main_mode = 0
res_mode = 1
io_mode = 1
i2c_mode = 1

# Main program loop
while True:
    # Handle main mode change and switch to the correct panel (displayio root_group)
    if (enc_a.value & enc_b.value) and main_mode != 1: # Resistance and LED mode
        main_mode = 1
        display.root_group = res_panel
    elif (enc_a.value & (not enc_b.value)) and main_mode != 2: # Vin reading mode
        main_mode = 2
        display.root_group = vin_panel
    elif ((not enc_a.value) & (not enc_b.value)) and main_mode != 3: # GPIO mode
        main_mode = 3
        display.root_group = io_panel
    elif ((not enc_a.value) & enc_b.value) and main_mode != 4: # I2C mode (WIP)
        main_mode = 4
        display.root_group = i2c_panel

    # Update measurement value and handle submode changes
    if main_mode == 1: # Resistance and LED mode
        if res_mode == 1: # Resistance measurement sub mode
            res_caption.text = "Ohm"
            if get_resistance(res_in) > 20000:
                res_measurement.text = "OL"
            elif get_resistance(res_in) > 800:
                res_measurement.text = "%0.1f k" % (get_resistance(res_in)/1000)
            else:
                res_measurement.text = "%0.0f" % (get_resistance(res_in))
        elif res_mode == 2: # LED Test sub mode
            res_caption.text = "LED"
            if get_voltage(res_in) > 3.25:
                res_measurement.text = "OL"
            else:
                res_measurement.text = "%0.2fv" % (get_voltage(res_in))
        elif res_mode == 3: # Continuity sub mode
            res_caption.text = "Cont."
            if get_resistance(res_in) > 20000:
                res_measurement.text = "OL"
            elif get_resistance(res_in) > 800:
                res_measurement.text = "%0.1f k" % (get_resistance(res_in)/1000)
            else:
                res_measurement.text = "%0.0f" % (get_resistance(res_in))
            if get_resistance(res_in) < 50:
                buzzer.duty_cycle = 32000
                rp2040_set_pwm_polarity(3, 1, True)
                buzzer_b.duty_cycle = 32000
            else:
                buzzer.duty_cycle = 0
                rp2040_set_pwm_polarity(3, 1, False)
                buzzer_b.duty_cycle = 0
        elif res_mode == 4: # Continuity with less volumen on the buzzer sub mode
            res_caption.text = "Cont. L"
            if get_resistance(res_in) > 20000:
                res_measurement.text = "OL"
            elif get_resistance(res_in) > 800:
                res_measurement.text = "%0.1f k" % (get_resistance(res_in)/1000)
            else:
                res_measurement.text = "%0.0f" % (get_resistance(res_in))
            if get_resistance(res_in) < 50:
                buzzer.duty_cycle = 32000
            else:
                buzzer.duty_cycle = 0
                buzzer_b.duty_cycle = 0

        if not fn.value:
            res_mode += 1
            if res_mode > 4:
                res_mode = 1
            time.sleep(0.2)

    elif main_mode == 2: # Vin reading mode
        vin_caption.text = "Vin"
        vin_measurement.text = "%0.2fv" % (get_input_voltage(sao_vin))

    elif main_mode == 3: # GPIO mode
        if io_mode == 1: # Digital view sub mode
            io_caption.text = "I/O Digital"
            if get_voltage(gpio1_in) > 2.00:
                io1.text = "HIGH"
            else:
                io1.text = "LOW"
            if get_voltage(gpio2_in) > 2.00:
                io2.text = "HIGH"
            else:
                io2.text = "LOW"
        elif io_mode == 2: # Analog view sub mode
            io_caption.text = "I/O Analog"
            io1.text = "%0.2fv" % (get_voltage(gpio1_in))
            io2.text = "%0.2fv" % (get_voltage(gpio2_in))

        if not fn.value:
            io_mode += 1
            if io_mode > 2:
                io_mode = 1
            time.sleep(0.2)

    elif main_mode == 4: # I2C mode (WIP)
        if i2c_mode > 5:
            # scan
            i2c_caption.text = "I2C Scanning..."

            found_count = 0
            try:
                sao_bus = busio.I2C(board.SAO_SCL, board.SAO_SDA)
                while not sao_bus.try_lock():
                    pass

                i2c_output1.text = ""
                i2c_output2.text = ""

                print("Scanning SAO I2C bus:")
                for device_address in sao_bus.scan():
                    if found_count < 4:
                        i2c_output1.text = i2c_output1.text + hex(device_address) + "  "
                    elif found_count < 8:
                        i2c_output2.text = i2c_output2.text + hex(device_address) + "  "
                    print("Found:", hex(device_address))
                    found_count += 1

                sao_bus.unlock()
                sao_bus.deinit()
                if found_count > 0:
                    i2c_caption.text = "I2C Found:"
                else:
                    i2c_caption.text = "I2C None found!"
            except Exception as e:
                    i2c_caption.text = "I2C Error:"
                    i2c_output1.text = "Got exception"
                    i2c_output2.text = "Check wiring"
                    print("Exeption: ", e)

            time.sleep(2)

            while fn.value:
                time.sleep(0.05)

            i2c_output1.text = ""
            i2c_output2.text = ""
            i2c_mode = 1
        else:
            # sniff
            i2c_caption.text = "I2C"
            i2c_output1.text = "Hold Fn to start scan"
            i2c_output2.text = ""

        if not fn.value:
            i2c_mode += 1
            time.sleep(0.2)
        else:
            i2c_mode = 1

    time.sleep(0.05)