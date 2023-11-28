//
//  EventsHome.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/5/23.
//

import SwiftUI
import CloudKit
import CoreData

struct EventsHome: View {
    
    @State private var filterCategory = FilterCategory.horseShow
    @State private var filter = FilterCategory.all
    //@State private var filterState = FilterState.ca
    //@State private var state = FilterState.ca
    @State private var selectedEventIndex: Int? = nil // Track the selected event index

    @Environment(\.managedObjectContext) private var viewContext
    //@FetchRequest(entity: Event.entity(), sortDescriptors: []) private var coreDataFeatureEvents: FetchedResults<Event>
    @State private var cloudKitData: [Event] = []
    
        
    enum FilterCategory: String, CaseIterable, Identifiable {
        case all = "All"
        case horseShow = "Horse Show"
        case renFaire = "Ren Faires"
        case concerts = "Concerts"

        var id: FilterCategory { self }
    }
    
   /* enum FilterState: String, CaseIterable, Identifiable {
        case all = "All"
        case ca = "CA"
        case co = "CO"
        case ut = "UT"
        case tx = "TX"
        case wa = "WA"

        var id: FilterState { self }
        
    }*/
    var body: some View {
        
            NavigationView {
                VStack {
                        ScrollView(.horizontal) { // Use .horizontal axis
                            HStack {
                                ForEach(cloudKitData, id: \.self) { event in
                                    EventItem(event: event)
                                        .frame(width: UIScreen.main.bounds.width) // Adjust the width as needed
                                        .padding()
                                }
                            }
                        }
                        .onAppear {
                            // Fetch data from CloudKit here
                            filter = .all
                            Task {
                                do {
                                    let featuredEvents = try await fetchEventDataFromCloudKit(context: viewContext)
                                    cloudKitData = featuredEvents
                                } catch {
                                    // Handle errors
                                    print("Error fetching data from CloudKit: \(error)")
                                }
                            }
                        }
                        .listStyle(.inset)
                        .navigationTitle("Coming Soon")
                
                    Divider()
                    
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
                                .pickerStyle(.inline)
                            } label: {
                                Label("Filter", systemImage: "slider.horizontal.3")
                            }
                        }
                        /*ToolbarItem {
                            Menu {
                                Picker("State", selection: $filterState) {
                                    ForEach(FilterState.allCases) { state in
                                        Text(state.rawValue).tag(state.rawValue)
                                    }
                                }
                                .onChange(of: filterState) { newState in
                                    // Fetch data based on the new filter
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
                                .pickerStyle(.inline)
                            } label: {
                                Label("State", systemImage: "slider.horizontal.3")
                            }
                        }*/
                    }
                }
            }
        }

    func fetchEventDataFromCloudKit(context: NSManagedObjectContext) async throws -> [Event] {
        let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
        let database = container.publicCloudDatabase // You can also use .privateCloudDatabase if needed
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = NSDate()
    
        var predicate: NSPredicate {
            var subpredicates: [NSPredicate] = []
            
            /*print("state =", filterState.rawValue)
            if filterState != .all {
                subpredicates.append(NSPredicate(format: "state == %@", filterState.rawValue))
            }*/
            
            if filter != .all {
                subpredicates.append(NSPredicate(format: "eventType == %@", filter.rawValue))
            }

            subpredicates.append(NSPredicate(format: "endDate > %@", currentDate as NSDate))
            
            // Combine all subpredicates with AND operator
            let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: subpredicates)
            
            return compoundPredicate
        }
        //print("Pred = ", predicate)
        let query = CKQuery(recordType: "Event", predicate: predicate)
        print("query = ", query)
        var featuredEvents: [Event] = []
        let maxRecords = 3
        
        query.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        
        do {
            let records = try await database.perform(query, inZoneWith: nil)
                var recordCount = 0
                for record in records {
                    if recordCount >= maxRecords {
                        break
                    }
                    let featuredEvent = Event(context: context)
                    if let imageAsset = record["image"] as? CKAsset,
                       let fileURL = imageAsset.fileURL,
                       let imageData = try? Data(contentsOf: fileURL) {
                        // Create a UIImage from the imageData
                        if let image = UIImage(data: imageData) {
                            // Use the image in your UI
                            featuredEvent.image = image.pngData()
                        }
                    }
                    if let eventName = record["eventName"] as? String,
                       let facilityName = record["facilityName"] as? String,
                       let startDate = record["startDate"] as? Date,
                       let endDate = record["endDate"] as? Date,
                       let latitude = record["latitude"] as? Double,
                       let longitude = record["longitude"] as? Double
                        
                    {
                        let featuredEvent = Event(context: context)
                        featuredEvent.name = eventName
                        featuredEvent.facilityName = facilityName
                        featuredEvent.startDate = dateFormatter.string(from: startDate)
                        featuredEvent.endDate = dateFormatter.string(from: endDate)
                        featuredEvent.latitude = latitude
                        featuredEvent.longitude = longitude
                        featuredEvents.append(featuredEvent)
                        
                        recordCount += 1
                    }
                    print("recordCount = ", recordCount)
                }
            
            } catch {
                print("Error fetching records from CloudKit: \(error)")
            }
       
        return featuredEvents
    }

    func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }

    func formatStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }

    func formatDateToLocaleString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
        return dateFormatter.string(from: date)
    }
}

struct EventsHome_Previews: PreviewProvider {
    static var previews: some View {
        
        EventsHome()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    
    }
}
