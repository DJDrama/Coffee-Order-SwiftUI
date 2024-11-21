//
//  CoffeeModel.swift
//  HelloCoffee
//
//  Created by Dongjun Lee on 11/21/24.
//

import Foundation

@MainActor
class CoffeeModel: ObservableObject {
    
    @Published private(set) var orders: [Order] = []
    
    let webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func placeOrder(order: Order) async throws{
        let newOrder = try await webService.placeOrder(order: order)
        orders.append(newOrder)
    }
    
    func populateOrders() async throws {
        orders = try await webService.getOrders()
    }
    
}
