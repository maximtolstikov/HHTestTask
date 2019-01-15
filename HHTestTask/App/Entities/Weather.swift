//
//  Weather.swift
//  Head&HandsTestTask
//
//  Created by Maxim Tolstikov on 15/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UIKit

/// Модель погоды
struct Weather: Decodable {
    
    let temperature: Double
    let apparentTemperature: Double
    let humidity: Double
    let pressure: Double
}


extension Weather {
    
    var pressereString: String {
        return "\(Int(pressure * 0.750062)) mm"
    }
    var humidityString: String {
        return "\(Int(humidity * 100)) %"
    }
    var temperatureString: String {
        return "\(Int(5 / 9 * (temperature - 32)))˚C"
    }
    var apparentTemperatureString: String {
        return "\(Int(5 / 9 *  (apparentTemperature - 32)))˚C"
    }
}
