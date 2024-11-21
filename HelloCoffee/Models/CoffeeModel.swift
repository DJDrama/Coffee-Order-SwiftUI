//
//  CoffeeModel.swift
//  HelloCoffee
//
//  Created by Dongjun Lee on 11/21/24.
//

import Foundation

@MainActor
class CoffeeModel: ObservableObject {
    
    @Published private var orders: [Order] = []
    
    let webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func populateOrders() async throws {
        orders = try await webService.getOrders()
    }
    
}
