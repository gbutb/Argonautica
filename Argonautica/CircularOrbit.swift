//
//  CircularOrbit.swift
//  Argonautica
//
//  Created by Giorgi Butbaia on 10/3/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import Foundation
import SceneKit

class CircularOrbit : Orbit {
    private var points: [SCNVector3]
    private var durations: [Double]

    /**
     * @param normalizedRadius: Radius in earth radius units.
     * @param numPoints: Total number of points
     */
    init(normalizedRadius: Float, numPoints: UInt = 1000) {
        points = []
        durations = []

        for i in 0..<numPoints {
            let angle: Float = Float(i) * 2.0 * Float.pi / Float(numPoints)
            points.append(SCNVector3(normalizedRadius * cos(angle), 0, normalizedRadius * sin(angle)))
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
