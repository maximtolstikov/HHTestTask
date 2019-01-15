//
//  WeatherFetcher.swift
//  Head&HandsTestTask
//
//  Created by Maxim Tolstikov on 15/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//
import Foundation

protocol Fetcher {
    func fetch(for cooordinates: Coordinates, response: @escaping (Weather?) -> Void)
}


/// Извлекает текущую погоду из запрошеных из сети данных
struct WeatherFetcher: Fetcher {
    let networking: Networking
    
    
    init(_ networking: Networking) {
        self.networking = networking
    }
    
    
    func fetch(for cooordinates: Coordinates, response: @escaping (Weather?) -> Void) {
        networking.request(from: ForecastType.current(coordinates: cooordinates).path) { (data, error) in
            
            if let error = error {
                print("Error received requesting Weather: \(error.localizedDescription)")
                return
            }
            
            guard let decoded = self.decodeJSON(type: ServiceWeather.self, from: data) else {
                assertionFailure()
                return
            }
            let weather = decoded.currently
            
            DispatchQueue.main.async {
                response(weather)
            }
        }
    }
    
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from,
            let response = try? decoder.decode(type.self, from: data) else { return nil }
        
        return response
    }
}
