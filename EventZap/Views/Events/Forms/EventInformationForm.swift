//
//  EventInformationForm.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/5/23.
//

import SwiftUI

struct EventInformationForm: View {
    @State var name: String = ""
    @State var eventType: String = ""
    @State var facilityName: String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var categoryId: Int = 0
    @State private var date = Date()
    
    var body: some View {
        Picker("Event Type", selection: $categoryId) {
            Text("Horse Show").tag(0)
            Text("Renaissance Faire").tag(1)
        }
        .pickerStyle(MenuPickerStyle())
        HStack {
            Text("Name")
            Spacer()
            TextField("", text: $name)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
        }
        HStack {
            Text("Facility Name")
            Spacer()
            TextField("", text: $facilityName)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
        }
        DatePicker(
            "Start Date",
            selection: $startDate,
            displayedComponents: [.date]
        )
        DatePicker(
            "End Date",
            selection: $endDate,
            displayedComponents: [.date]
        )
    }
}

struct EventInformationForm_Previews: PreviewProvider {
    static var previews: some View {
        EventInformationForm()
    }
}
