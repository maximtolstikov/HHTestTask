//
//  ForecastType.swift
//  Head&HandsTestTask
//
//  Created by Maxim Tolstikov on 15/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//
protocol Endpoint {
    var path: String { get }
}


enum ForecastType: Endpoint {
    
    case current(coordinates: Coordinates)
}


extension ForecastType {

    var apiKey: String {
        return "f8953be85ac6cf2b6712393dc6870e84"
    }
    var baseURL: String {
        return "https://api.darksky.net"
    }
    var path: String {
        switch self {
        case .current(let coordinates):
            return "/forecast/\(apiKey)/\(coordinates.latitude),\(coordinates.longitude)"
        }
    }
    
}
