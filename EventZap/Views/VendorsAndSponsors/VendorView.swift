//
//  VendorView.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/21/23.
//

import SwiftUI
import CloudKit
import CoreData

struct VendorView: View {
    var event: Event
    
    //@FetchRequest(entity: Vendors.entity(), sortDescriptors: []) private var coreDataEvents: FetchedResults<Vendors>
    @Environment(\.managedObjectContext) private var viewContext
    @State private var cloudKitData: [Vendors] = []
    
    var body: some View {
        Text(event.name ?? "")
            .font(.title)
            .bold()
        Text("Vendors")
            .bold()
        
        List() {
            ForEach(cloudKitData, id: \.self) { vendor in
            label: do {
                VendorRow(vendor: vendor)
                }
            }
            //.onDelete(perform: delete)
        }
        
        .onAppear {
            Task {
                do {
                    let vendors = try await fetchVendorsDataFromCloudKit(context: viewContext)
                    cloudKitData = vendors
                } catch {
                    // Handle errors
                    print("Error fetching data from CloudKit: \(error)")
                }
            }
        }
        
    }
    
    
    
    func fetchVendorsDataFromCloudKit(context: NSManagedObjectContext) async throws -> [Vendors] {
        let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
        let database = container.publicCloudDatabase

        let predicate = NSPredicate(format: "eventId == %@", event.eventId!)
        let query = CKQuery(recordType: "Vendors", predicate: predicate)
        var vendorItems: [Vendors] = []
        
        query.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
                let records = try await database.perform(query, inZoneWith: nil)
                var recordCount = 0
                print("Count = ", records)
                for record in records {

                    let vendors = Vendors(context: context)
                    if let productLine = record["productLine"] as? String,
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
                                vendors.logo = logo.pngData()
                            }
                        }
                        vendors.productLine = productLine
                        vendors.vendorDescription = description
                        vendors.name = name
                        //vendors.image = image
                        vendors.website = website
                        vendors.phone = phone
                        
                        vendorItems.append(vendors)
                        
                        print("foo too!", vendorItems)
                        
                        recordCount += 1
                    }
                }
            } catch {
                print("Error fetching records from CloudKit: \(error)")
            }
       
        return vendorItems
        
        
    }
}

/*struct VendorView_Previews: PreviewProvider {
    static var previews: some View {
        VendorView()
    }
}*/
