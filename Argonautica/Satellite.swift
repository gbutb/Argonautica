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

    init(model: String) {
        // TODO Initialize model
        self.model = model
        super.init();

        // Initialize geometry
        self.geometry = SCNSphere(radius: 0.01)
    }

    required init?(coder: NSCoder) {
        self.model = "default_model"
        super.init(coder: coder)
    }
}
