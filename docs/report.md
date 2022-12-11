# Table of Contents
* Abstract
* [Introduction](#1-introduction)
* [Related Work](#2-related-work)
* [Technical Approach](#3-technical-approach)
* [Evaluation and Results](#4-evaluation-and-results)
* [Discussion and Conclusions](#5-discussion-and-conclusions)
* [References](#6-references)

# Abstract

For our project, we aimed to create a smart home system as well as a system of smart plugs to allow the user to simply turn lights and other products on and off with simple gestures. In order to measure our success, we chose to evaluate the final system based on how well different gestures were successfully recognized and how well those gestures triggered the expected events (turning lights on and off).  We used existing work from AprilTags, ARKit and gesture recognition as the foundation of our algorithm to accomplish our goals.  We implemented ARKit to recognize a user's position and orientation as well as AprilTags to uniquely identify different elements around the space and the user's relative position and orientation to those objects.  We also utilized machine learning and gesture recognition to allow users to turn smart plugs on and off without having to stand up or use their voice.  Results are promising since our system is often able to recognize gestures and correctly turn lights on and off.  However, our system can be improved with additional automation of the AprilTag recognition between the iPhone and MATLAB as well as the improvement of gesture recognition within a specified range.  We see this work as a potential first step to create a more complex system that would allow anyone who does not want to have to verbally communicate with their smart home the same accessibility as those who are currently asking Alexa or Google to complete tasks for them. 

# 1. Introduction

This section should cover the following items:

* Motivation & Objective: What are you trying to do and why? (plain English without jargon)
* State of the Art & Its Limitations: How is it done today, and what are the limits of current practice?
* Novelty & Rationale: What is new in your approach and why do you think it will be successful?
* Potential Impact: If the project is successful, what difference will it make, both technically and broadly?
* Challenges: What are the challenges and risks?
* Requirements for Success: What skills and resources are necessary to perform the project?
* Metrics of Success: What are metrics by which you would check for success?

Most current smart home systems are focused on voice recognition and voice commands.  Those who are deaf or hard of hearing (DHH) struggle to use such devices since they cannot interact with Alexa, Siri, or Google Home is quite the same way.  Therefore, we attempted to bridge this gap by creating a system that would afford DHH people the same ease and convenience with smart devices as people who can hear.  

For our project, we used Apple's ARKit to create a system to track the user's position and orientation relative to different smart plugs alongside the RP2040 microcontroller to recognize gestures to turn those plugs on and off.

Today, most smart home systems are not focused on people who cannot or who would prefer not to use their voices to activate smart devices.  As an alternative, people can use their phones as a "remote control" device to allow them to access their smart devices from a "hub" much like they would with a voice controlled assistant.

However, this limits DHH people to needing their phone on them at all times.  We foresee that our system could be expanded to an AR headset rather than a phone alongside a smartwatch or other wearable that would allow users to perform gestures while simply looking or "aiming" at the device they wish to activate.  Our proposed system would allow much more control and fluidity during daily life.  

While our final project is still in the early stages, it shows the potential for an even better system with more advanced technology.  A successful version of this project would allow for all users, whether a part of the DHH community or not, to control their smart home devices more easily, without interrupting their daily life.  Rather than having to stop a conversation or pause a television show to turn the lights off, a user could simply turn their head and perform a small gesture to dim the lights.  More generally, this kind of system could be expanded to allow users to customize their living spaces further: preheating the oven from the couch or turning on the sprinklers from bed, all without having to touch their phones. 

This project involved many challenging components.  A key challenge was implementing the gesture recognition within a small range of motion.  Since we wanted these gestures to be rather small so they could be done easily from wherever a person was located, we did not want to require the users to perform large gestures.  However, smaller gestures led to more errors since small bumps or unintended motions were sometimes read as the gesture.  Another challenge was streaming the position and orientation data from both the phone and the RP2040 to a webhook for real time processing.  Because we chose to sample this data at one frame per second, there is the potential for error due to gaps leading to undetected motion.

To perform the project, we required an iPhone, Apple's ARKit, a RP2040 microcontroller, a set of smart plugs, and several AprilTags.  We had to learn Swift alongside ARKit and create a gesture recognition system using machine learning that was accurate with small gestures.  We also had to coordinate position and orientation of both the phone and the RP2040 to keep track of whether a gesture was being performed and which device it was "aimed" at.

Finally, in order to assess our success in meeting our objectives, we first ensured that we were able to properly recognize the AprilTags from the iPhone and send over position and orientation data to a webhook. Next, we compiled this data with the position and orientation data from the RP2040.  Using this system, we were able to create rectangular direction "scopes" that represented a device being "aimed" at a specific smart plug.  Another metric of success we utilized was the gesture recognition accuracy.  Altogether, if the device was in that range and a gesture was performed, we would then expect to see the desired outcome.  Our final metric of success was how often this desired outcome would occur.  

# 2. Related Work

# 3. Technical Approach

# 4. Evaluation and Results

# 5. Discussion and Conclusions

# 6. References
