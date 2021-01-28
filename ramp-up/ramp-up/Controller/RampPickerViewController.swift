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
        
        let pipeNode = Ramp.getPipe().startRotation()
        let pyramidNode = Ramp.getPyramid().startRotation()
        let quarterNode = Ramp.getQuarter().startRotation()
        
        sceneView.scene?.rootNode.addChildNode(pipeNode)
        sceneView.scene?.rootNode.addChildNode(pyramidNode)
        sceneView.scene?.rootNode.addChildNode(quarterNode)
        
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
