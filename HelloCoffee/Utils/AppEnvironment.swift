//
//  AppEnvironment.swift
//  HelloCoffee
//
//  Created by Dongjun Lee on 11/21/24.
//

import Foundation

enum Endpoints {
    case allOrders
    case placeOrder
    
    var path: String {
        switch self {
            
        case .allOrders:
            return "test/orders"
        case .placeOrder:
            return "/test/new-order"
        }
    }
}

struct Configuration {
    lazy var environment: AppEnvironment = {
        // read the value from environment variable
        guard let env = ProcessInfo.processInfo.environment["ENV"] else {
            return AppEnvironment.dev
        }
        
        return env == "TEST" ? AppEnvironment.test : AppEnvironment.dev
    }()
}

enum AppEnvironment: String {
    case dev
    case test
    
    var baseURL: URL {
        switch self {
        case .dev:
            return URL(string: "https://island-bramble.glitch.me")!
        case .test:
            return URL(string: "https://island-bramble.glitch.me")!
        }
    }
}
