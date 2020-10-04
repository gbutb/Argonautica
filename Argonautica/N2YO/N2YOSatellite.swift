//
//  N2YOSatellite.swift
//  Argonautica
//
//  Created by Giorgi Butbaia on 10/4/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import Foundation
import Alamofire

class N2YOSatellite {
    private static let URL = "https://www.n2yo.com/rest/v1"
    private static let API_KEY = "A2DQLP-PHXEC6-GY7Z5E-4KE8"
    
    /**
     * Returns TLE data for a Satellite.
     * @param noradID: NORAD Index of the Satellite
     */
    static func getTLE(_ noradID: UInt, _ completionHandler: @escaping (AFDataResponse<Any>) -> ()) {
        let requestTLEURL = "\(URL)/satellite/tle/\(noradID)"
        let request = AF.request(requestTLEURL, parameters: ["apiKey": API_KEY])
        request.responseJSON {
            json in
            completionHandler(json)
        }
    }
}
