//
//  AddCoffeeView.swift
//  HelloCoffee
//
//  Created by Dongjun Lee on 11/21/24.
//

import SwiftUI

struct AddCoffeeErrors {
    var name: String = ""
    var coffeeName: String = ""
    var price: String = ""
    
}

struct AddOrUpdateCoffeeView: View {
    
    var orderForUpdate: Order? = nil
    
    @State private var name: String = ""
    @State private var coffeeName: String = ""
    @State private var price: String = ""
    @State private var coffeeSize: CoffeeSize = .medium
    @State private var errors = AddCoffeeErrors()
    
    @EnvironmentObject private var model: CoffeeModel
    @Environment(\.dismiss) private var dismiss
    
    var isValid: Bool {
        errors = AddCoffeeErrors()
        
        // This is not a business rule
        // This is just UI validation
        if name.isEmpty {
            errors.name = "Name cannot be empty!"
        }
        if coffeeName.isEmpty {
            errors.coffeeName = "Coffee name cannot be empty!"
        }
        if price.isEmpty {
            errors.price = "Price cannot be empty!"
        } else if !price.isNumeric {
            errors.price = "Price needs to be a number!"
        } else if price.isLessThan(1) {
            errors.price = "Price needs to be more than 0!"
        }
        return errors.name.isEmpty && errors.coffeeName.isEmpty && errors.price.isEmpty
    }
    
    var body: some View {
        NavigationStack{
            Form {
                TextField("Name", text: $name)
                    .accessibilityIdentifier("name")
                Text(errors.name).visible(!errors.name.isEmpty)
                    .foregroundStyle(.red)
                    .font(.caption)
                
                TextField("Coffee name", text: $coffeeName)
                    .accessibilityIdentifier("coffeeName")
                Text(errors.coffeeName).visible(!errors.coffeeName.isEmpty)
                    .foregroundStyle(.red)
                    .font(.caption)
                
                TextField("Price", text: $price)
                    .accessibilityIdentifier("price")
                Text(errors.price).visible(!errors.price.isEmpty)
                    .foregroundStyle(.red)
                    .font(.caption)
                
                Picker("Select size", selection: $coffeeSize) {
                    ForEach(CoffeeSize.allCases, id: \.rawValue){ size in
                        Text(size.rawValue).tag(size)
                    }
                }.pickerStyle(.segmented)
                
                Button(orderForUpdate != nil ? "Update Order" : "Place Order") {
                    if isValid {
                        // place the order
                        Task {
                            await saveOrUpdate()
                            dismiss()
                        }
                    }
                }.accessibilityIdentifier("placeOrderButton")
                    .centerHorizontally()
            }.navigationTitle(orderForUpdate != nil ? "Update Coffee" : "Add Coffee")
                .onAppear(perform: {
                    populateExistingOrder()
                })
        }
    }
    
    private func populateExistingOrder() {
        if let order = orderForUpdate {
            name = order.name
            coffeeName = order.coffeeName
            price = String(order.total)
            coffeeSize = order.size
        }
    }
    
    private func saveOrUpdate() async {
        if let order = orderForUpdate {
            var editOrder = order
            editOrder.name = name
            editOrder.total = Double(price) ?? 0.0
            editOrder.coffeeName = coffeeName
            editOrder.size = coffeeSize
            await updateOrder(editOrder)
        } else {
            let order = Order(name: name, coffeeName: coffeeName, total: Double(price) ?? 0, size: coffeeSize)
            await placeOrder(order: order)
            
        }
    }
    
    private func updateOrder(_ order: Order) async {
        do {
            try await model.updateOrder(order: order)
            dismiss()
        }catch {
            print(error)
        }
    }
    
    private func placeOrder(order: Order) async {
        do {
            try await model.placeOrder(order: order)
            dismiss()
        }catch {
            print(error)
        }
    }
}

#Preview {
    AddOrUpdateCoffeeView()
}
