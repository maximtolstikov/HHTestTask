//
//  FetchWeatherTest.swift
//  HHTestTaskTests
//
//  Created by Maxim Tolstikov on 15/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//
import Swinject
import SwinjectAutoregistration
import XCTest
@testable import HHTestTask

// Проверяю получение данных из интернета, но по хорошему нужно написать mock.

class FetchWeatherTest: XCTestCase {

    private let container = Container()
    
    override func setUp() {
        container.autoregister(Networking.self, initializer: HTTPNetworking.init)
        container.autoregister(Fetcher.self, argument: Networking.self, initializer: WeatherFetcher.init)
    }

    override func tearDown() {
        container.removeAll()
    }
    

    func testFetcher() {
        
        let coordinates = Coordinates(latitude: 46.685367, longitude: 38.298106)
        
        let fetcher = container ~> (Fetcher.self, container ~> Networking.self)
        let expectation = XCTestExpectation(description: "Fetch Wether from dataset internet")
        
        fetcher.fetch(for: coordinates) { (weather) in
            expectation.fulfill()
            XCTAssertNotNil(weather)            
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

}
