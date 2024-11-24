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
    
    func deleteOrder(_ orderId: Int) async throws {
        let deletedOrder = try await webService.deleteOrder(orderId: orderId)
        orders = orders.filter({ order in
            order.id != deletedOrder.id
        })
    }
    
    func updateOrder(order: Order) async throws {
        let updatedOrder = try await webService.updateOrder(order)
        guard let index = orders.firstIndex(where: { order in
            order.id == updatedOrder.id
        }) else {
            throw CoffeeOrderError.invalidOrderId
        }
        orders[index] = updatedOrder
    }
}
