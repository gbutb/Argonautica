//
//  KeplerianOrbit.swift
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

    // Orbit parameters
    private let semiMajor: Float
    private let semiMinor: Float
    private let inclination: Float
    private let longitudal: Float
    private let c: Float
    private let mu: Float

    /**
     * @param semiMajor: Length of the semi major axis.
     * @param semiMinor: Length of the semi minor axis.
     * @param inclination: Inclination angle of the orbit.
     * @param longitudal: Longitudal inclination of the orbit.
     * @param mu: Normalized gravitational parameter
     * @param numPoints: Total number of points
     */
    init(semiMajor: Float, semiMinor: Float, inclination: Float, longitudal: Float, mu: Float, numPoints: UInt = 1000) {
        self.semiMajor = semiMajor
        self.semiMinor = semiMinor
        self.inclination = inclination
        self.longitudal = longitudal
        self.c = sqrt(pow(semiMajor, 2) - pow(semiMinor, 2))
        self.mu = mu

        points = []
        durations = []

        var angles = [Float]()

        for i in 0..<numPoints {
            let anomaly: Float = Float(i) * 2.0 * Float.pi / Float(numPoints)
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
            angles.append(anomaly)
        }

        for i in 1..<(numPoints+1) {
            let previousAngle = angles[Int(i - 1)]
            let currentAngle = angles[Int(i) % Int(numPoints)] + ((i == numPoints) ? 2 * Float.pi : 0)
            let time = getTime(previousAngle, currentAngle)
            durations.append(Double(time))
        }
    }

    /**
     * Finds instantaneous velocity at a given point.
     */
    static func findVelocity(_ normalizedGravitationalParameter: Float, _ distance: Float, _ semiMajor: Float) -> Float {
        return sqrt(normalizedGravitationalParameter * (2/distance - 1/semiMajor))
    }

    /**
     * @param apoapsis: normalized apoapsis of the orbit. (From the center of mass of Earth, rather than the surface)
     * @param periapsis: normalized periapsis of the orbit. (From the center of mass of Earth, rather than the surface)
     * @param inclination: Inclination angle of the orbit.
     * @param longitudal: Longitudal inclination of the orbit.
     * @param mu: Normalized gravitational parameter
     */
    convenience init(apoapsis: Float, periapsis: Float, inclination: Float, longitudal: Float, mu: Float, numPoints: UInt = 1000) {
        let semiMajor = (apoapsis + periapsis) / 2.0
        let c = (apoapsis - periapsis) / 2.0
        let semiMinor = sqrt(pow(semiMajor, 2) - pow(c, 2))
        self.init(
            semiMajor: semiMajor, semiMinor: semiMinor,
            inclination: inclination, longitudal: longitudal,
            mu: mu,
            numPoints: numPoints)
    }

    // MARK: - Getters
    func getPoints() -> [SCNVector3] {
        return points;
    }

    func getDurations() -> [Double] {
        return durations;
    }

    /**
     * @returns: Period of the orbit
     */
    func getPeriod() -> Double {
        return Double(Numerical.sintegrate(f: dt, x0: 0, x1: 2 * Float.pi))
    }

    /**
     * @return: Time it takes to get from start to end.
     */
    func getTime(_ start: Float, _ end: Float) -> Float {
        return Numerical.sintegrate(f: dt, x0: start, x1: end)
    }

    private func dt(_ theta: Float) -> Float {
        let dr = sqrt(pow(semiMinor * cos(theta), 2) + pow(semiMajor * sin(theta), 2))
        let r = sqrt(pow(semiMajor * cos(theta) - c, 2) + pow(semiMinor * sin(theta), 2))
        let v = sqrt(mu * (-1.0/semiMajor + 2/r))
        return dr/v
    }
}
