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
    private var earthModel: Earth? = nil

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

        // Set the scene to the view
        sceneView.scene = scene

        earthModel = Earth(radius: ViewController.EARTH_RADIUS)
        
        /** Load Satellites  **/
        earthModel?.addSatellite(
            Satellite(
                model: "1RU-GenericCubesat",
                orbit: KeplerianOrbit(
                    apoapsis: 1 + 500.0 / 6400.0,
                    periapsis: 1 + 475.0 / 6400.0,
                    inclination: 0,
                    longitudal: 0,
                    mu: Earth.muScaled)))

        earthModel?.addSatellite(
            Satellite(
                model: "1RU-GenericCubesat",
                orbit: KeplerianOrbit(
                    apoapsis: 1 + 517.0 / 6400.0,
                    periapsis: 1 + 497.0 / 6400.0,
                    inclination: 0,
                    longitudal: 0,
                    mu: Earth.muScaled)))

        earthModel?.addSatellite(
            Satellite(
                model: "1RU-GenericCubesat",
                orbit: KeplerianOrbit(
                    apoapsis: 1 + 687.0 / 6400.0,
                    periapsis: 1 + 442.0 / 6400.0,
                    inclination: 0,
                    longitudal: 0,
                    mu: Earth.muScaled)))

        earthModel?.addSatellite(
            Satellite(
                model: "1RU-GenericCubesat",
                orbit: KeplerianOrbit(
                    apoapsis: 1 + 35793 / 6400.0,
                    periapsis: 1 + 35778 / 6400.0,
                    inclination: Float.pi / 2,
                    longitudal: 0,
                    mu: Earth.muScaled)))

        /** END load satellites **/

        // Configure offset
        earthModel?.position = SCNVector3(0, 0, -ViewController.OFFSET)

        if let earthModel = earthModel {
            self.sceneView.pointOfView?.addChildNode(earthModel)
        }

        let tapRecognizer = UITapGestureRecognizer(
           target: self, action: #selector(handleTap))

       // Set number of taps required
       tapRecognizer.numberOfTouchesRequired = 1

       // Adds the handler to the scene view
       sceneView.addGestureRecognizer(tapRecognizer)
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        if let earthModel = earthModel {
            earthModel.removeFromParentNode()
            if let node = self.sceneView.pointOfView {
                earthModel.position =
                    node.position +
                    self.sceneView.scene.rootNode.convertVector(
                        SCNVector3(0, 0, -ViewController.OFFSET), from: node)
            }
            self.sceneView.scene.rootNode.addChildNode(earthModel)
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
