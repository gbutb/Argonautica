//
//  Earth.swift
//  Argonautica
//
//  Created by Giorgi Butbaia on 10/3/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import Foundation
import SceneKit

class Earth : SCNNode {
    private let radius: CGFloat

    // Satellites that are orbiting Earth object
    private var satellites: [Satellite] = []

    init(radius: CGFloat) {
        self.radius = radius
        super.init()

        self.geometry = SCNSphere(radius: radius)
        self.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Diffuse")
        self.geometry?.firstMaterial?.specular.contents = UIImage(named: "Specular")
        self.geometry?.firstMaterial?.emission.contents = UIImage(named: "Emission")
        self.geometry?.firstMaterial?.normal.contents = UIImage(named: "Normal")
        self.geometry?.firstMaterial?.isDoubleSided = true

        self.geometry?.firstMaterial?.transparency = 1
        self.geometry?.firstMaterial?.shininess = 50
    }

    required init?(coder: NSCoder) {
        self.radius = 0.05
        super.init(coder: coder)
    }

    /**
     * Adds a new Satellite
     * @param satellite: A satellite object.
     * @param drawOrbit: Draws the trajectory of satellite, if enabled.
     */
    public func addSatellite(_ satellite: Satellite, _ drawOrbit: Bool = true) {
        let orbit = satellite.getOrbit()

        let points = orbit.getPoints()
        let durations = orbit.getDurations()

        // Configure action
        var actions: [SCNAction] = []
        
        satellite.position = Float(radius) * points[0]

        for i in 1..<points.count {
            actions.append(
                SCNAction.move(
                    to: Float(radius) * points[i],
                    duration: durations[(i + 1) % points.count]))
        }
        
        let anim = SCNAction.sequence(actions)
        satellite.runAction(SCNAction.repeatForever(anim))
        self.addChildNode(satellite)
        
        // TODO: Draw Orbit
    }
}

extension SCNVector3 {
    static func * (_ scale: Float, _ vec: SCNVector3) -> SCNVector3 {
        return SCNVector3(scale * vec.x, scale * vec.y, scale * vec.z)
    }
}
