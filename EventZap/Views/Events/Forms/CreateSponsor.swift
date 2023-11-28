//
//  CreateSponsor.swift
//  EventZap
//
//  Created by Rhonda Bailey on 10/17/23.
//

import SwiftUI
import CloudKit
import Foundation
import CoreLocation

struct CreateSponsor: View {
    @State private var id: String = ""
    @State private var eventId: Int = 0
    @State private var name: String = ""
    @State private var sponsorDescription: String = ""
    @State private var phone: String = ""
    @State private var type: String = ""
    @State private var website: String = ""
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    
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
                    Text("phone")
                    Spacer()
                    TextField("", text: $phone)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                        .disableAutocorrection(true)
                }
                HStack {
                    Text("Description")
                    Spacer()
                    TextField("", text: $sponsorDescription)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                }
                HStack {
                    Text("Sponsor Level")
                    Spacer()
                    TextField("", text: $type)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                        .disableAutocorrection(true)
                }
                HStack {
                    Text("Website")
                    Spacer()
                    TextField("", text: $website)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                        .disableAutocorrection(true)
                }
                Button(action: {
                    isImagePickerPresented.toggle()
                }) {
                    Text("Select Image")
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
                    addAnotherSponsor()
                }) {
                    Text("Add Another")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
            }.navigationBarTitle("Add Sponsor")
                /*.toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                    #if !os(watchOS)
                        NavigationLink(destination: CreateSponsor(savedEventId:  $savedEventId)) {
                            Text("+")
                                .font(.body)
                                .fontWeight(.semibold)
                        }
                        #endif
                    }
                }*/
        }
    }
    
    func addAnotherSponsor() {
        name = ""
        sponsorDescription = ""
        website = ""
        phone = ""
        type = ""
        print(savedEventId)
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
    
    func saveRecordToCloudKit() {
        //let container = CKContainer.default()
        let container = CKContainer(identifier: "iCloud.com.blackwoodgypsy.EventZap")
        let publicDatabase = container.publicCloudDatabase
        let sponsorID = UUID().uuidString

        // Create a CKRecord
        let record = CKRecord(recordType: "Sponsors")
        record["eventId"] = savedId as CKRecordValue
        record["name"] = name as CKRecordValue
        record["id"] = 1001 as CKRecordValue
        record["type"] = type as CKRecordValue
        record["description"] = sponsorDescription as CKRecordValue
        record["website"] = website as CKRecordValue
        record["phone"] = phone as CKRecordValue
        record["sponsorId"] = sponsorID  as CKRecordValue
        print("eventId (savedId) = ", savedId)
        print("sponsorId = ", sponsorID)
        
        if let selectedImage = selectedImage {
            if let imageAsset = saveImageLocally(imageData: selectedImage.pngData() ?? Data()) {
                if let imageURL = imageAsset.fileURL {
                    let imageNameWithoutExtension = imageURL.deletingPathExtension().lastPathComponent
                    record["imageName"] = imageNameWithoutExtension
                    record["logo"] = imageAsset
                }
            }
        }
        
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

/*struct CreateSponsor_Previews: PreviewProvider {
    static var previews: some View {
        CreateSponsor()
    }
}*/
