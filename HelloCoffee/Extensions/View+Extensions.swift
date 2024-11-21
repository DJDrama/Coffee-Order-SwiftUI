//
//  View+Extensions.swift
//  HelloCoffee
//
//  Created by Dongjun Lee on 11/21/24.
//

import Foundation
import SwiftUI

extension View {
    func centerHorizontally() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
}
