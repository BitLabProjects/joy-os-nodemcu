# Introduction
JoyOS is an operating system for the IoT, with a focus on modularity and fast development cycle.

The main application for JoyOS is for things that are relatively simple and self contained, exposing a clean command-based interface that allow more complex devices to harvest informations or operate them.

The first supported platform is the Esp8266 with NodeMCU firmware. This combination was chosen because the Esp8266 is both diffused and cheap, and the NodeMCU firmware has a low barrier for prototyping with the lua scripting language, which is high level and can be easily programmed over the air.

The communication between JoyOS and the outside world is performed using MQTT over WiFi.