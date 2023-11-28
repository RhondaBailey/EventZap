//
//  EventZapApp.swift
//  EventZap
//
//  Created by Rhonda Bailey on 8/30/23.
//

import SwiftUI
import CoreData 

@main
struct EventZapApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
#if !os(watchOS)
            //ContentView(saveAction: {})
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            #else
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
#endif
        }
    }
}
