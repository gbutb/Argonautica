//
//  GravitationalOrbit.swift
//  Argonautica
//
//  Created by Giorgi Butbaia on 10/3/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import Foundation
import SceneKit

class KeplerianOrbit : Orbit {
    private var points: [SCNVector3]
    private var durations: [Double]

    /**
     * @param semiMajor: Length of the semi major axis.
     * @param semiMinor: Length of the semi minor axis.
     * @param inclination: Inclination angle of the orbit.
     * @param longitudal: Longitudal inclination of the orbit.
     * @param numPoints: Total number of points
     */
    init(semiMajor: Float, semiMinor: Float, inclination: Float, longitudal: Float, numPoints: UInt = 1000) {
        points = []
        durations = []

        for i in 0..<numPoints {
            let anomaly: Float = Float(i) * 2.0 * Float.pi / Float(numPoints)
            let c = sqrt(pow(semiMajor, 2) - pow(semiMinor, 2))
            var point = SCNVector3(semiMajor * cos(anomaly) - c, 0, semiMinor * sin(anomaly))
            point = SCNVector3(
                point.x,
                point.y * cos(inclination) - point.z * sin(inclination),
                point.y * sin(inclination) + point.z * cos(inclination))
            point = SCNVector3(
                point.x * cos(longitudal) - point.z * sin(longitudal),
                point.y,
                point.x * sin(longitudal) + point.z * cos(longitudal))

            points.append(point)
        }

        for _ in 1..<(numPoints+1) {
            durations.append(2.0/Double(numPoints))
        }
    }

    /**
     * @param apogee: Apogee of the orbit.
     * @param perigee: Perigee of the orbit.
     * @param inclination: Inclination angle of the orbit.
     * @param longitudal: Longitudal inclination of the orbit.
     */
    convenience init(apogee: Float, perigee: Float, inclination: Float, longitudal: Float, numPoints: UInt = 1000) {
        let semiMajor = (apogee + perigee) / 2.0
        let c = (apogee - perigee) / 2.0
        let semiMinor = sqrt(pow(semiMajor, 2) - pow(c, 2))
        self.init(
            semiMajor: semiMajor, semiMinor: semiMinor,
            inclination: inclination, longitudal: longitudal,
            numPoints: numPoints)
    }

    // MARK: - Getters
    func getPoints() -> [SCNVector3] {
        return points;
    }

    func getDurations() -> [Double] {
        return durations;
    }
}

