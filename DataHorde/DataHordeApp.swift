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
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
