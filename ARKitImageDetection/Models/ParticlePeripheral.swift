//
//  ParticlePeripheral.swift
//  ARKitImageDetection
//
//  Created by Alyssa Chew on 11/15/22.
//  Copyright © 2022 Apple. All rights reserved.
//
// for BLE attempt - not utilized

import UIKit
import CoreBluetooth

class ParticlePeripheral: NSObject {

    /// Particle LED services and charcteristics Identifiers

    public static let particleLEDServiceUUID     = CBUUID.init(string: "1A3AC130-31EE-758A-BC50-54A61958EF81") // needs to be arduino to connect to phone
    public static let redLEDCharacteristicUUID   = CBUUID.init(string: "9A48ECBA-2E92-082F-C079-9E75AAE428B1")
    public static let greenLEDCharacteristicUUID = CBUUID.init(string: "9A48ECBA-2E92-082F-C079-9E75AAE428B1")
    public static let blueLEDCharacteristicUUID  = CBUUID.init(string: "9A48ECBA-2E92-082F-C079-9E75AAE428B1")

}

