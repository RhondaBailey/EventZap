//
//  EventDetailsForm.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/5/23.
//

import SwiftUI
import CloudKit

struct EventDetailsForm: View {
    @State var description: String = ""
    @State var address: String = ""
    @State var city: String = ""
    @State var state: String = ""
    @State var showManager: String = ""
    @State var isSponsored: Bool = false
    @State var hasVendors: Bool = false
    
    var body: some View {
        HStack {
            Text("Description")
            Spacer()
            TextField("", text: $description)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
        }
        HStack {
            Text("Address")
            Spacer()
            TextField("", text: $address)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
        }
        HStack {
            Text("City")
            Spacer()
            TextField("", text: $city)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
        }
        HStack {
            Text("State")
            Spacer()
            TextField("", text: $state)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
        }
        HStack {
            Text("Show Manager")
            Spacer()
            TextField("", text: $showManager)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
        }
        
        Toggle(isOn: $isSponsored) {
            Text("Has Sponsors")
        }
        Toggle(isOn: $hasVendors) {
            Text("Has Vendors")
        }
    }
}

struct EventDetailsForm_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailsForm()
    }
}
