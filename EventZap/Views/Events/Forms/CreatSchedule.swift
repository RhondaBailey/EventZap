//
//  CreatSchedule.swift
//  EventZap
//
//  Created by Rhonda Bailey on 10/13/23.
//

import SwiftUI
import CloudKit
import Foundation
import CoreLocation

struct CreatSchedule: View {
    @State private var id: String = ""
    @State private var eventId: Int = 0
    @State private var location: String = ""
    @State private var name: String = ""
    @State private var scheduleDescription: String = ""
    @State private var time: String = ""
    @State private var scheduleType: String = ""
    
    //@Binding var savedRecordID: String
    //@Binding var savedId: CKRecord.ID?
    @Binding var savedEventId: String
    
    private var savedId: String {
            return savedEventId
        }

    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Name")
                    Spacer()
                    TextField("", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                        .disableAutocorrection(true)
                }
                HStack {
                    Text("Location")
                    Spacer()
                    TextField("", text: $location)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                        .disableAutocorrection(true)
                }
                HStack {
                    Text("Description")
                    Spacer()
                    TextField("", text: $scheduleDescription)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                }
                HStack {
                    Text("Time")
                    Spacer()
                    TextField("", text: $time)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                        .disableAutocorrection(true)
                }
                HStack {
                    Text("Type")
                    Spacer()
                    Picker("Schedule Type", selection: $scheduleType) {
                        Text("Class").tag(1)
                        Text("Show").tag(2)
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                Button(action: {
                    saveRecordToCloudKit()
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                Button(action: {
                    addAnotherScheduleItem()
                }) {
                    Text("Add Another")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
            }.navigationBarTitle("Add Schedule Item")
                /*.toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                    #if !os(watchOS)
                        NavigationLink(destination: CreatSchedule(savedEventId:  $savedEventId)) {
                            Text("+")
                                .font(.body)
                                .fontWeight(.semibold)
                        }
                        #endif
                    }
                }*/
        }
    }

    func addAnotherScheduleItem() {
        name = ""
        scheduleDescription = ""
        location = ""
        time = ""
        scheduleType = ""
        print(savedEventId)
    }

    func saveRecordToCloudKit() {
        //let container = CKContainer.default()
        let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
        let publicDatabase = container.publicCloudDatabase
        let scheduleItemID = UUID().uuidString
        

        // Create a CKRecord
        let record = CKRecord(recordType: "Schedule")
        record["eventId"] = savedId as CKRecordValue
        record["name"] = name as CKRecordValue
        record["id"] = 1001 as CKRecordValue
        record["location"] = location as CKRecordValue
        record["scheduleDescription"] = scheduleDescription as CKRecordValue
        record["description"] = scheduleDescription as CKRecordValue
        record["time"] = time as CKRecordValue
        record["type"] = scheduleType as CKRecordValue
        record["ScheduleItemId"] = scheduleItemID  as CKRecordValue
        print("eventId (savedId) = ", savedId)
        print("scheduleItemId = ", scheduleItemID)
        
        // Save the record
        publicDatabase.save(record) { (savedRecord, error) in
            if let error = error {
                // Handle the error
            print("Error saving record: \(error.localizedDescription)")
            } else {
                // Record saved successfully
                print("Record saved successfully")
            }
        }
       
    }
}

/*struct CreatSchedule_Previews: PreviewProvider {
    static var previews: some View {
        CreatSchedule()
    }
}*/
