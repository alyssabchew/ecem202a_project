# Project Proposal

## 1. Motivation & Objective

Most current smart home systems are focused on voice recognition and voice commands.  Those who are deaf or hard of hearing (DHH) struggle to use such devices since they cannot interact with Alexa, Siri, or Google Home is quite the same way.  Therefore, we attempted to bridge this gap by creating a system that would afford DHH people the same ease and convenience with smart devices as people who can hear.  

For our project, we used Apple's ARKit to create a system to track the user's position and orientation relative to different smart plugs alongside the RP2040 microcontroller to recognize gestures to turn those plugs on and off.


## 2. State of the Art & Its Limitations

Today, most smart home systems are not focused on people who cannot or who would prefer not to use their voices to activate smart devices.  As an alternative, people can use their phones as a "remote control" device to allow them to access their smart devices from a "hub" much like they would with a voice controlled assistant.  However, this limits DHH people to needing their phone on them at all times.   


## 3. Novelty & Rationale

Our approach is to combine wearable devices with existing smart home technology to eliminate the need for voice control and / or a phone application.  We foresee that our system could be expanded to an AR headset rather than a phone alongside a smartwatch or other wearable that would allow users to perform gestures while simply looking or "aiming" at the device they wish to activate.  Our proposed system would allow much more control and fluidity during daily life.


## 4. Potential Impact

While our final project is still in the early stages, it shows the potential for an even better system with more advanced technology.  A successful version of this project would allow for all users, whether a part of the DHH community or not, to control their smart home devices more easily, without interrupting their daily life.  Rather than having to stop a conversation or pause a television show to turn the lights off, a user could simply turn their head and perform a small gesture to dim the lights.  More generally, this kind of system could be expanded to allow users to customize their living spaces further: preheating the oven from the couch or turning on the sprinklers from bed, all without having to touch their phones. 


## 5. Challenges

This project involved many challenging components.  A key challenge was implementing the gesture recognition within a small range of motion.  Since we wanted these gestures to be rather small so they could be done easily from wherever a person was located, we did not want to require the users to perform large gestures.  However, smaller gestures led to more errors since small bumps or unintended motions were sometimes read as the gesture.  Another challenge was streaming the position and orientation data from both the phone and the RP2040 to a webhook for real time processing.  Because we chose to sample this data at one frame per second, there is the potential for error due to gaps leading to undetected motion.


## 6. Requirements for Success

To perform the project, we required an iPhone, Apple's ARKit, a RP2040 microcontroller, a set of smart plugs, and several AprilTags.  Knowledge of Swift alongside ARKit and machine learning to create a gesture recognition system that is accurate with small gestures is also required.  Teams would also need to be able to coordinate position and orientation of both the phone and the microcontroller (in our case a RP2040) to keep track of whether a gesture was being performed and which device it was "aimed" at.


## 7. Metrics of Success

Finally, in order to assess our success in meeting our objectives, we first ensured that we were able to properly recognize the AprilTags from the iPhone and send over position and orientation data to a webhook. Next, we compiled this data with the position and orientation data from the RP2040.  Using this system, we were able to create rectangular direction "scopes" that represented a device being "aimed" at a specific smart plug.  Another metric of success we utilized was the gesture recognition accuracy.  Altogether, if the device was in that range and a gesture was performed, we would then expect to see the desired outcome.  Our final metric of success was how often this desired outcome would occur.  


## 8. Execution Plan

Alyssa will be responsible for the ARKit and ESP 32 CAM testing with AprilTags.  Moon will be responsible for the gesture recognition and connecting the gestures to the smart home plugs.  


## 9. Related Work

### 9.a. Papers

#### "AI for Accessibility: Virtual Assistant for Hearing Impaired." 

In 2020, Ozarkar et. al. attempted to use pose estimation algorithms to recognize sounds and "translate" them into sign language words and sentences to improve communication for the DHH community.  They proposed an application that would capture different sounds in the daily life such as vehicles or sirens and convert those into alerts for DHH users.  Alternatively, they also proposed a way to convert sign language into text and speech for non-deaf people to understand.  Their solution found that quick gestures, multiple subjects in frame and noisy environments produced fluctuating results.  Taking from their work and previous research into the DHH community, we decided that an accessible smart home system for the DHH community would focus on gestures since those are most closely related to sign language. 

#### Accessible Smart Home System for the Deaf and Hard-of- Hearing.

We also looked at the work done by Bempong et. al. which determined that there are currently no perfect solutions.  It looked at applications that would require the user have access to their phone to adjust different settings.  Bempong et. al. also determined that IFTTT would be a workaround solution.  We decided to integrate this component into our project but automate the process so the user would not have to manually trigger the IFTTT action to turn the lights on and off.

#### HoloHome: An Augmented Reality Framework to Manage the Smart Home. In: De Paolis, L., Bourdot, P. (eds) Augmented Reality, Virtual Reality, and Computer Graphics.
The work of Mahroo et. al. attempted to utilize a hybrid/mixed reality framework to allow users to interact with smart home devices through augmented objects.  Both groups choose to align virtual objects over real objects so users can communicate with them.  To simplify this system, we chose to design a system that would not rely solely on augmenting reality.   

### 9.b. Datasets

We plan to use the AprilTags previously generated to allow us to recognize "waypoints" in our space and fix our lights or other devices to those points.  This will allow us to attach different devices to specific AprilTags that can be customized for the individual user's space. 


### 9.c. Software

List software that you have identified and plan to use. Provide references (with full citation in the References section below).

We plan to use MATLAB or another software package in conjunction with the AprilTags to properly identify the AprilTag as well as its distance from the user (in this case, the iPhone).

We plan to use Arduino in place of a wearable device to recognize gestures performed by the user. 

We plan to use ARKit (with an iPhone) in place of an AR headset to constantly track the user's position and what direction / orientation the user is facing.  If the user is within certain bounds, we will check for a recognized gesture to trigger the lights or other devices to turn on and off.  We will also use ARKit to define the way points where the lights / devices are located when the system is first set up.  In this case, we will follow the 2D Image Detection tutorial linked below. 

## 10. References

AprilTags: https://github.com/AprilRobotics/apriltag-imgs

ARKit: https://developer.apple.com/documentation/arkit/

ARKit 2D Image Detection: https://developer.apple.com/documentation/arkit/content_anchors/detecting_images_in_an_ar_experience

Bempong, J., Stainslow, J., Behm, G. (2015). Accessible Smart Home System for the Deaf and Hard-of- Hearing. https://www.rit.edu/ntid/nyseta/sites/rit.edu.ntid.nyseta/files/docs/fullpapers_PDFs/StanislowJoeFullPaper.pdf. 

Mahroo, A., Greci, L., Sacco, M. (2019). HoloHome: An Augmented Reality Framework to Manage the Smart Home. In: De Paolis, L., Bourdot, P. (eds) Augmented Reality, Virtual Reality, and Computer Graphics. AVR 2019. Lecture Notes in Computer Science(), vol 11614. Springer, Cham. https://doi.org/10.1007/978-3-030-25999-0_12

MATLAB (AprilTags): https://www.mathworks.com/help/vision/ref/readapriltag.html

Ozarkar, S., Chetwani, R., Devare, S., Haryani, S., & Giri, N. (2020). AI for Accessibility: Virtual Assistant for Hearing Impaired. 2020 11th International Conference on Computing, Communication and Networking Technologies (ICCCNT). doi:10.1109/icccnt49239.2020.9225392
