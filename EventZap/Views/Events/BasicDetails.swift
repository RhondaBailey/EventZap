//
//  BasicDetails.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/21/23.
//

import SwiftUI

struct BasicDetails: View {
    var event: Event
    
    /*Toggle(isOn: Binding(
     get: {
         event.isFavorite == 1
     },
     set: {
         event.isFavorite = $0 ? 1 : 0
     }
 )) {*/
  
    
    var body: some View {
        
        if let imageData = event.image,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                //.scaledToFit()
                .frame(width: 150, height: 150)
        } else {
            Image("saddle2") // Use a default image if event.image is nil
                .resizable()
                //.scaledToFit()
                .frame(width: 150, height: 150)
        }
        HStack {
            
            Text(event.name ?? "")
                .font(.system(size: 18))
                .bold()
            
                if event.isFavorite == 1 {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.gray)
                }
        }
        
        Divider()
        
        HStack {
            Text(event.startDate ?? "")
                .foregroundStyle(.black)
                .font(.system(size: 14))
                .bold()
            Text("-")
            Text(event.endDate ?? "")
                .foregroundStyle(.black)
                .font(.system(size: 14))
                .bold()
        }
        
        Text(event.facilityName ?? "")
            .font(.system(size: 14))
            .bold()
        HStack {
           Text(event.city ?? "")
                .font(.system(size: 14))
                .bold()
           Text(",")
           Text(event.state ?? "")
                .font(.system(size: 14))
                .bold()
       }
       Divider()
        Text(event.eventDescription ?? "")
            .font(.system(size: 14))
            .bold()
        
    }
    
    func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

/*struct BasicDetails_Previews: PreviewProvider {
    static var previews: some View {
        BasicDetails()
    }
}*/
