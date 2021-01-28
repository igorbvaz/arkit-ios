//
//  RampPlacerViewController.swift
//  ramp-up
//
//  Created by Igor Vaz on 27/01/21.
//

import UIKit
import SceneKit
import ARKit

class RampPlacerViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var buttonsStackView: UIStackView!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    var selectedRamp: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/main.scn")!
        sceneView.autoenablesDefaultLighting = true
        
        // Set the scene to the view
        sceneView.scene = scene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func rampButtonAction(sender: UIButton) {
        let rampPickerViewController = RampPickerViewController(size: CGSize(width: 250, height: 500))
        rampPickerViewController.delegate = self
        rampPickerViewController.modalPresentationStyle = .popover
        rampPickerViewController.popoverPresentationController?.delegate = self
        present(rampPickerViewController, animated: true, completion: nil)
        rampPickerViewController.popoverPresentationController?.sourceView = sender
        rampPickerViewController.popoverPresentationController?.sourceRect = sender.bounds
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: .featurePoint)
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        placeRamp(position: hitPosition)
    }
    
    func placeRamp(position: SCNVector3) {
        if let ramp = selectedRamp {
            ramp.position = position
            ramp.scale = SCNVector3Make(0.01, 0.01, 0.01)
            sceneView.scene.rootNode.addChildNode(ramp)
        }
    }
    
    @IBAction func removeTapped(sender: UIButton) {
        if let ramp = selectedRamp {
            ramp.removeFromParentNode()
            selectedRamp = nil
            buttonsStackView.isHidden = true
        }
    }
    
    @IBAction func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if let ramp = selectedRamp {
            if sender.state == .ended {
                ramp.removeAllActions()
            } else if sender.state == .began {
                switch sender.view {
                case rotateButton:
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
                    ramp.runAction(rotate)
                case upButton:
                    let up = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                    ramp.runAction(up)
                case downButton:
                    let down = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                    ramp.runAction(down)
                default:
                    break
                }
            }
        }
    }
    
}

extension RampPlacerViewController: ARSCNViewDelegate {
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

extension RampPlacerViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension RampPlacerViewController: RampPickerDelegate {
    func didSelectRamp(ramp: SCNNode) {
        selectedRamp = ramp
        buttonsStackView.isHidden = false
    }
}
