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
    // Orbit of the Satellite
    private var orbit: Orbit

    init(model: String, orbit: Orbit, modelScale: Float = 0.003) {
        self.orbit = orbit
        super.init();

        // Initialize geometry
        let scene = SCNScene(named: "\(model).dae", inDirectory: "Models.scnassets/\(model)")!
        let wrapper = SCNNode()
        for node in scene.rootNode.childNodes {
            node.geometry?.firstMaterial?.lightingModel = .constant
            node.movabilityHint = .movable
            wrapper.addChildNode(node)
        }

        let bbox = wrapper.boundingBox
        wrapper.position = -modelScale * (bbox.max + bbox.min)/2.0
        wrapper.scale = modelScale * SCNVector3(1, 1, 1)

        self.addChildNode(wrapper)
    }

    convenience init(model: String) {
        self.init(
            model: model, orbit: CircularOrbit(normalizedRadius: 1))
    }

    required init?(coder: NSCoder) {
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
