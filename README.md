# ecem202a_project
This is a repository for UCLA ECEM202A / CSM213A project: Voiceless Smart Home (A Smart Home System for the Deaf and Hard of Hearing utilizing ARKit alongside a "wearable" device (modeled as a microcontroller)).

The folders are organized as follows:

* doc/ for website content
* software/ for code used in your project
* data/ for data data used in your project

## To use this system:

### What you will need:

- XCode
- Arduino IDE
- RP 2040
- iPhone with iOS 12.0 or above
- MATLAB
- AprilTags
- Kasa Smart Home plugs

### Steps:

1. Download the source code.

2. Open XCode and validate the Team under Signing & Capabilities (Note: the system is compatible with iOS 12.0 and above).  Update the email address to the proper email address on line 491 of the ViewController.

3. Build and run the code for your device (Note: the system cannot be run on an iOS Simulator since ARKit is incompatible with iOS Simulators)

4. Setup your system (utilize 2 or more smart home kasa plugs placed around the space and tag each one with a unique AprilTag roughly 2 in x 2 in in size).

5. Initialize your device by hitting the button in the top right corner of your iPhone screen.

6. Once the session is running, walk around the room to register each device.  When you reach a smart home device, scan the corresponding AprilTag.  Tap to send an email with the screenshot.  

7. Download the screenshot on your computer and run the AprilTag with the corresponding location values through the MATLAB function.

8. Use the output of the MATLAB function as the waypoints (store in a Google Sheets connected to your IFTTT account). 

9. Open Arduino IDE and run the code to recognize gestures.

10. Aim your phone and perform the gestures to turn your kasa smart home plugs on and off.
