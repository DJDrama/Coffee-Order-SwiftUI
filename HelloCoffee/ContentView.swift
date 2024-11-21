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
    
    var body: some View {
        NavigationStack{
            VStack {
                if model.orders.isEmpty {
                    Text("No orders available!").accessibilityIdentifier("noOrdersText")
                }else {
                    List(model.orders) { order in
                        OrderCellView(order: order)
                    }
                }
            }.task {
                await populateOrders()
            }.toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add New Order") {
                        isPresented = true
                    }.accessibilityIdentifier("addNewOrderButton")
                }
            })
            .sheet(isPresented: $isPresented, content: {
                AddCoffeeView()
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


