# Table of Contents
* Abstract
* [Introduction](#1-introduction)
* [Related Work](#2-related-work)
* [Technical Approach](#3-technical-approach)
* [Evaluation and Results](#4-evaluation-and-results)
* [Discussion and Conclusions](#5-discussion-and-conclusions)
* [References](#6-references)

# Abstract

For our project, we aimed to create a smart home system as well as a system of smart plugs to allow the user to simply turn lights and other products on and off with simple gestures. In order to measure our success, we chose to evaluate the final system based on how well different gestures were successfully recognized and how well those gestures triggered the expected events (turning lights on and off).  We used existing work from AprilTags, ARKit and gesture recognition as the foundation of our algorithm to accomplish our goals.  We implemented ARKit to recognize a user's position and orientation as well as AprilTags to uniquely identify different elements around the space and the user's relative position and orientation to those objects.  We also utilized machine learning and gesture recognition to allow users to turn smart plugs on and off without having to stand up or use their voice.  Results are somewhat promising since our system is sometimes able to recognize gestures and correctly turn lights on and off.  However, our system can be improved with additional automation of the AprilTag recognition between the iPhone and MATLAB as well as the improvement of gesture recognition within a specified range.  Our current system suffers in terms of latency since we often experience a delay between the gesture and the switch being triggered.  We see this work as a potential first step to create a more complex system that would allow anyone who does not want to have to verbally communicate with their smart home the same accessibility as those who are currently asking Alexa or Google to complete tasks for them. 

# 1. Introduction

## Motivation & Objective:
Most current smart home systems are focused on voice recognition and voice commands.  Those who are deaf or hard of hearing (DHH) struggle to use such devices since they cannot interact with Alexa, Siri, or Google Home is quite the same way.  Therefore, we attempted to bridge this gap by creating a system that would afford DHH people the same ease and convenience with smart devices as people who can hear.  

For our project, we used Apple's ARKit to create a system to track the user's position and orientation relative to different smart plugs alongside the RP2040 microcontroller to recognize gestures to turn those plugs on and off.

## State of the Art & Its Limitations:
Today, most smart home systems are not focused on people who cannot or who would prefer not to use their voices to activate smart devices.  As an alternative, people can use their phones as a "remote control" device to allow them to access their smart devices from a "hub" much like they would with a voice controlled assistant.  However, this limits DHH people to needing their phone on them at all times.    

## Novelty & Rationale:
Our approach is to combine wearable devices with existing smart home technology to eliminate the need for voice control and / or a phone application.  We foresee that our system could be expanded to an AR headset rather than a phone alongside a smartwatch or other wearable that would allow users to perform gestures while simply looking or "aiming" at the device they wish to activate.  Our proposed system would allow much more control and fluidity during daily life.

## Potential Impact:
While our final project is still in the early stages, it shows the potential for an even better system with more advanced technology.  A successful version of this project would allow for all users, whether a part of the DHH community or not, to control their smart home devices more easily, without interrupting their daily life.  Rather than having to stop a conversation or pause a television show to turn the lights off, a user could simply turn their head and perform a small gesture to dim the lights.  More generally, this kind of system could be expanded to allow users to customize their living spaces further: preheating the oven from the couch or turning on the sprinklers from bed, all without having to touch their phones. 

## Challenges:
This project involved many challenging components.  A key challenge was implementing the gesture recognition within a small range of motion.  Since we wanted these gestures to be rather small so they could be done easily from wherever a person was located, we did not want to require the users to perform large gestures.  However, smaller gestures led to more errors since small bumps or unintended motions were sometimes read as the gesture.  Another challenge was streaming the position and orientation data from both the phone and the RP2040 to a webhook for real time processing.  Because we chose to sample this data at one frame per second, there is the potential for error due to gaps leading to undetected motion. 

## Requirements for Success:
To perform the project, we required an iPhone, Apple's ARKit, a RP2040 microcontroller, a set of smart plugs, and several AprilTags.  Knowledge of Swift alongside ARKit and machine learning to create a gesture recognition system that is accurate with small gestures is also required.  Teams would also need to be able to coordinate position and orientation of both the phone and the microcontroller (in our case a RP2040) to keep track of whether a gesture was being performed and which device it was "aimed" at.

## Metrics of Success:
Finally, in order to assess our success in meeting our objectives, we first ensured that we were able to properly recognize the AprilTags from the iPhone and send over position and orientation data to a webhook. Next, we compiled this data with the position and orientation data from the RP2040.  Using this system, we were able to create rectangular direction "scopes" that represented a device being "aimed" at a specific smart plug.  Another metric of success we utilized was the gesture recognition accuracy.  Altogether, if the device was in that range and a gesture was performed, we would then expect to see the desired outcome.  Our final metric of success was how often this desired outcome would occur.  

# 2. Related Work

In recent years, there have been multiple proposals for different smart home systems that would allow users control of their smart devices without voice control.  Previous works dived into using AI for Accessibility but focused on removing the voice commands in favor of phone commands.  Newer works looking into AR for smart homes presented more aligned with our goals.  

For example, in 2020, Ozarkar et. al. attempted to use pose estimation algorithms to recognize sounds and "translate" them into sign language words and sentences to improve communication for the DHH community.  They proposed an application that would capture different sounds in the daily life such as vehicles or sirens and convert those into alerts for DHH users.  Alternatively, they also proposed a way to convert sign language into text and speech for non-deaf people to understand.  Their solution found that quick gestures, multiple subjects in frame and noisy environments produced fluctuating results.  Taking from their work and previous research into the DHH community, we decided that an accessible smart home system for the DHH community would focus on gestures since those are most closely related to sign language. 

We also looked at the work done by Bempong et. al. which determined that there are currently no perfect solutions.  It looked at applications that would require the user have access to their phone to adjust different settings.  Bempong et. al. also determined that IFTTT would be a workaround solution.  We decided to integrate this component into our project but automate the process so the user would not have to manually trigger the IFTTT action to turn the lights on and off.

The work of Seo et. al. and Mahroo et. al. both attempted to utilize a hybrid/mixed reality framework to allow users to interact with smart home devices through augmented objects.  Both groups choose to align virtual objects over real objects so users can communicate with them.  To simplify this system, we chose to design a system that would not rely solely on augmenting reality.   

To create a more seamless experience for the user, we decided that in our system, rather than a user's reality being altered, we would simply define gestures that a user could perform to interact with their smart home devices.  This would easily allow a user to relax without the virtual objects obscuring their view and would still provide them access to their smart home devices.

# 3. Technical Approach

Our approach is to leverage Apple's ARKit, AprilTags and a machine learning based gesture recognition system to create a novel gesture based smart home system without the need for voice control.  For our technical approach, we aim to leverage the RP2040's LSM6DSOX's ML layer to recognize geatures, ARkit's accurate SLAM position and oreitnation tracking to track position, and APRILtag's unique tracking capabilities to make this possible. 

## Hardware Implementation

* RP2040
* iPhone (WiFi Connected)
* Smart Home Plugs with lights/other devices plugged into them

## Software Implementation

In order of execution in implementation:
* ARKit + AprilTag recognition:
  * to establish the position and orientation data of the user (aka the iPhone) 
* Gesture recognition system:
  * to recognize gestures conducted with the RP2040 utalizing the ML core of the accelerometer/gyroscope chip (LSM6DSOX) and STMICRO's GUI interface to generate and run a         decision tree 
* Image Capture and Digital Processing:
  * utilize Swift to capture images and send those over via email
  * images are then utilized within MATLAB to capture absolute and relative positioning in comparison with the AprilTag (using the AprilTag package)
* IFTTT / Webhooks in conjunction with Smart Home Plugs:
  * finally, use webhooks to aggregate the data from the previous steps and tell the smart home plugs when to turn on or off

## Image Capturing and Digital Processing

We utilized ARKit to recognize different AprilTags linked to different smart home plugs.  

We initially attempted to use the ESP32 CAM devices to recognize different AprilTags instead, but found that the ESP32 CAMs had very limited resolution.  Because of the limited resolution, we found that there was not enough capacity on the ESP32 CAM to do both the image capturing and the apriltag recognition.

We chose to focus our time instead on using the iPhone camera to recognize the AprilTags.  We were also able to use the iPhone to track the location and orientation of the user.  ARKit was able to accurately recognize the AprilTags most of the time (it would get confused occasionally with a few AprilTags).  When ARKit properly recognized an AprilTag, we would tap the screen to send an email with the iPhone's location, orientation and a photo of the AprilTag.

From there, we would pass the image and location coordinates into a MATLAB script designed to process the AprilTag and tell us the positioning of the AprilTag. We would use the positions of each AprilTag as waypoints for the system (fixed locations of the smart plugs / devices).  Once per second, we would send the iPhone's current location and orientation to a webhook.  From that webhook, we used IFTTT to compile that data into a Google Sheet.  

From these positions, we would then be able to utilize the iPhone's current location and orientation to determine if the iPhone was "pointed at" one of the smart home devices / plugs.  If the iPhone was pointed at a plug, we would listen for a gesture using IFTTT.  

## Gesture Recognition Model and Training

We utilized Arduino IDE and RP2040 to create a gesture recognition model using STMICROELECTRONIC's UNICO GUI to generate the decision tree..  We initially attempted to define 4 different states (idle, walking, on/off, and all on/all off).  Unfortunately, due to the sensitivity of the RP2040, we found that the on/off gesture was being triggered too frequently.  Because of that, we chose to narrow the number of gestures in the model to 3 with a more robust idle condition. The final product is generated using a idle states trained on a recorded data set of no action, slow walking, and some movement. We also tried injecting gaussian noise into the dataset which improved the decision tree's bounds but did not improve the overall performance upon test. At the end we settled on a window of 52 samples(half a second) and use the features mean and varaicne for all three axis of the accelerometer. The gyroscope proved difficult to work with when training the model. In the end it is able to recognize side to side movement , up and down flick movement, and idle state. The details for the tree is in "testfin tree.txt"


# 4. Evaluation and Results

We set up the system with the iPhone modeling an "AR headset" and the Arduino modeling a "wearable device" in a system with two smart plugs places at two different points in the space.

The iPhone remains connected to the laptop to allow the ARKit code to continuously run.  We left the RP2040 connected to a separate laptop to allow the Arduino code to run simultaneously.  The smart plugs were placed at different points in the space to allow the iPhone a margin of error in determining which direction the device was "pointed at."  

To test out our project, we decided to measure the success of each part of the system. 

We first tested the iPhone's ability to identify different AprilTags.  Across 4 different tags, the iPhone had an accuracy rate of 87.5% (when conducting 10 tests of each tag).  

These results are fairly promising.  At no point did the iPhone ever not recognize a tag had been captured.  The iPhone would occasionally mis-identify which tag was in its line of sight or identify a tag as two different tags.  The iPhone was especially likely to confuse tag 16h5_00001 as 16h5_00000.  This indicates that with a wider variety of tags, especially ones from different AprilTag families, we can expect a higher accuracy rate.  This is also promising since the iPhone's ability to recognize AprilTags is only important during the initial setup of the system.

Next, we chose to test MATLAB's ability to recognize the iPhone's screenshots of the AprilTags.  When running 5 tests on 3 different AprilTags (15 screenshots total), we found that the MATLAB script was able to recognize 13 of those 15 screenshots.  Of the two that were not able to be recognized, one was determined to be too far away (the MATLAB script relies on the AprilTag being within a certain distance) and the other was confused with another AprilTag (again of the same family).  

Then, we chose to test the ability of the iPhone's orientation and location to properly trigger the smart home plugs when they should be triggered.  We found that the bounds of the devices were rather sensitive and that if the iPhone was pointed just outside that range, it would not trigger the lights properly.  

Our last test of an individual component was to test whether the RP2040 could properly turn the lights on and off without the use of the iPhone.  Upon recognized gestures, the device was able to properly turn the smart home plugs on and off.  However, there were occasions when gestures were not performed but the system was rather sensitive and still triggered the smart home plugs.

Finally, we tested the entire system combined.  We found that the results warrant future work.  While our system does suffer from a rather tedious setup process (which we hope would be automated in future work), once the system is setup, it tends to perform decently other than the latency issue.  The smart home plugs are triggered a bit more often than one would like due to the sensitivity of the gestures.  Additionally, one has to be a bit closer to the smart home plugs than we initially hoped due to the imprecision of the boundaries we places around each plug.  The largest issue is the delay between a gesture occuring and the switch triggering.  However, overall, the system is able to conveniently recognize gestures and allow the user to turn the lights on and off without voice commands or flipping the switch manually.


# 5. Discussion and Conclusions

The results show that our simple smart home system relying on gestures rather than voice functions to correctly (albeit slowly) perform the desired qualities of the most basic smart home system (turning devices on and off).  

We believe that the latency comes from the Arduino in conjunction with the IFTTT code to determine the orientation of the device.  We hope that this can be improved upon in future iterations of this type of smart home system.  

From the data collected, we were able to make some conclusions:

We found that due to the latency issue and the required proximity to trigger the switches that this system did not quite reach our desired specifications.  We hope that in the future, with more resources and a more fine-tuned algorithm, this system can be created to work as we originally hoped.

## Future Steps

The first logical future step would be to deal with the latency issue.  

Secondly, the system should be fully automated.  At this time, we are able to send an image of the AprilTag from the iPhone via email.  However, due to Google's security and privacy policies, we were unable to directly download these attachments and funnel them through the MATLAB AprilTag recognition.  A future work would utilize OAuth 2.0 to link these pieces without the need for manual download. Once we have that in place we will be able to use the MTLAB engine to run files automatically through a python script. 

Another logical future step would be to increase the number of devices that the system is able to keep track of.  Rather than only using 2 smart home plugs, a future work would include more than 2 smart devices that are separated by conical spaces based on position and orientation of the user.  We currently only separate the general space into two sections, one for each plug.

Next, we also see a future work utilizing an AR headset along with a wearable device for gesture recognition.  This would allow users to more seamlessly integrate this technology into their lives. We have already seen that geature recongition can convey a variety of meanings and can allow users to voicelessly convey meaning to machine. For example a recent paper by Siyou Pei et al. of UCLA was able to interact with 24 hand based objects in AR/VR in the paper "Hand Interfaces: Using Hands to Imitate Objects in AR/VR for Expressive Interactions." adding directionality to the equation would allow a user to more specifically interact with similar or different devices. 

# 6. References
AprilTags: https://april.eecs.umich.edu/software/apriltag

AprilTags 3 (pre-generated): https://github.com/AprilRobotics/apriltag

Apple ARKit Documentation: https://developer.apple.com/documentation/arkit

Apple ARKit 2D Image Detection: https://developer.apple.com/documentation/arkit/content_anchors/detecting_images_in_an_ar_experience

Apple ARKit 3D Coordinates / Motion Guide: https://support.apple.com/guide/motion/intro-to-3d-coordinates-motn17c66fd6/mac 

Apple SceneKit Euler Angles: https://developer.apple.com/documentation/scenekit/scnnode/1407980-eulerangles

ESP32 CAM AprilTag: https://github.com/stnk20/esp32-Apriltag

ESP32 CAM AprilTag UCLA Lemur Blog: https://uclalemur.com/blog/determining-the-ideal-resolution-for-apriltag-detection

IFTTT Documentation: https://ifttt.com/docs

IFTTT Webhooks FAQ: https://help.ifttt.com/hc/en-us/articles/115010230347

MATLAB readAprilTag: https://www.mathworks.com/help/vision/ref/readapriltag.html

Bempong, J., Stainslow, J., Behm, G. (2015). Accessible Smart Home System for the Deaf and Hard-of- Hearing. https://www.rit.edu/ntid/nyseta/sites/rit.edu.ntid.nyseta/files/docs/fullpapers_PDFs/StanislowJoeFullPaper.pdf. 

Mahroo, A., Greci, L., Sacco, M. (2019). HoloHome: An Augmented Reality Framework to Manage the Smart Home. In: De Paolis, L., Bourdot, P. (eds) Augmented Reality, Virtual Reality, and Computer Graphics. AVR 2019. Lecture Notes in Computer Science(), vol 11614. Springer, Cham. https://doi.org/10.1007/978-3-030-25999-0_12

Ozarkar, S., Chetwani, R., Devare, S., Haryani, S., & Giri, N. (2020). AI for Accessibility: Virtual Assistant for Hearing Impaired. 2020 11th International Conference on Computing, Communication and Networking Technologies (ICCCNT). doi:10.1109/icccnt49239.2020.9225392

Sanchez-Comas, A., Synnes, K., Hallberg, J. (2020). Hardware for Recognition of Human Activities: A Review of Smart Home and AAL Related Technologies. Sensors 2020, 20(15), 4227. https://doi.org/10.3390/s20154227

Seo, D., Kim, H., Kim, J., Lee, J. (2016). Hybrid reality-based user experience and evaluation of a context-aware smart home. https://doi.org/10.1016/j.compind.2015.11.003.

Pei, Siyou, et al. “Hand Interfaces: Using Hands to Imitate Objects in AR/VR for Expressive Interactions.” CHI Conference on Human Factors in Computing Systems, 2022, https://doi.org/10.1145/3491102.3501898. 
