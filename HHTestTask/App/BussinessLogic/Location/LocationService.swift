//
//  LocationService.swift
//  HHTestTask
//
//  Created by Maxim Tolstikov on 16/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//
protocol LocationService {
    func currentCoordinates() -> Coordinates?
}

class LocationServiceImpl: LocationService {
    
    func currentCoordinates() -> Coordinates? {
        return Coordinates(latitude: 46.685367, longitude: 38.298106)
    }
    
    
}
