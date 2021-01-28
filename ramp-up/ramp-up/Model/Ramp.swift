//
//  Ramp.swift
//  ramp-up
//
//  Created by Igor Vaz on 28/01/21.
//

import Foundation
import SceneKit

class Ramp: SCNNode {
    class func getPipe() -> SCNNode {
        return getNode(rampName: "pipe", scale: SCNVector3Make(0.002, 0.002, 0.002), position: SCNVector3Make(1, 0.5, -1))!
    }
    
    class func getPyramid() -> SCNNode {
        return getNode(rampName: "pyramid", scale: SCNVector3Make(0.005, 0.005, 0.005), position: SCNVector3Make(1, -0.9, -1))!
    }
    
    class func getQuarter() -> SCNNode {
        return getNode(rampName: "quarter", scale: SCNVector3Make(0.005, 0.005, 0.005), position: SCNVector3Make(1, -2.8, -1))!
    }
}

extension SCNNode {
    fileprivate static func getNode(rampName: String, scale: SCNVector3, position: SCNVector3) -> SCNNode? {
        guard let scene = SCNScene(named: "art.scnassets/\(rampName).dae") else { return nil }
        guard let node = scene.rootNode.childNode(withName: rampName, recursively: true) else { return nil }
        node.scale = scale
        node.position = position
        return node
    }
    
    func startRotation() -> SCNNode {
        let rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1))
        self.runAction(rotateAction)
        return self
    }
}
