import SwiftUI
import CoreData

struct BatchClearEventCache: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Event.entity(), sortDescriptors: []) private var coreDataFeatureEvents: FetchedResults<Event>

    var body: some View {
        
        List {
            ForEach(coreDataFeatureEvents, id: \.self) { event in
                Text("Name: \(event.name ?? "")")
                Text(" - ")
                Text("State: \(event.state ?? "")")
            }
            .onDelete(perform: removeEvents)
        }
    }
    func removeEvents(at offsets: IndexSet) {
        for index in offsets {
            let event = coreDataFeatureEvents[index]
            managedObjectContext.delete(event)
        }
        do {
                try managedObjectContext.save()
            } catch {
                // Handle the Core Data save error
                print("Error saving managedObjectContext: \(error)")
            }
    }
}
