//
//  SwinjectStoryboard+Extension.swift
//  HHTestTask
//
//  Created by Maxim Tolstikov on 16/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

extension SwinjectStoryboard {
    
    @objc class func setup() {
        defaultContainer.register(LocationService.self) { _ in
            return LocationServiceImpl()
        }
        defaultContainer.register(Networking.self) { _ in
            return HTTPNetworking()
        }
        defaultContainer.register(Fetcher.self) { resolver in
            WeatherFetcher.init(networking: resolver ~> Networking.self)
        }
        defaultContainer.storyboardInitCompleted(AuthViewController.self) { (resolver, controller) in
            controller.locationService = resolver ~> LocationService.self
            controller.networkService = resolver ~> (Fetcher.self)
        }
        
    }
}
