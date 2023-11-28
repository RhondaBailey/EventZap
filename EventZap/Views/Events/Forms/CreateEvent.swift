//
//  CreateEvent.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/5/23.
//

import SwiftUI
import CloudKit
import Foundation
import CoreLocation

struct CreateEvent: View {
    @State private var id: Int = 0
    @State private var name: String = ""
    @State private var eventType: String = "Horse Show"
    @State private var facilityName: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var categoryId: Int = 0
    @State private var description: String = ""
    @State private var address: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var showManager: String = ""
    @State private var phoneNumber: String = ""
    @State private var isSponsored: Bool = true
    @State private var hasVendors: Bool = true
    @State private var website: String = ""
    @State private var email: String = ""
    @State private var latitude: Double = 0
    @State private var longitude: Double = 0
    @State private var facebook: String = ""
    @State private var twitter: String = ""
    @State private var scheduleType: Int = 0
    @State private var isFeatured: Bool = false
    @State private var isFavorite: Bool = true
    @State private var imageName: String = ""
    let dateFormatter = DateFormatter()
    @State private var endDateString: String = ""
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isSaveSuccessful = false
    @State private var savedEventId: String = ""
    
    @State private var isNameValid = true
    @State private var isFacilityNameValid = true
    @State private var isDescriptionValid = true
    @State private var isAddressValid = true
    @State private var isCityValid = true
    @State private var isStateValid = true
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Information")) {
                    Picker("Event Type", selection: $eventType) {
                        Text("Horse Show").tag(0)
                        Text("Renaissance Faire").tag(1)
                    }
                    .pickerStyle(MenuPickerStyle())
                    HStack {
                        Text("Name")
                            .font(.system(size: 14))
                        Spacer()
                        TextField("", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                            .disableAutocorrection(true)
                            .font(.system(size: 14))
                        
                    }
                    if !isNameValid {
                        Text("Name is required")
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.leading)
                    }
                    HStack {
                        Text("Facility Name")
                            .font(.system(size: 14))
                        Spacer()
                        TextField("", text: $facilityName)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                            .disableAutocorrection(true)
                            .font(.system(size: 14))
                    }
                    if !isFacilityNameValid {
                        Text("Facility Name is required")
                            .foregroundColor(.red)
                            .padding(.leading)
                            .font(.system(size: 14))
                    }
                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        displayedComponents: [.date]
                    )
                    .font(.system(size: 14))
                    DatePicker(
                        "End Date",
                        selection: $endDate,
                        displayedComponents: [.date]
                    )
                    .font(.system(size: 14))
                }
                Section(header: Text("Event Details")) {
                    
                    HStack {
                        Text("Address")
                            .font(.system(size: 14))
                        Spacer()
                        TextField("", text: $address)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                            .disableAutocorrection(true)
                            .font(.system(size: 14))
                    }
                    if !isAddressValid {
                        Text("A valid Address is required")
                            .foregroundColor(.red)
                            .padding(.leading)
                            .font(.system(size: 14))
                    }
                    HStack {
                        Text("City")
                            .font(.system(size: 14))
                        Spacer()
                        TextField("", text: $city)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                            .disableAutocorrection(true)
                            .font(.system(size: 14))
                    }
                    if !isCityValid {
                        Text("A valid City is required")
                            .foregroundColor(.red)
                            .padding(.leading)
                            .font(.system(size: 14))
                    }
                    HStack {
                        Text("State")
                            .font(.system(size: 14))
                        Spacer()
                        TextField("", text: $state)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                            .disableAutocorrection(true)
                            .font(.system(size: 14))
                    }
                    if !isStateValid {
                        Text("A valid State is required")
                            .foregroundColor(.red)
                            .padding(.leading)
                            .font(.system(size: 14))
                    }
                    HStack {
                        Text("Description")
                            .font(.system(size: 14))
                        Spacer()
                        TextField("", text: $description)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                            .font(.system(size: 14))
                    }
                    if !isDescriptionValid {
                        Text("Description is required")
                            .foregroundColor(.red)
                            .padding(.leading)
                            .font(.system(size: 14))
                    }
                    HStack {
                        Text("Show Manager")
                            .font(.system(size: 14))
                        Spacer()
                        TextField("", text: $showManager)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                            .disableAutocorrection(true)
                            .font(.system(size: 14))
                    }
                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        Text("Select Image")
                            .font(.system(size: 14))
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
                    Toggle(isOn: $isFeatured) {
                        Text("Featured")
                            .font(.system(size: 14))
                    }
                    Toggle(isOn: $isSponsored) {
                        Text("Has Sponsors")
                            .font(.system(size: 14))
                    }
                    Toggle(isOn: $hasVendors) {
                        Text("Has Vendors")
                            .font(.system(size: 14))
                    }
                }
                Section(header: Text("Event Contact Details")) {
                    HStack {
                        Text("Phone")
                            .font(.system(size: 14))
                        TextField("", text: $phoneNumber)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                            .disableAutocorrection(true)
                            .font(.system(size: 14))
                    }
                    HStack {
                        Text("Website")
                            .font(.system(size: 14))
                        TextField("", text: $website)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                            .disableAutocorrection(true)
                            .font(.system(size: 14))
                    }
                    HStack {
                        Text("Email")
                            .font(.system(size: 14))
                        TextField("", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                            .disableAutocorrection(true)
                            .font(.system(size: 14))
                    }
                    HStack {
                        Text("Facebook")
                            .font(.system(size: 14))
                        TextField("Facebook", text: $facebook)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                            .disableAutocorrection(true)
                            .font(.system(size: 14))
                    }
                    HStack {
                        Text("Twitter")
                            .font(.system(size: 14))
                        TextField("", text: $twitter)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                            .disableAutocorrection(true)
                            .font(.system(size: 14))
                    }
                    Button(action: {
                        
                        let validationResult = HelperFunctions.validateEventFieldData(
                            name: name,
                            isNameValid: isNameValid,
                            facilityName: facilityName,
                            isFacilityNameValid: isFacilityNameValid,
                            address: address,
                            isAddressValid: isAddressValid,
                            city: city,
                            isCityValid: isCityValid,
                            state: state,
                            isStateValid: isStateValid,
                            description: description,
                            isDescriptionValid: isDescriptionValid,
                            invalidFields: false // Check the necessity of this constant
                        )

                        let invalidFields = validationResult.isValid
                        isNameValid = validationResult.isNameValid
                        isFacilityNameValid = validationResult.isFacilityNameValid
                        isAddressValid = validationResult.isAddressValid
                        isCityValid = validationResult.isCityValid
                        isStateValid = validationResult.isStateValid
                        isDescriptionValid = validationResult.isDescriptionValid
                        print("invalidFields = ", invalidFields)
                        
                        if !invalidFields {
                            print("no invalid records go ahead and save")
                            Task {
                                await getCoordinates()
                                
                            }
                        }
                        
                    }) {
                        Text("Save")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                }
                
                
                if isSaveSuccessful {
                    Section(header: Text(name.isEmpty ? "Event Created" : "Event " + name + " Created")) {
                        NavigationLink(destination: CreatSchedule(savedEventId: $savedEventId)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.yellow)
                                    .frame(width: 300, height: 75)
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Add Schedule")
                                            .fontWeight(.bold)
                                        Text("Add a Schedule to " + name)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.leading, 20)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.white)
                                        .padding(.all, 10)
                                }
                                
                            }
                            .padding(.horizontal, 10)
                        }
                        if hasVendors {
                            NavigationLink(destination: CreateVendor(savedEventId:  $savedEventId)) {
                                ZStack {
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.green)
                                        .frame(width: 300, height: 75)
                                    
                                    HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("Add Vendors")
                                                .fontWeight(.bold)
                                            Text("Add vendors to  " + name)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.leading, 20)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(.white)
                                            .padding(.all, 10)
                                        
                                    }
                                }
                                .padding(.horizontal, 10)
                            }
                        }
                        if isSponsored {
                            NavigationLink(destination: CreateSponsor(savedEventId:  $savedEventId)) {
                                
                                ZStack {
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.orange)
                                        .frame(width: 300, height: 75)
                                    
                                    HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("Add Sponsors")
                                                .fontWeight(.bold)
                                            Text("Add sponsors to your " + name)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.leading, 20)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(.white)
                                            .padding(.all, 10)
                                        
                                    }
                                }
                                .padding(.horizontal, 10)
                            }
                        }
                    }
                }
            }.navigationBarTitle("Add Event")
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
                }
        }
        
        //.navigationBarHidden(true)
        //.navigationBarBackButtonHidden(true)
    }
    
    
    
    func saveRecordToCloudKit() async {
        print("Step Four")
        let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
        let publicDatabase = container.publicCloudDatabase
        
        let record = createRecord() // Creates the CKRecord with the required fields

        saveToCloudKit(record: record, in: publicDatabase) // Saves the record to CloudKit
    }
    
    func getCoordinates() async {
        print("Step One")
        let fullAddress = address + "," + city + "," + state
        //print("full address = ", fullAddress)
        
         await HelperFunctions.getCoordinatesFromAddress(address: fullAddress) { (coordinate, error) in
            if let coordinates = coordinate {
                // Set the latitude and longitude in the CloudKit record here
                latitude = coordinates.latitude
                longitude = coordinates.longitude

               print("Step Three")
                print("getCoordinates latitude = ", coordinates.latitude)
                print("getCoordinates longitude = ", coordinates.longitude)

                // Any code that depends on the coordinate should be placed here
            } else {
                // Handle the case where coordinates could not be obtained
                print("Error getting coordinates:", error ?? "Unknown error")
                
                
            }
        }
        await saveRecordToCloudKit()
    }
    
    func createRecord() -> CKRecord {
        print("Step Five")
        
        let recordID = UUID().uuidString
        // Create a CKRecord
        let record = CKRecord(recordType: "Event")
        record["NAME"] = name as CKRecordValue
        record["eventName"] = name as CKRecordValue
        record["email"] = email as CKRecordValue
        record["city"] = city as CKRecordValue
        record["state"] = state as CKRecordValue
        record["facilityName"] = facilityName as CKRecordValue
        record["eventId"] = recordID as CKRecordValue
        record["email"] = email as CKRecordValue
        record["address"] = address as CKRecordValue
        record["scheduleType"] = scheduleType as CKRecordValue
        record["isFeatured"] = isFeatured as CKRecordValue
        record["isFavorite"] = isFeatured as CKRecordValue
        record["isSponsored"] = isSponsored as CKRecordValue
        record["eventDescription"] = description as CKRecordValue
        record["eventType"] = eventType as CKRecordValue
        record["facebook"] = facebook as CKRecordValue
        record["hasVendors"] = hasVendors as CKRecordValue
        record["phoneNumber"] = phoneNumber as CKRecordValue
        record["showManager"] = showManager as CKRecordValue
        record["startDate"] = startDate as CKRecordValue
        record["endDate"] = endDate as CKRecordValue
        record["twitter"] = twitter as CKRecordValue
        record["website"] = website as CKRecordValue
        record["latitude"] = latitude as CKRecordValue
        record["longitude"] = longitude as CKRecordValue
        
        if let selectedImage = selectedImage {
            if let imageAsset = HelperFunctions.saveImageLocally(imageData: selectedImage.pngData() ?? Data()) {
                if let imageURL = imageAsset.fileURL {
                    let imageNameWithoutExtension = imageURL.deletingPathExtension().lastPathComponent
                    print("imageNameWithoutExtension = ", imageNameWithoutExtension)
                    record["imageName"] = imageNameWithoutExtension
                    record["image"] = imageAsset
                }
            }
        }

        return record
    }
    
    func saveToCloudKit(record: CKRecord, in database: CKDatabase) {
        // Save the record inside this closure
        print("Step Six")
        database.save(record) { (savedRecord, error) in
            if let error = error {
                // Handle the error
                print("Error saving record: \(error.localizedDescription)")
            } else {
                if let savedRecord = savedRecord {
                    
                    isSaveSuccessful = true
                    print("isSaveSuccessful = ",isSaveSuccessful)
                    
                    let recordID = savedRecord.recordID
                    let recordName = recordID.recordName

                    print("Record saved with recordID: \(recordName)")

                    // You can use 'recordName' as needed in your application
                    savedEventId = recordName
                    print("savedEventId = ", savedEventId)
                    
                    savedRecord["id"] = recordName

                    // Save the record again to CloudKit with the updated field
                    database.save(savedRecord) { (updatedRecord, updateError) in
                        if let updateError = updateError {
                            // Handle the error during the update
                            print("Error updating record with recordID: \(updateError.localizedDescription)")
                        } else {
                            print("Record updated with recordID field.")
                        }
                    }
                    /*name = ""
                     facilityName = ""
                     description = ""
                     address = ""
                     city = ""
                     state = ""
                     facebook = ""
                     twitter = ""
                     email = ""
                     website = ""
                     phoneNumber = ""
                     showManager = ""
                     isFeatured = false
                     isFavorite = false
                     isSponsored = false*/
                    
                    savedEventId = savedRecord["eventId"] as? String ?? ""
                    print("savedEventId = ",savedEventId)
                }
            }
        }
    }
}


