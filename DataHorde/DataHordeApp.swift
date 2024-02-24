//
//  DataHordeApp.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/7/24.
//

import SwiftUI

@main
struct DataHordeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ItemFeatureView()
        }
    }
}

struct TestCountable: Countable {
    let value: Int
    var display: String {
        String(value)
    }

    mutating func increment() -> TestCountable {
        TestCountable(value: value + 1)
    }
    
    mutating func decrement() -> TestCountable {
        TestCountable(value: value - 1)
    }
}
