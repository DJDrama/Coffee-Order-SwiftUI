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
    @Environment(\.dismiss) private var dismiss
    
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
                            Task {
                                await deleteOrder(orderId: orderId)
                            }
                        }
                        Button("Edit Order") {
                            isPresented = true
                        }.accessibilityIdentifier("editOrderButton")
                        Spacer()
                    }
                }.sheet(isPresented: $isPresented) {
                    AddOrUpdateCoffeeView(orderForUpdate: order)
                }
            }
            Spacer()
        }
        .padding()
    }
    
    private func deleteOrder(orderId: Int) async {
        do {
            try await model.deleteOrder(orderId)
            dismiss()
        }catch {
            print(error)
        }
    }
}

#Preview {
    var config = Configuration()
    let coffeeModel = CoffeeModel(webService: WebService(baseURL: config.environment.baseURL))
    return OrderDetailView(orderId: 0)
        .environmentObject(coffeeModel)
}
