//
//  SwiftUIView.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/21/23.
//

import SwiftUI
import CloudKit
import Foundation

struct DataUpload: View {
    var body: some View {
        Button(action: {
            //saveEventRecordToCloudKit()
            //saveScheduleRecordToCloudKit()
            saveSponsorRecordToCloudKit()
            saveVendorRecordToCloudKit()
        }) {
            Text("Create Event")
        }
        .frame(width: 150.0)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))
    }
    
    func saveVendorRecordToCloudKit() {
        print("foo vendors!")
        let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
        let publicDatabase = container.publicCloudDatabase
        let maxRecords = 100
        
        // Load JSON
        if let jsonURL = Bundle.main.url(forResource: "vendors", withExtension: "json"),
           let jsonData = try? Data(contentsOf: jsonURL) {

            do {
                var recordCount = 0
                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                    for recordData in jsonObject {
                        if recordCount >= maxRecords {
                            break
                        }
   
                        let record = CKRecord(recordType: "Vendors")
                        if let eventId = recordData["eventId"] as? Int64 {
                            record["eventId"] = eventId
                        } else {
                            print("Error: Unable to cast 'eventId' to Int64")
                        }
                        if let name = recordData["name"] as? String {
                            record["name"] = name

                        } else {
                            print("Error: Unable to cast 'name' to String")
                        }
                        if let description = recordData["description"] as? String {
                            record["description"] = description
                        } else {
                            print("Error: Unable to cast 'description' to String")
                        }
                        if let productLine = recordData["productLine"] as? String {
                            record["productLine"] = productLine
                        } else {
                            print("Error: Unable to cast 'productLine' to String")
                        }
                        if let website = recordData["website"] as? String {
                            record["website"] = website
                        } else {
                            print("Error: Unable to cast 'website' to String")
                        }
                        if let logo = recordData["logo"] as? String {
                            record["logo"] = logo
                        } else {
                            print("Error: Unable to cast 'logo' to String")
                        }
                        if let phone = recordData["phone"] as? String {
                            record["phone"] = phone
                        } else {
                            print("Error: Unable to cast 'phone' to String")
                        }
                        if let id = recordData["id"] as? Int64 {
                            record["id"] = id
                        } else {
                            print("Error: Unable to cast 'id' to Int64")
                        }
                        
                        publicDatabase.save(record) { (savedRecord, error) in
                            if let error = error {
                                // Handle the error
                                print("Error saving record: \(error.localizedDescription)")
                            } else {
                                // Record saved successfully
                                print("Record saved successfully")
                            }
                        }
                        
                        recordCount += 1
                        
                    }
                } else {
                    print("Failed to parse JSON data.")
                }
            } catch {
                print("Error parsing JSON data: \(error.localizedDescription)")
            }
        }
    }
    func saveSponsorRecordToCloudKit() {
        print("foo sponsors!")
        let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
        let publicDatabase = container.publicCloudDatabase
        let maxRecords = 100
        
        // Load JSON
        if let jsonURL = Bundle.main.url(forResource: "sponsors", withExtension: "json"),
           let jsonData = try? Data(contentsOf: jsonURL) {

            do {
                var recordCount = 0
                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                    for recordData in jsonObject {
                        if recordCount >= maxRecords {
                            break
                        }
   
                        let record = CKRecord(recordType: "Sponsors")
                        if let eventId = recordData["eventId"] as? Int64 {
                            record["eventId"] = eventId
                        } else {
                            print("Error: Unable to cast 'eventId' to Int64")
                        }
                        if let name = recordData["name"] as? String {
                            record["name"] = name

                        } else {
                            print("Error: Unable to cast 'name' to String")
                        }
                        if let description = recordData["description"] as? String {
                            record["description"] = description
                        } else {
                            print("Error: Unable to cast 'description' to String")
                        }
                        if let type = recordData["type"] as? String {
                            record["type"] = type
                        } else {
                            print("Error: Unable to cast 'city' to String")
                        }
                        if let website = recordData["website"] as? String {
                            record["website"] = website
                        } else {
                            print("Error: Unable to cast 'website' to String")
                        }
                        if let logo = recordData["logo"] as? String {
                            record["logo"] = logo
                        } else {
                            print("Error: Unable to cast 'logo' to String")
                        }
                        if let phone = recordData["phone"] as? String {
                            record["phone"] = phone
                        } else {
                            print("Error: Unable to cast 'phone' to String")
                        }
                        if let id = recordData["id"] as? Int64 {
                            record["id"] = id
                        } else {
                            print("Error: Unable to cast 'id' to Int64")
                        }
                        
                        publicDatabase.save(record) { (savedRecord, error) in
                            if let error = error {
                                // Handle the error
                                print("Error saving record: \(error.localizedDescription)")
                            } else {
                                // Record saved successfully
                                print("Record saved successfully")
                            }
                        }
                        
                        recordCount += 1
                        
                    }
                } else {
                    print("Failed to parse JSON data.")
                }
            } catch {
                print("Error parsing JSON data: \(error.localizedDescription)")
            }
        }
    }
    
    func saveScheduleRecordToCloudKit() {
        print("foo!")
        let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
        let publicDatabase = container.publicCloudDatabase
        let maxRecords = 1
        
        // Load JSON
        if let jsonURL = Bundle.main.url(forResource: "schedule", withExtension: "json"),
           let jsonData = try? Data(contentsOf: jsonURL) {

            do {
                var recordCount = 0
                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                    for recordData in jsonObject {
                        /*if recordCount >= maxRecords {
                            break
                        }*/
                        
                        let record = CKRecord(recordType: "Schedule")
                        if let eventId = recordData["eventId"] as? Int64 {
                            record["eventId"] = eventId
                        } else {
                            print("Error: Unable to cast 'eventId' to Int64")
                        }
                        if let name = recordData["name"] as? String {
                            record["name"] = name

                        } else {
                            print("Error: Unable to cast 'name' to String")
                        }
                        if let description = recordData["description"] as? String {
                            record["description"] = description
                        } else {
                            print("Error: Unable to cast 'description' to String")
                        }
                        if let type = recordData["type"] as? String {
                            record["type"] = type
                        } else {
                            print("Error: Unable to cast 'city' to String")
                        }
                        if let time = recordData["time"] as? String {
                            record["time"] = time
                        } else {
                            print("Error: Unable to cast 'state' to String")
                        }
                        if let location = recordData["location"] as? String {
                            record["location"] = location
                        } else {
                            print("Error: Unable to cast 'location' to String")
                        }
                        if let id = recordData["id"] as? Int64 {
                            record["id"] = id
                        } else {
                            print("Error: Unable to cast 'id' to Int64")
                        }
                        
                        publicDatabase.save(record) { (savedRecord, error) in
                            if let error = error {
                                // Handle the error
                                print("Error saving record: \(error.localizedDescription)")
                            } else {
                                // Record saved successfully
                                print("Record saved successfully")
                            }
                        }
                        
                        recordCount += 1
                        
                    }
                } else {
                    print("Failed to parse JSON data.")
                }
            } catch {
                print("Error parsing JSON data: \(error.localizedDescription)")
            }
        }
    }
    
    func saveEventRecordToCloudKit() {
        let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
        let publicDatabase = container.publicCloudDatabase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let maxRecords = 1
        
        // Load JSON
        if let jsonURL = Bundle.main.url(forResource: "Events", withExtension: "json"),
           let jsonData = try? Data(contentsOf: jsonURL) {

            do {
                var recordCount = 0
                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                    for recordData in jsonObject {
                        /*if recordCount >= maxRecords {
                            break
                        }*/
                        let record = CKRecord(recordType: "Event")
                        if let name = recordData["name"] as? String {
                            record["eventName"] = name
                            record["name"] = name

                        } else {
                            print("Error: Unable to cast 'name' to String")
                        }
                        if let email = recordData["email"] as? String {
                            record["email"] = email
                        } else {
                            print("Error: Unable to cast 'email' to String")
                        }
                        if let city = recordData["city"] as? String {
                            record["city"] = city
                        } else {
                            print("Error: Unable to cast 'city' to String")
                        }
                        if let state = recordData["state"] as? String {
                            record["state"] = state
                        } else {
                            print("Error: Unable to cast 'state' to String")
                        }
                        if let facilityName = recordData["facilityName"] as? String {
                            record["facilityName"] = facilityName
                        } else {
                            print("Error: Unable to cast 'facilityName' to String")
                        }
                        if let id = recordData["id"] as? Int64 {
                            record["id"] = id
                        } else {
                            print("Error: Unable to cast 'id' to Int64")
                        }
                        if let address = recordData["address"] as? String {
                            record["address"] = address
                        } else {
                            print("Error: Unable to cast 'address' to String")
                        }
                        if let scheduleType = recordData["scheduleType"] as? Int64 {
                            record["scheduleType"] = scheduleType
                        } else {
                            print("Error: Unable to cast 'scheduleType' to Int64")
                        }
                        if let isFeatured = recordData["isFeatured"] as? Int64 {
                            record["isFeatured"] = isFeatured
                        } else {
                            print("Error: Unable to cast 'isFeatured' to Int64")
                        }
                        if let isFavorite = recordData["isFavorite"] as? Int64 {
                            record["isFavorite"] = isFavorite
                        } else {
                            print("Error: Unable to cast 'isFavorite' to Int64")
                        }
                        if let isSponsored = recordData["isSponsored"] as? Int64 {
                            record["isSponsored"] = isSponsored
                        } else {
                            print("Error: Unable to cast 'isSponsored' to Int64")
                        }
                        if let eventDescription = recordData["description"] as? String {
                            record["eventDescription"] = eventDescription
                        } else {
                            print("Error: Unable to cast 'eventDescription' to String")
                        }
                        if let eventType = recordData["eventType"] as? String {
                            record["eventType"] = eventType
                        } else {
                            print("Error: Unable to cast 'eventType' to String")
                        }
                        if let facebook = recordData["facebook"] as? String {
                            record["facebook"] = facebook
                        } else {
                            print("Error: Unable to cast 'facebook' to String")
                        }
                        if let hasVendors = recordData["hasVendors"] as? Int64 {
                            record["hasVendors"] = hasVendors
                        } else {
                            print("Error: Unable to cast 'hasVendors' to Int64")
                        }
                        if let imageName = recordData["imageName"] as? String {
                            record["imageName"] = imageName
                        } else {
                            print("Error: Unable to cast 'imageName' to String")
                        }
                        if let phoneNumber = recordData["phoneNumber"] as? String {
                            record["phoneNumber"] = phoneNumber
                        } else {
                            print("Error: Unable to cast 'phoneNumber' to String")
                        }
                        if let showManager = recordData["showManager"] as? String {
                            record["showManager"] = showManager
                        } else {
                            print("Error: Unable to cast 'showManager' to String")
                        }
                        if let startDate = recordData["startDate"] as? String {
                            print("startDate = ", startDate)
                            if let formattedDate = dateFormatter.date(from: startDate) {
                                print("formattedDate = ", formattedDate)
                                record["startDate"] = formattedDate
                                } else {
                                    print("Error: Unable to parse 'startDate' to Date")
                                }
                        } else {
                            print("Error: Unable to cast 'startDate' to Date")
                        }
                        if let endDate = recordData["endDate"] as? String {
                            print("endDate = ", endDate)
                            if let formattedDate = dateFormatter.date(from: endDate) {
                                print("formattedDate = ", formattedDate)
                                record["endDate"] = formattedDate
                                } else {
                                    print("Error: Unable to parse 'endDate' to Date")
                                }
                        } else {
                            print("Error: Unable to cast 'startDate' to Date")
                        }
                        if let startDate = recordData["startDate"] as? String {
                            record["startDateOnly"] = startDate
                        } else {
                            print("Error: Unable to cast 'startDate' to String")
                        }
                        if let endDate = recordData["endDate"] as? String {
                            record["endDateOnly"] = endDate
                        } else {
                            print("Error: Unable to cast 'endDate' to String")
                        }
                        if let twitter = recordData["twitter"] as? String {
                            record["twitter"] = twitter
                        } else {
                            print("Error: Unable to cast 'twitter' to String")
                        }
                        if let website = recordData["website"] as? String {
                            record["website"] = website
                        } else {
                            print("Error: Unable to cast 'website' to String")
                        }
                        if let coordinates = recordData["coordinates"] as? [String: Any],
                           let longitude = coordinates["longitude"] as? Double,
                           let latitude = coordinates["latitude"] as? Double {
                            record["longitude"] = longitude
                            record["latitude"] = latitude

                        } else {
                            print("Error: Unable to extract coordinates")
                        }
                        
                        publicDatabase.save(record) { (savedRecord, error) in
                            if let error = error {
                                // Handle the error
                                print("Error saving record: \(error.localizedDescription)")
                            } else {
                                // Record saved successfully
                                print("Record saved successfully")
                            }
                        }
                        
                        recordCount += 1
                        
                    }
                } else {
                    print("Failed to parse JSON data.")
                }
            } catch {
                print("Error parsing JSON data: \(error.localizedDescription)")
            }
        }
    }
}

