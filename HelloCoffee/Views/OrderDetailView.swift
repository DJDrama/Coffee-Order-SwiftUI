//
//  OrderDetailView.swift
//  HelloCoffee
//
//  Created by Dongjun Lee on 11/24/24.
//

import SwiftUI

struct OrderDetailView: View {
    let orderId: Int
    @EnvironmentObject private var model: CoffeeModel
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack {
            if let order = model.orderById(orderId) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(order.coffeeName)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityIdentifier("coffeeNameText")
                    Text(order.size.rawValue)
                        .opacity(0.5)
                    Text(order.total as NSNumber, formatter: NumberFormatter.currency)
                    
                    HStack {
                        Spacer()
                        Button("Delete Order", role: .destructive) {
                            
                        }
                        Button("Edit Order") {
                            isPresented = true
                        }.accessibilityIdentifier("editOrderButton")
                        Spacer()
                    }
                }.sheet(isPresented: $isPresented) {
                    AddCoffeeView()
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    var config = Configuration()
    let coffeeModel = CoffeeModel(webService: WebService(baseURL: config.environment.baseURL))
    return OrderDetailView(orderId: 0)
        .environmentObject(coffeeModel)
}
