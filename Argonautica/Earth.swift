//
//  Earth.swift
//  Argonautica
//
//  Created by Giorgi Butbaia on 10/3/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import Foundation
import SceneKit
import SCNLine

class Earth : SCNNode {
    public static let EARTH_RADIUS: Float = 6400e3
    public static let muScaled: Float = 10e6 * 6.67e-11 * 5.9722e24 / pow(Earth.EARTH_RADIUS, 3)
    public static let PERIOD: Double = 100.0 // 24 * 60 * 60

    private let radius: CGFloat
    private static let ORBIT_THICKNESS: Float = 0.0003

    // Satellites that are orbiting Earth object
    private var satellites: [Satellite] = []

    // Space wheere all objects will be placed to
    private weak var space: Space?

    init(radius: CGFloat, space: Space?) {
        self.radius = radius
        self.space = space
        super.init()

        self.geometry = SCNSphere(radius: radius)
        self.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "land")
        self.geometry?.firstMaterial?.specular.contents = UIImage(named: "Specular")
        self.geometry?.firstMaterial?.emission.contents = UIImage(named: "Emission")
        self.geometry?.firstMaterial?.normal.contents = UIImage(named: "Normal")
        self.geometry?.firstMaterial?.isDoubleSided = true

        self.geometry?.firstMaterial?.transparency = 1
        self.geometry?.firstMaterial?.shininess = 50

        // Configure rotation
        self.runAction(
            SCNAction.repeatForever(
                SCNAction.rotate(
                    by: CGFloat(2 * Float.pi),
                    around: SCNVector3(0, 1, 0),
                    duration: Earth.PERIOD)))
        
        /** TODO REMOVE, test node **/
        let indicator = SCNNode(geometry: SCNSphere(radius: 0.001))
        indicator.position = Earth.convertCoordinates(0, 0, Float(radius))
        self.addChildNode(indicator)
        /** END TODO **/
        

        // Add the object to space
        space?.addChildNode(self)
    }

    required init?(coder: NSCoder) {
        self.radius = 0.05
        super.init(coder: coder)
    }

    /**
     * Converts coordinates to local coordinate system of the Earth node
     * @param longitude: Longitude, lambda
     * @param latitude: Latitude, phi
     * @param altitude: Altitude, r
     * @return (x, y, z)
     */
    static func convertCoordinates(_ longitude: Float, _ latitude: Float, _ altitude: Float) -> SCNVector3 {
        return SCNVector3(
            altitude * cos(latitude) * sin(longitude), // x
            altitude * sin(latitude),                  // y
            altitude * cos(latitude) * cos(longitude)) // z
    }

    /**
     * Adds a new Satellite
     * @param satellite: A satellite object.
     * @param drawOrbit: Draws the trajectory of satellite, if enabled.
     */
    public func addSatellite(_ satellite: Satellite, _ drawOrbit: Bool = true) {
        let orbit = satellite.getOrbit()
        print("Added satellite with period: \(orbit.getPeriod())")
        let points = orbit.getPoints()
        let durations = orbit.getDurations()

        // Configure action
        var actions: [SCNAction] = []

        satellite.position = Float(radius) * points[0]

        for i in 1..<points.count {
            actions.append(
                SCNAction.move(
                    to: Float(radius) * points[i],
                    duration: 5 * durations[(i + 1) % points.count]))
        }

        let anim = SCNAction.sequence(actions)
        satellite.runAction(SCNAction.repeatForever(anim))
        space?.addChildNode(satellite)

        // Draw Orbit
        if drawOrbit {
            var scaledPoints = points.map { p in Float(radius) * p }
            if let first = scaledPoints.first {
                scaledPoints.append(first)
            }
            let lineGeometry = SCNGeometry.line(
                points: scaledPoints,
                radius: Earth.ORBIT_THICKNESS).0
            lineGeometry.firstMaterial?.transparency = 0.4
            space?.addChildNode(SCNNode(geometry: lineGeometry))
        }
    }
}
