//
//  EllipticalOrbit.swift
//  Argonautica
//
//  Created by Giorgi Butbaia on 10/3/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import Foundation
import SceneKit

class EllipticalOrbit : Orbit {
    private var points: [SCNVector3]
    private var durations: [Double]

    /**
     * TODO Generalize to an arbitrary ellipse
     * @param normalizedRadius1: Radius along one axis, in earth radius units.
     * @param normalizedRadius2: Radius along second axis, in earth radius units.
     * @param numPoints: Total number of points
     */
    init(normalizedRadius1: Float, normalizedRadius2: Float, numPoints: UInt = 1000) {
        points = []
        durations = []

        for i in 0..<numPoints {
            let angle: Float = Float(i) * 2.0 * Float.pi / Float(numPoints)
            points.append(SCNVector3(normalizedRadius1 * cos(angle), 0, normalizedRadius2 * sin(angle)))
        }

        for _ in 1..<(numPoints+1) {
            durations.append(2.0/Double(numPoints))
        }
    }

    // MARK: - Getters
    func getPoints() -> [SCNVector3] {
        return points;
    }
    
    func getDurations() -> [Double] {
        return durations;
    }
}
