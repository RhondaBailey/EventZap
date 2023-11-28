//
//  EventContactForm.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/5/23.
//

import SwiftUI

struct EventContactForm: View {
    @State var phoneNumber: String = ""
    @State var website: String = ""
    @State var email: String = ""
    @State var facebook: String = ""
    @State var twitter: String = ""
    
    
    var body: some View {
        HStack {
            Text("Phone")
            TextField("", text: $phoneNumber)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
        }
        HStack {
            Text("Website")
            TextField("", text: $website)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
        }
        HStack {
            Text("Email")
            TextField("", text: $email)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
        }
        HStack {
            Text("Facebook")
            TextField("Facebook", text: $facebook)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
        }
        HStack {
            Text("Twitter")
            TextField("", text: $twitter)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
        }

    }
}

struct EventContactForm_Previews: PreviewProvider {
    static var previews: some View {
        EventContactForm()
    }
}
