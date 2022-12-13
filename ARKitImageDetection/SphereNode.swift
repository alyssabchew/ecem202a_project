//
//  SphereNode.swift
//  ARKitImageDetection
//
//  Created by Alyssa Chew on 11/25/22.
//  Copyright © 2022 Apple. All rights reserved.
//

//
//  SphereNode.swift
//  ArMeasureDemo
//
//  Adopted from code by Igor K on 8/17/17.
//

import SceneKit

class SphereNode: SCNNode {
    init(position: SCNVector3) {
        super.init()
        let sphereGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        material.lightingModel = .physicallyBased
        sphereGeometry.materials = [material]
        self.geometry = sphereGeometry
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
