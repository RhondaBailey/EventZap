//
//  ScheduleView.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/21/23.
//

import SwiftUI
import CloudKit
import CoreData

struct ScheduleView: View {
    var event: Event
    
    //@FetchRequest(entity: Schedule.entity(), sortDescriptors: []) private var coreDataEvents: FetchedResults<Schedule>
    @Environment(\.managedObjectContext) private var viewContext
    @State private var cloudKitData: [Schedule] = []
    //adding a comment to test commit to git
    
    var body: some View {
        Text(event.name ?? "")
            .font(.title)
            .bold()
        Text("Schedule of Classes")
            .bold()
        
        List() {
            ForEach(cloudKitData, id: \.self) { schedule in
            label: do {
                    ScheduleRow(schedule: schedule)
                }
            }
            //.onDelete(perform: delete)
        }
        .onAppear {
            Task {
                do {
                    let schedule = try await fetchScheduleDataFromCloudKit(context: viewContext)
                    cloudKitData = schedule
                } catch {
                    // Handle errors
                    print("Error fetching data from CloudKit: \(error)")
                }
            }
        }
        
    }
    
    func fetchScheduleDataFromCloudKit(context: NSManagedObjectContext) async throws -> [Schedule] {
        let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
        let database = container.publicCloudDatabase
       
        //let predicate = NSPredicate(format: "eventId == %@", event.id)
        let predicate = NSPredicate(format: "eventId == %@", event.eventId!)
        let query = CKQuery(recordType: "Schedule", predicate: predicate)
        
        var scheduleItems: [Schedule] = []
        
        query.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
                let records = try await database.perform(query, inZoneWith: nil)
           
                for record in records {
                  
                    if let location = record["location"] as? String,
                       //let id = record["id"] as? Int64,
                       let name = record["name"] as? String,
                       let scheduleDescription = record["description"] as? String,
                       let time = record["time"] as? String
                    {
                        let schedule = Schedule(context: context)
                        schedule.location = location
                        //schedule.id = id
                        schedule.name = name
                        schedule.scheduleDescription = scheduleDescription
                        schedule.time = time
                        scheduleItems.append(schedule)
                        
                        print("Record retrieved ", event.eventId)

                    }
                }
            } catch {
                print("Error fetching records from CloudKit: \(error)")
            }
       
        return scheduleItems
        
        
    }
}

/*struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}*/
