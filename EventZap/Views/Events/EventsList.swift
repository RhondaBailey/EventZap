//
//  EventsList.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/5/23.
//

import SwiftUI
import CloudKit
import CoreData

struct EventsList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    //@FetchRequest(entity: Event.entity(), sortDescriptors: []) private var coreDataEvents: FetchedResults<Event>
    @State private var cloudKitData: [Event] = []
    @State private var states: [String] = []

    @State private var showFavoritesOnly = false
    @State private var filter = FilterCategory.all
    @State private var filterState = "All"
    @State private var selectedEvent: Event?
    //@State private var recordID = ""
   
    
    enum FilterCategory: String, CaseIterable, Identifiable {
        case all = "All"
        case horseShow = "Horse Shows"
        case renFaire = "Ren Faires"
        case concerts = "Concerts"

        var id: FilterCategory { self }
    }
    
    let currentDate = Date()
    
    var title: String {
        let title = filter == .all ? "Events" : filter.rawValue
        return showFavoritesOnly ? "Favorite \(title)" : title
    }
    
    var body: some View {
        
        NavigationView {
            List(selection: $selectedEvent) {
                //ForEach(eventCache.filteredEvents, id: \.self) { event in
                ForEach(cloudKitData, id: \.self) { event in
                   NavigationLink {
                            EventDetail(event: event)
                        } label: {
                            EventRow(event: event)
                        }
                        .tag(event)
                    }
                .onDelete(perform: delete)
            }
            .onAppear {
                filter = .all
                filterState = "All"
                
                refreshEventData()
                fetchStatesFromCloudKit()

            }
            .navigationTitle(title)
            .frame(minWidth: 300)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                #if !os(watchOS)
                    //NavigationLink(destination: DataUpload()) {
                    //NavigationLink(destination: BatchClearEventCache()) {
                    NavigationLink(destination: CreateEvent()) {
                        Text("+")
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    #endif
                }
                ToolbarItem {
                    Menu {
                        Picker("Category", selection: $filter) {
                            ForEach(FilterCategory.allCases) { category in
                                Text(category.rawValue).tag(category.rawValue)
                            }
                        }
                        .onChange(of: filter) { newFilter in
                            // Fetch data based on the new filter
                            refreshEventData()
                        }
                        
                        Toggle(isOn: $showFavoritesOnly) {
                            Label("Favorites only", systemImage: "star.fill")
                        }
                        .onChange(of: showFavoritesOnly) { newFilter in
                            // Fetch data based on the new filter
                                refreshEventData()
                        }
                    } label: {
                        Label("Filter", systemImage: "slider.horizontal.3")
                    }
                }
                ToolbarItem {
                    Menu {
                        Picker("State", selection: $filterState) {
                            Text("All").tag("All")
                            ForEach(states, id: \.self) { state in
                                Text(state).tag(state)
                            }
                        }
                        .onChange(of: filterState) { newState in
                            // Fetch data based on the new filter
                            print("Filter state changed to:", newState)
                            refreshEventData()
                        }
                        .pickerStyle(.inline)
                    } label: {
                        Label("State", systemImage: "slider.horizontal.3")
                    }
                }
            }
            Text("Select an Event")
        }
        //.focusedValue(\.selectedEvent, $modelData.events[index ?? 0])
    
    }
    
    func deleteAssociatedRecords(eventID: String, recordTypes: [String], completion: @escaping (Error?) -> Void) {
        let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
        let database = container.publicCloudDatabase
        
        print("recordTypes = ", recordTypes)
        print("eventId = ", eventID)

        var errors: [Error] = []

        let dispatchGroup = DispatchGroup()

        for recordType in recordTypes {
            print("recordType == ", recordType)
            dispatchGroup.enter()

            let predicate = NSPredicate(format: "eventId == %@", eventID)
            let query = CKQuery(recordType: recordType, predicate: predicate)
            print("query = ", query)

            database.perform(query, inZoneWith: nil) { (records, error) in
                defer {
                    dispatchGroup.leave()
                }
                
                print("Inside completion handler for \(recordType)")

                if let error = error {
                    errors.append(error)
                    return
                }
                print("records = ", records)
                if let records = records {
                    // Delete associated records
                    for record in records {
                        print("record = ", record)
                        database.delete(withRecordID: record.recordID) { (_, error) in
                            if let error = error {
                                errors.append(error)
                            } else {
                                print("Associated record deleted from CloudKit")
                            }
                        }
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            if errors.isEmpty {
                completion(nil)
            } else {
                let combinedError = NSError(domain: "com.yourdomain.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error deleting associated records"])
                completion(combinedError)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let event = cloudKitData[index]
            
            let recordTypes = ["Schedule", "Vendors", "Sponsors"] // Add your record types

            deleteAssociatedRecords(eventID: event.eventId!, recordTypes: recordTypes) { error in
                if let error = error {
                    print("Error deleting associated records: \(error)")
                    return
                }
            }

            // Delete from Core Data
            viewContext.delete(event)
            
            print("event.id = ", event.id)

            // Delete from CloudKit
            if let recordID = event.id {
                print("recordID = ", recordID)
                let recordIDToDelete = CKRecord.ID(recordName: recordID)
                
                let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
                let database = container.publicCloudDatabase
                
                database.delete(withRecordID: recordIDToDelete) { (recordID, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Error deleting record from CloudKit: \(error)")
                        } else {
                            print("Record deleted from CloudKit")
                        }
                    }
                }
            }
        }

        do {
            try viewContext.save()
        } catch {
            print("Error saving context after delete: \(error)")
        }
    }

    
    func fetchStatesFromCloudKit() {
        // Fetch distinct state values from CloudKit and update the 'states' array
        let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
        let database = container.publicCloudDatabase

        let query = CKQuery(recordType: "Event", predicate: NSPredicate(value: true))

        var distinctStates: Set<String> = Set()

        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = CKQueryOperation.maximumResults

        queryOperation.recordFetchedBlock = { record in
            if let state = record["state"] as? String {
                distinctStates.insert(state)
            }
        }

        queryOperation.queryCompletionBlock = { cursor, error in
            if let error = error {
                print("Error fetching states from CloudKit: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.states = Array(distinctStates).sorted()
                }
            }
        }
        print("distinctStates = ", distinctStates)

        database.add(queryOperation)
    }

    
    func refreshEventData() {
        print("refreshing data = ", filterState)
        Task {
            do {
                let events = try await fetchEventDataFromCloudKit(context: viewContext)
                cloudKitData = events
                
            } catch {
                // Handle errors
                print("Error fetching data from CloudKit: \(error)")
            }
        }
    }
    
    func fetchEventDataFromCloudKit(context: NSManagedObjectContext) async throws -> [Event] {
        let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
        let database = container.publicCloudDatabase // You can also use .privateCloudDatabase if needed
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        var predicate: NSPredicate {
            var subpredicates: [NSPredicate] = []
            
            if showFavoritesOnly {
               subpredicates.append(NSPredicate(format: "isFavorite == 1"))
           }
            
            if filterState != "All" {
                subpredicates.append(NSPredicate(format: "state == %@", filterState))
            }
            
            if filter != .all {
                subpredicates.append(NSPredicate(format: "eventType == %@", filter.rawValue))
            }

            subpredicates.append(NSPredicate(format: "endDate > %@", currentDate as CVarArg))
            
            let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: subpredicates)
            
            print("Predicate = ", compoundPredicate)
            
            return compoundPredicate
            
            
        }
        
        let query = CKQuery(recordType: "Event", predicate: predicate)
        print("query = ", query)
        
        var events: [Event] = []
        
        query.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        
        do {
                let records = try await database.perform(query, inZoneWith: nil)
            //let records = try await database.fetch(query, inZoneWith: nil)
                
                for record in records {
                   //print("record = ", record)
                    
                    let event = Event(context: context)
                    
                    
                    if let imageAsset = record["imageName"] as? CKAsset,
                       let fileURL = imageAsset.fileURL,
                       let imageData = try? Data(contentsOf: fileURL) {
                        // Create a UIImage from the imageData
                        if let image = UIImage(data: imageData) {
                            // Use the image in your UI
                            event.image = image.pngData()
                        }
                    }
                    
                    if let eventName = record["eventName"] as? String,
                       let facilityName = record["facilityName"] as? String,
                       let startDate = record["startDate"] as? Date,
                       let endDate = record["endDate"] as? Date,
                       //let imageName = record["imageName"] as? String
                       let latitude = record["latitude"] as? Double,
                       let longitude = record["longitude"] as? Double,
                       let state = record["state"] as? String,
                       let address = record["address"] as? String,
                       let city = record["city"] as? String,
                       let showManager = record["showManager"] as? String,
                       let email = record["email"] as? String,
                       let eventDescription = record["eventDescription"] as? String,
                       let eventType = record["eventType"] as? String,
                       let eventId = record["eventId"] as? String,
                       let facebook = record["facebook"] as? String,
                       let hasVendors = record["hasVendors"] as? Int64,
                       let id = record.recordID.recordName as? String,
                       let isFavorite = record["isFavorite"] as? Int64,
                       let isFeatured = record["isFeatured"] as? Int64,
                       let isSponsored = record["isSponsored"] as? Int64,
                       let phoneNumber = record["phoneNumber"] as? String,
                       let scheduleType = record["scheduleType"] as? Int64,
                       let twitter = record["twitter"] as? String,
                       let website = record["website"] as? String
                        
                    {
                        event.name = eventName
                        event.facilityName = facilityName
                        event.startDate = dateFormatter.string(from: startDate)
                        event.endDate = dateFormatter.string(from: endDate)
                        event.latitude = latitude
                        event.longitude = longitude
                        event.state = state
                        event.address = address
                        event.city = city
                        event.showManager = showManager
                        event.email = email
                        event.eventDescription = eventDescription
                        event.eventType = eventType
                        event.eventId = eventId
                        event.facebook = facebook
                        event.hasVendors = hasVendors
                        event.id = id
                        event.isFeatured = isFeatured
                        event.isFavorite = isFavorite
                        event.isSponsored = isSponsored
                        event.phoneNumber = phoneNumber
                        event.scheduleType = scheduleType
                        event.twitter = twitter
                        event.website = website
                        events.append(event)
                        print("events = ", event)
   
                    } else {
                            print("Error adding record to Events List - ", record)
                    }
                }
            } catch {
                print("Error fetching records from CloudKit: \(error)")
            }
       
        return events
    }
    
}

/*struct EventsList_Previews: PreviewProvider {
    static var previews: some View {
        //EventsList()
    }
}*/
