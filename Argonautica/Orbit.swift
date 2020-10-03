//
//  Orbit.swift
//  Argonautica
//
//  Created by Giorgi Butbaia on 10/3/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import Foundation
import SceneKit

protocol Orbit {
    /**
     * Returns total of N points.
     * Orbit is interpolated between i and i + 1 % N points.
     */
    func getPoints() -> [SCNVector3]

    /**
     * Returns duration between pair of points.
     * Total of N durations. (Due to path being closed)
     */
    func getDurations() -> [Double]

    /**
     * Returns period of the orbit.
     */
    func getPeriod() -> Double
}
