//
//  ViewController.swift
//  Argonautica
//
//  Created by Giorgi Butbaia on 10/3/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    private var space: Space? = nil

    // Configures offset of the planet w.r.t. camera
    private static let OFFSET: Float = 0.2

    // Configures Earth radius
    private static let EARTH_RADIUS: CGFloat = 0.05

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        // Create a new scene
        let scene = SCNScene()

        // TODO: Remove this
        N2YOSatellite.getPosition(25544, 0, 0, 0) { position in print(position) }

        // Set the scene to the view
        sceneView.scene = scene

        space = Space()
        let earthModel = Earth(radius: ViewController.EARTH_RADIUS, space: space)

        // Add satellites
        for (key, value) in Satellites.satellites {
            for sat in value {
                N2YOSatellite.getPosition(UInt(sat["norad"] as! Int), 0, 0, 0) {
                    position in
                    let orbit = KeplerianOrbit(
                        apoapsis: 1 + Float((sat["apogee"] as! Double)/6400.0),
                        periapsis: 1 + Float((sat["perigee"] as! Double)/6400.0),
                        inclination: Float.pi * Float(sat["inclination"] as! Double) / 180.0,
                        longitudal: Float.pi *  Float(sat["ascendingNode"] as! Double) / 180.0, mu: Earth.muScaled,
                        offset: position.azimuth)
                    let satellite = Satellite(model: key, orbit: orbit)
                    earthModel.addSatellite(satellite)
                }
            }
        }

        // Configure offset
        space?.position = SCNVector3(0, 0, -ViewController.OFFSET)

        if let space = space {
            self.sceneView.pointOfView?.addChildNode(space)
        }

        let tapRecognizer = UITapGestureRecognizer(
           target: self, action: #selector(handleTap))

       // Set number of taps required
       tapRecognizer.numberOfTouchesRequired = 1

       // Adds the handler to the scene view
       sceneView.addGestureRecognizer(tapRecognizer)
        
        // Pinch
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        sceneView.addGestureRecognizer(pinch)
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        if let space = space {
            space.removeFromParentNode()
            if let node = self.sceneView.pointOfView {
                space.position =
                    node.position +
                    self.sceneView.scene.rootNode.convertVector(
                        SCNVector3(0, 0, -ViewController.OFFSET), from: node)
            }
            self.sceneView.scene.rootNode.addChildNode(space)
        }
    }
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        guard sender.view != nil else { return }
        if sender.state == .began || sender.state == .changed {
            let pinchScaleX : CGFloat = sender.scale * CGFloat((space!.scale.x))
            let pinchScaleY : CGFloat = sender.scale * CGFloat((space!.scale.y))
            let pinchScaleZ : CGFloat = sender.scale * CGFloat((space!.scale.z))
            space!.scale = SCNVector3(Float(pinchScaleX), Float(pinchScaleY), Float(pinchScaleZ))
            sender.scale = 1.0
        }
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

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
