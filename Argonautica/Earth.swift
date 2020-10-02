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
     */
    public func addSatellite(_ satellite: Satellite) {
        satellites.append(satellite)
    }
}
