# Heather

## Resources for the Heather project. A master thesis project by Mai Hartmann

This repository holds the code resources for the project, and a guide of how to setup the Raspberry Pi whish runs the project, together with two Arduino's. It is not a total rundown of the project, and how it was made. :-/

## Parts used in the project:
- Raspberry Pi 4B (8GB RAM version)
- 5" HDMI display for raspberry pi
- USB-c power supply for Raspberry Pi
- micro HDMI to HDMI cable
- USB keyboard and mouse
- 2 x Arduino Uno boards
- 2 x USB cables for arduino Uno
- MPR121 touch controller (for arduino)
- Vibration motor (for Arduino)
- Over-ear headphone
- A painting by Mai Hartmann
- Conductive ink, tape, jumper cables etc.

## The setup

### Raspberry Pi
- Interfaces the two Arduinos, and outputs a soundscape based on the input from the user interactions on the touch sensors

### Arduino MPR121 - touch sensors
- This arduino takes care of sending touch data to the Raspberry Pi

### Arduino Vibration motor
- The Raspberry Pi sends vibration commands to this Arduino, that then makes the motot vibrate

## Setting up the Raspberry Pi
Start with a new and updated version of the Raspberry Pi OS. Connect the screen, mouse, kayboard, and the two Arduinos to the Raspberry Pi, the boot it up.

Download the Processing files from this repository in the folder Heather_Processing_final, and move them to the desktop of the Raspberry Pi.-

Install Processing using this command in a terminal vwindow:  **curl https://processing.org/download/install-arm.sh | sudo sh**


