//
//  Satellite.swift
//  Argonautica
//
//  Created by Giorgi Butbaia on 10/3/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import Foundation
import SceneKit

class Satellite : SCNNode {
    // Path to the satellite model
    var model: String
    private var orbit: Orbit

    init(model: String, orbit: Orbit) {
        // TODO Initialize model
        self.model = model
        self.orbit = orbit
        super.init();

        // Initialize geometry
        self.geometry = SCNSphere(radius: 0.01)
    }

    convenience init(model: String) {
        self.init(
            model: model, orbit: CircularOrbit(normalizedRadius: 1))
    }

    required init?(coder: NSCoder) {
        self.model = "default_model"
        // Default orbit is of normalized radius = 1.
        self.orbit = CircularOrbit(normalizedRadius: 1)
        super.init(coder: coder)
    }

    /**
     * Returns orbit of the satellite, in normalized coordinates.
     */
    public func getOrbit() -> Orbit {
        return self.orbit
    }
}
