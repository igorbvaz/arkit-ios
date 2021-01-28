//
//  RampPickerViewController.swift
//  ramp-up
//
//  Created by Igor Vaz on 27/01/21.
//

import UIKit
import SceneKit

protocol RampPickerDelegate: AnyObject {
    func didSelectRamp(rampName: String)
}
class RampPickerViewController: UIViewController {

    var sceneView: SCNView!
    var size: CGSize!
    weak var delegate: RampPickerDelegate?
    
    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = size
        view.frame = CGRect(origin: .zero, size: size)
        sceneView = SCNView(frame: CGRect(origin: .zero, size: size))
        view.insertSubview(sceneView, at: 0)
        
        let scene = SCNScene(named: "art.scnassets/ramps.scn")!
        sceneView.scene = scene
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
        
        let rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1))
        
        let pipeScene = SCNScene(named: "art.scnassets/pipe.dae")
        let pipeNode = pipeScene?.rootNode.childNode(withName: "pipe", recursively: true)
        pipeNode?.scale = SCNVector3Make(0.002, 0.002, 0.002)
        pipeNode?.position = SCNVector3Make(1, 0.5, -1)
        pipeNode?.runAction(rotateAction)
        scene.rootNode.addChildNode(pipeNode!)
        
        let pyramidScene = SCNScene(named: "art.scnassets/pyramid.dae")
        let pyramidNode = pyramidScene?.rootNode.childNode(withName: "pyramid", recursively: true)
        pyramidNode?.scale = SCNVector3Make(0.005, 0.005, 0.005)
        pyramidNode?.position = SCNVector3Make(1, -0.9, -1)
        pyramidNode?.runAction(rotateAction)
        scene.rootNode.addChildNode(pyramidNode!)
        
        let quarterScene = SCNScene(named: "art.scnassets/quarter.dae")
        let quarterNode = quarterScene?.rootNode.childNode(withName: "quarter", recursively: true)
        quarterNode?.scale = SCNVector3Make(0.005, 0.005, 0.005)
        quarterNode?.position = SCNVector3Make(1, -2.8, -1)
        quarterNode?.runAction(rotateAction)
        scene.rootNode.addChildNode(quarterNode!)
        
    }
    
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let position = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(position, options: [:])
        if hitResults.count > 0 {
            guard let node = hitResults.first?.node else { return }
            switch node.name {
            case "pipe", "pyramid", "quarter":
                delegate?.didSelectRamp(rampName: node.name ?? "unknown")
            default:
                break
            }
        }
    }

}
