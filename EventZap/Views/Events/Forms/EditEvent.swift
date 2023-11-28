//
//  EditEvent.swift
//  EventZap
//
//  Created by Rhonda Bailey on 10/20/23.
//

import SwiftUI
import CloudKit
import Foundation
import CoreLocation

struct EditEvent: View {
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
    
    
    var event: Event
    init(event: Event) {
        self.event = event
        _name = State(initialValue: event.name ?? "")
        _facilityName = State(initialValue: event.facilityName ?? "")
        _description = State(initialValue: event.eventDescription ?? "")
        _address  = State(initialValue: event.address ?? "")
        _city  = State(initialValue: event.city ?? "")
        _state = State(initialValue: event.state ?? "")
        _phoneNumber = State(initialValue: event.phoneNumber ?? "")
        _email = State(initialValue: event.email ?? "")
        _website = State(initialValue: event.website ?? "")
        _facebook = State(initialValue: event.facebook ?? "")
        _twitter = State(initialValue: event.twitter ?? "")
        _showManager = State(initialValue: event.showManager ?? "")
        }
    
    var body: some View {
        Form {
            Section(header: Text("Event Information")) {
                HStack {
                    Text("Name")
                        .font(.system(size: 14))
                        .bold()
                    Spacer()
                    VStack {
                        TextEditor(text: $name)
                            .frame(width: 200)
                            .disableAutocorrection(true)
                            .font(.system(size: 14))
                    }
                    .overlay(
                             RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                             )
                }
                HStack {
                    Text("Facility Name")
                        .font(.system(size: 14))
                        .bold()
                    Spacer()
                    VStack {
                    TextEditor(text: $facilityName)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                        .disableAutocorrection(true)
                        .font(.system(size: 14))
                    }
                    .overlay(
                             RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                             )
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
                    Text("Description")
                        .font(.system(size: 14))
                        .bold()
                    Spacer()
                    VStack {
                    TextEditor(text: $description)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200, height: 75)
                        .font(.system(size: 14))
                    }
                    .overlay(
                             RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                             )
                }
                HStack {
                    Text("Address")
                        .font(.system(size: 14))
                        .bold()
                    Spacer()
                    VStack {
                    TextEditor(text: $address)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                        .disableAutocorrection(true)
                        .font(.system(size: 14))
                    }
                    .overlay(
                             RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                             )
                }
                HStack {
                    Text("City")
                        .font(.system(size: 14))
                        .bold()
                    Spacer()
                    VStack {
                    TextEditor(text: $city)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                        .disableAutocorrection(true)
                        .font(.system(size: 14))
                    }
                    .overlay(
                             RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                             )
                }
                HStack {
                    Text("State")
                        .font(.system(size: 14))
                        .bold()
                    Spacer()
                    VStack {
                    TextEditor(text: $state)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                        .disableAutocorrection(true)
                        .font(.system(size: 14))
                    }
                    .overlay(
                             RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                             )
                }
                HStack {
                    Text("Show Manager")
                        .font(.system(size: 14))
                        .bold()
                    Spacer()
                    VStack {
                    TextEditor(text: $showManager)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                        .disableAutocorrection(true)
                        .font(.system(size: 14))
                    }
                    .overlay(
                             RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                             )
                }
                Button(action: {
                    isImagePickerPresented.toggle()
                }) {
                    Text("Select Image")
                        .font(.system(size: 14))
                        .bold()
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
                Toggle(isOn: Binding(
                    get: { event.isFeatured == 1 ? true : false },
                    set: { newValue in
                        event.isFeatured = newValue ? 1 : 0
                    }
                )) {
                    Text("Featured")
                        .font(.system(size: 14))
                        .bold()
                }
                Toggle(isOn: Binding(
                    get: { event.isSponsored == 1 ? true : false },
                    set: { newValue in
                        event.isSponsored = newValue ? 1 : 0
                    }
                )) {
                    Text("Has Sponsors")
                        .font(.system(size: 14))
                        .bold()
                }
                Toggle(isOn: Binding(
                    get: { event.hasVendors == 1 ? true : false },
                    set: { newValue in
                        event.hasVendors = newValue ? 1 : 0
                    }
                )) {
                    Text("Has Vendors")
                        .font(.system(size: 14))
                        .bold()
                }
            }
            Section(header: Text("Event Contact Information")) {
                HStack {
                    Text("Phone")
                        .font(.system(size: 14))
                        .bold()
                        .frame(width: 100, alignment: .leading)
                        
                    VStack {
                    TextEditor(text: $phoneNumber)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 225)
                        .disableAutocorrection(true)
                        .font(.system(size: 14))
                    }
                    .overlay(
                             RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                         )
                }
                HStack {
                    Text("Website")
                        .font(.system(size: 14))
                        .bold()
                        .frame(width: 100, alignment: .leading)
                    VStack {
                    TextEditor(text: $website)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 225)
                        .disableAutocorrection(true)
                        .font(.system(size: 14))
                    }
                    .overlay(
                             RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                         )
                }
                HStack {
                    Text("Email")
                        .font(.system(size: 14))
                        .bold()
                        .frame(width: 100, alignment: .leading)
                    VStack {
                    TextEditor(text: $email)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 225)
                        .disableAutocorrection(true)
                        .font(.system(size: 14))
                    }
                    .overlay(
                             RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                             )
                }
                HStack {
                    Text("Facebook")
                        .font(.system(size: 14))
                        .bold()
                        .frame(width: 100, alignment: .leading)
                    VStack {
                    TextEditor(text: $facebook)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 225)
                        .disableAutocorrection(true)
                        .font(.system(size: 14))
                    }
                    .overlay(
                             RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                             )
                }
                HStack {
                    Text("Twitter")
                        .font(.system(size: 14))
                        .bold()
                        .frame(width: 100, alignment: .leading)
                    VStack {
                    TextEditor(text: $twitter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 225)
                        .disableAutocorrection(true)
                        .font(.system(size: 14))
                    }
                    .overlay(
                             RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                             )
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
        .onAppear {
            savedEventId = event.eventId ?? ""
        }
        .navigationBarTitle("Edit Event")
    }
    
    func saveImageLocally(imageData: Data) -> CKAsset? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let uniqueFilename = UUID().uuidString + ".png"
        let fileURL = documentDirectory.appendingPathComponent(uniqueFilename)

        do {
            try imageData.write(to: fileURL)
            return CKAsset(fileURL: fileURL)
        } catch {
            print("Error saving image locally: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getCoordinatesFromAddress(address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                completion(nil, error)
            } else if let placemark = placemarks?.first {
                let location = placemark.location
                let coordinate = location?.coordinate
                completion(coordinate, nil)
            } else {
                completion(nil, NSError(domain: "GeocodingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No placemarks found."]))
            }
        }
    }
    
    func saveRecordToCloudKit() {
        let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
        let publicDatabase = container.publicCloudDatabase
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
        
        if let selectedImage = selectedImage {
            if let imageAsset = saveImageLocally(imageData: selectedImage.pngData() ?? Data()) {
                if let imageURL = imageAsset.fileURL {
                    let imageNameWithoutExtension = imageURL.deletingPathExtension().lastPathComponent
                    record["imageName"] = imageNameWithoutExtension
                    record["image"] = imageAsset
                }
            }
        }

        let fullAddress = address + "," + city + "," + state

        getCoordinatesFromAddress(address: fullAddress) { (coordinate, error) in
            if let coordinate = coordinate {
                print("latitude = ", coordinate.latitude)
                print("longitude = ", coordinate.longitude)
                
                // Set the latitude and longitude in the CloudKit record here
                record["latitude"] = coordinate.latitude
                record["longitude"] = coordinate.longitude

                // Save the record inside this closure
                publicDatabase.save(record) { (savedRecord, error) in
                    if let error = error {
                        // Handle the error
                        print("Error saving record: \(error.localizedDescription)")
                    } else {
                        if let savedRecord = savedRecord {
                            print("Record saved successfully, eventID: \(savedRecord["eventId"] ?? "")")
                            print("isSponsored = ", isSponsored)
                            print("hasVendors = ", hasVendors)
                            isSaveSuccessful = true
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
                        }
                    }
                }
            } else if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                
                // You might want to handle the error case here, or not save the record at all
            }
        }
    }
}

