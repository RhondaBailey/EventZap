//
//  EventDetail.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/21/23.
//

import SwiftUI

struct EventDetail: View {
    var event: Event
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                BasicDetails(event: event)
                    
                
                Divider()
                
             AdvancedDetails(event: event)
                    
            }
            .padding()
            
            Divider()
            NavigationLink(destination: EditEvent(event: event)){
                Text("Edit")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .buttonStyle(PlainButtonStyle())
            //.frame(maxWidth: .infinity)
            .frame(width: 300)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
            
        }
    }
}

/*struct EventDetail_Previews: PreviewProvider {
    static var previews: some View {
        EventDetail()
    }
}*/
