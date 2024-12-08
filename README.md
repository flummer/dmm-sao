# SAO Digital Multimeter

![SAO Digital Multimeter](https://github.com/flummer/dmm-sao/raw/main/IMAGES/DSC_0814.jpg "SAO Digital Multimeter")

Additional documentation and build log can be found on the [hackaday.io project page for the SAO Digital Multimeter](https://hackaday.io/project/198892-sao-digital-multimeter)

## Features

- Resistance measurement and LED test (including continuity test with a buzzer)
- SAO Input voltage measurement
- SAO GPIO voltage measurement
- I2C info (WIP)


## Firmware

This is designed to run CircuitPython and there is [a custom build](https://github.com/flummer/circuitpython/tree/hxr-sao-dmm) with the needed libraries included, and meaningful pin names for easier development.

A binary build of this is included under `firmware/firmware.uf2` and the application code (`code.py`) and resource files are also in the `firmware` folder.

### Initial programming or CircuitPython updating

- Connect the SAO DMM to a computer usig a USB-C cable and hold down the `Boot` button, when pressing the `Reset` button.
- A new drive should show up called `RPI-RP2`, and you simply copy the `firmware.uf2` file to this drive.
- When the copy is done, the device will disconnect and reboot.
- A new drive will show up named `CIRCUITPY`, and here you need to copy the remaining files in the `firmware` folder to the root folder of the `CIRCUITPY` device.
- The device will not disconnect, but will do one or more reboots, and after that, you are done.

During this, you might be asked or be blocked by your operating system, as sometimes you will need to verify access to new, unknown devices.


## Case and other 3D printed parts

The case and all the button caps, the main knob, and internal spacers to make sure everything sits correctly are designed to be 3D printed with a regular consumer printer. They have been tweaked to be printable with a 0.4mm nozzle, but using a smaller one (eg. 0.2mm) will allow you to use thinner layers, at least in some places, to get a smoother top finnish (top of main knob and top of button caps really benefit from that).

There are also files for a set of 3D printable probes, that are designed to be assembled without any tools, sandwitched around a thin probe wire soldered to a P100-B1 pogo pin for the tip.

There is a `.3mf` file in the `case` folder with a project for BambuLab printers, including 5 plates, one for each color needed.


## Designed in KiCad v8.99 (nightly)

To open the project, you will need to install a recent nightly build (og v9 or newer when released), KiCad v8 or earlier won't open this design directly.

[Electronics schematics as a PDF file](https://github.com/flummer/dmm-sao/blob/main/DMM%20SAO%20Schematics.pdf) is also included for reference.


## License

The hardware design (both electronics and 3D designs) of the `main` branch of this repository is released under the following license:

* the "Creative Commons Attribution-ShareAlike 4.0 International License"
  (CC BY-SA 4.0) full text of this license is included in the LICENSE file
  and a copy can also be found at
  [http://creativecommons.org/licenses/by-sa/4.0/](http://creativecommons.org/licenses/by-sa/4.0/)

The CircuitPython firmware (including the python application code) is released under the MIT license with smaller dependencies under other licenses as detailed in [its LICENSE](https://github.com/flummer/circuitpython/blob/hxr-sao-dmm/LICENSE) and [LICENSE_MicroPython](https://github.com/flummer/circuitpython/blob/hxr-sao-dmm/LICENSE_MicroPython) files.
