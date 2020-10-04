//
//  N2YOSatelliteTests.swift
//  ArgonauticaTests
//
//  Created by Giorgi Butbaia on 10/4/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import Foundation
import XCTest
@testable import Argonautica

class N2YOSatelliteTests: XCTestCase {
    func testTLEQuery() throws {
        N2YOSatellite.getTLE(25541)
    }
}
