//
//  SponsorView.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/21/23.
//

import SwiftUI
import CloudKit
import CoreData

struct SponsorView: View {
        var event: Event
        
        //@FetchRequest(entity: Sponsors.entity(), sortDescriptors: []) private var coreDataEvents: FetchedResults<Sponsors>
        @Environment(\.managedObjectContext) private var viewContext
        @State private var cloudKitData: [Sponsors] = []
        
        var body: some View {
            Text(event.name ?? "")
                .font(.title)
                .bold()
            Text("Sponsors")
                .bold()
            
            List() {
                ForEach(cloudKitData, id: \.self) { sponsor in
                label: do {
                    SponsorRow(sponsor: sponsor)
                    }
                }
                //.onDelete(perform: delete)
                
            }
            .onAppear {
                Task {
                    do {
                        let sponsors = try await fetchSponsorDataFromCloudKit(context: viewContext)
                        cloudKitData = sponsors
                    } catch {
                        // Handle errors
                        print("Error fetching data from CloudKit: \(error)")
                    }
                }
            }
    }
    
    /*func delete(at offsets: IndexSet) {
        for index in offsets {
            let sponsor = cloudKitData[index]
            viewContext.delete(sponsor)
        }

        do {
            try viewContext.save()
        } catch {
            print("Error saving context after delete: \(error)")
        }
    }*/
    
    
    
    func fetchSponsorDataFromCloudKit(context: NSManagedObjectContext) async throws -> [Sponsors] {
        let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
        let database = container.publicCloudDatabase
        let predicate = NSPredicate(format: "eventId == %@", event.eventId!)
        let query = CKQuery(recordType: "Sponsors", predicate: predicate)
        var sponsorItems: [Sponsors] = []
        
        query.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
                let records = try await database.perform(query, inZoneWith: nil)
                var recordCount = 0
               
                for record in records {
                    let sponsors = Sponsors(context: context)
                    if let type = record["type"] as? String,
                       let description = record["description"] as? String,
                       let name = record["name"] as? String,
                       let website = record["website"] as? String,
                       //let image = record["image"] as? String,
                       let phone = record["phone"] as? String
                    {
                        
                        if let image = record["imageName"] as? CKAsset,
                           let fileURL = image.fileURL,
                           let imageData = try? Data(contentsOf: fileURL) {
                            // Create a UIImage from the imageData
                            if let logo = UIImage(data: imageData) {
                                // Use the image in your UI
                                sponsors.logo = logo.pngData()
                            }
                        }
                        sponsors.type = type
                        sponsors.desc = description
                        sponsors.name = name
                        sponsors.website = website
                        sponsors.phone = phone
                        //sponsors.image = image
                        sponsorItems.append(sponsors)
                        
                        print("foo too!", sponsorItems)
                        
                        recordCount += 1
                    }
                }
            } catch {
                print("Error fetching records from CloudKit: \(error)")
            }
       
        return sponsorItems
        
        
    }
}

/*struct SponsorView_Previews: PreviewProvider {
    static var previews: some View {
        SponsorView()
    }
}*/
