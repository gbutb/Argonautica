//
//  IntegrateTests.swift
//  ArgonauticaTests
//
//  Created by Giorgi Butbaia on 10/3/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import XCTest
@testable import Argonautica

class IntegrateTests: XCTestCase {
    func testSimpleIntegration() throws {
        XCTAssert(
            abs(Numerical.sintegrate(f: {
                x in pow(x, 2)
            }, x0: 0, x1: 1, num: 1000) - 1/3.0) < 1e-5)
    }
}
