//
//  ContentView.swift
//  HelloCoffee
//
//  Created by Dongjun Lee on 11/21/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var model: CoffeeModel
    @State private var isPresented: Bool  = false
    
    private func deleteOrder(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let order = model.orders[index]
            guard let orderId = order.id else {
                return
            }
            Task{
                do{
                    try await model.deleteOrder(orderId)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                if model.orders.isEmpty {
                    Text("No orders available!").accessibilityIdentifier("noOrdersText")
                }else {
                    List {
                        ForEach(model.orders) { order in
                            NavigationLink(value: order.id) {
                                OrderCellView(order: order)
                            }
                        }.onDelete(perform: deleteOrder)
                    }.accessibilityIdentifier("orderList")
                }
            }
            .navigationDestination(for: Int.self, destination: { orderId in
                OrderDetailView(orderId: orderId)
            })
            .task {
                await populateOrders()
            }.toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add New Order") {
                        isPresented = true
                    }.accessibilityIdentifier("addNewOrderButton")
                }
            })
            .sheet(isPresented: $isPresented, content: {
                AddOrUpdateCoffeeView()
            })
        }
    }
    
    private func populateOrders() async {
        do {
            try await model.populateOrders()
        }catch {
            print(error)
        }
    }
}



#Preview {
    var config = Configuration()
    let coffeeModel = CoffeeModel(webService: WebService(baseURL: config.environment.baseURL))
    return ContentView()
        .environmentObject(coffeeModel)
}


