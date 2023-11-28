//
//  ContentView.swift
//  EventZap
//
//  Created by Rhonda Bailey on 8/30/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State private var selection: Tab = .featured
    //let saveAction: ()->Void
    
    enum Tab {
        case featured
        case list
    }

    var body: some View {
        TabView(selection: $selection) {
            EventsHome()
                .tabItem {
                    Label("Coming Soon", systemImage: "star")
                }
                .tag(Tab.featured)
            
            EventsList()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(Tab.list)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(saveAction: {}).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}*/
