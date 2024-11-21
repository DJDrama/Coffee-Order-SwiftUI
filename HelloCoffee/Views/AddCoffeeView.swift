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

struct AddCoffeeView: View {
    @State private var name: String = ""
    @State private var coffeeName: String = ""
    @State private var price: String = ""
    @State private var coffeeSize: CoffeeSize = .medium
    @State private var errors = AddCoffeeErrors()
    
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
            
            Button("Place Order") {
                if isValid {
                    // place the order
                }
                
            }.accessibilityIdentifier("placeOrderButton")
                .centerHorizontally()
        }
        
    }
}

#Preview {
    AddCoffeeView()
}
