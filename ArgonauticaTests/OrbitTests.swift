//
//  OrbitTests.swift
//  ArgonauticaTests
//
//  Created by Giorgi Butbaia on 10/3/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import Foundation
import XCTest
@testable import Argonautica

class OrbitTests: XCTestCase {
    func testOrbitPeriod() throws {
        let earthRadius: Float = 6400e3
        let apoapsis: Float = (475e3 + earthRadius) / earthRadius
        let periapsis: Float = (500e3 + earthRadius) / earthRadius
        let G: Float = 6.67e-11
        let M: Float = 5.9722e24
        let normalizedMu = G*M / pow(earthRadius, 3)
        let orbit = KeplerianOrbit(
            apoapsis: apoapsis, periapsis: periapsis, inclination: 0, longitudal: 0, mu: normalizedMu)
        XCTAssert(abs((orbit.getPeriod() - 5690)/5690) < 0.0001)
    }
    
    func testOrbitPeriodSubsampled() throws  {
        let earthRadius: Float = 6400e3
        let apoapsis: Float = (475e3 + earthRadius) / earthRadius
        let periapsis: Float = (500e3 + earthRadius) / earthRadius
        let G: Float = 6.67e-11
        let M: Float = 5.9722e24
        let normalizedMu = G*M / pow(earthRadius, 3)
        let orbit = KeplerianOrbit(
            apoapsis: apoapsis, periapsis: periapsis, inclination: 0, longitudal: 0, mu: normalizedMu)
    
        let count = orbit.getDurations().reduce(0) {
            a, b in a + b
        }
        let period = orbit.getPeriod()
        print("Count: \(count) and period: \(period)")
        XCTAssert((count - period)/period < 0.0001)
    }
}
