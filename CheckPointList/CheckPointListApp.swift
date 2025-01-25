//
//  CheckPointListApp.swift
//  CheckPointList
//
//  Created by Daniel Alejandro Ornelas Mendoza on 23/11/24.
//

import SwiftUI

@main
struct CheckPointListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
