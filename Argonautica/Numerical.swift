//
//  Numerical.swift
//  Argonautica
//
//  Created by Giorgi Butbaia on 10/3/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import Foundation

class Numerical {
    /**
     * Uses Simpson's integration to integrate f.
     * @param f: Function that is to be integrated.
     * @param x0: Start
     * @param x1: End
     * @param num: Number of steps
     */
    static func sintegrate(f: (Float) -> (Float), x0: Float, x1: Float, num: UInt = 1000) -> Float {
        let step: Float = (x1 - x0) / Float(num)
        var s1: Float = f(x0 + step / 2)
        var s2: Float = 0
        
        for i in 1..<num {
            s1 += f(x0 + step * Float(i) + step / 2)
            s2 += f(x0 + step * Float(i))
        }

        return (step / 6) * (f(x0) + f(x1) + 4 * s1 + 2 * s2)
    }
}
