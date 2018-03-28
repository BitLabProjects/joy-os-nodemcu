# Introduction
JoyOS is an operating system for the IoT, with a focus on modularity and fast development cycle.

The main application for JoyOS is for things that are relatively simple and self contained, exposing a clean command-based interface that allow more complex devices to harvest informations or operate them.

The first supported platform is the Esp8266 with NodeMCU firmware. This combination was chosen because the Esp8266 is both diffused and cheap, and the NodeMCU firmware has a low barrier for prototyping with the lua scripting language, which is high level and can be easily programmed over the air.

The communication between JoyOS and the outside world is performed using MQTT over WiFi.

# Setup guide (Windows)
## Obtaining a NodeMCU firmware
The NodeMCU firmware is customizable, a build can be obtained from https://nodemcu-build.com/
Use the following characteristics:
**branch**: master
**modules**: adc, encoder, file, GPIO, MQTT, net, node, pwm, sjson, timer, UART, WiFi
**FatFS**: enabled
When the build is ready, an email will be sent. The email will contain two builds: integer and float. JoyOS prefers the float build.
## Flashing the NodeMCU firmware
There is more than one tool to flash an Esp8266, here we'll use esptool.py which is officially supported by Espressif. You will need Python, either 2.7 or 3.4+, installed on your machine.

Open a console and install esptool from pypi using one of the following commands:

`pip install esptool`

`python -m pip install esptool`

`pip2 install esptool`

Then from the folder containing the firmware previously built, type the following commands replacing the correct values for your situation:

`esptool.py --port <COM port> write_flash -fm dio -fs 32m 0x00000 <yourfirmwarename>.bin`

An example firmware file name is:

`nodemcu-master-12-modules-2017-12-10-17-05-48-float.bin`

This should be enough. If the Esp8266 already contains a firmware that uses an sdk version different than the one of the NodeMCU build, a full erase and calibration data initialization might be needed. Refer to NodeMCU documentation for additional info: http://nodemcu.readthedocs.io/en/latest/en/flash/

## Uploading JoyOS
Again also for lua scripts uploading there is more than one tool: we'll use nodemcu-uploader. Why all these console tools? Batching!

..And again it's a python script, available through pypi (try all the commands like before if this does not work):

`pip install nodemcu-uploader`

Then to upload the files:

`nodemcu-uploader --port <COM port> upload init.lua`

Run the command for all the core files, which are:
`init.lua, joy_os.lua, lua_utils.lua`

*TODO: Provide a clean startup with blinking led and an hello console message, then expand below for mqtt*

## TODO: Setting up an MQTT server
## TODO: Using JoyExplorer to talk to JoyOS