//
//  EventRow.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/21/23.
//

import SwiftUI

struct EventRow: View {
    var event: Event
    var body: some View {
        
        HStack {
            if let imageData = event.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 50, height: 50)
            } else {
                Image("saddle2") // Use a default image if event.image is nil
                    .resizable()
                    .frame(width: 50, height: 50)
            }

            VStack(alignment: .leading) {
                HStack {
                    Text(event.name ?? "")
                        .bold()
                    Text(" - ")
                        .bold()
                    Text(event.state ?? "")
                        .bold()
                }
            #if !os(watchOS)
                Text((event.startDate ?? "") + " - " + (event.endDate ?? ""))
                    .font(.caption)
                    .foregroundColor(.secondary)
                #endif
            }

            Spacer()
            
            if event.isFavorite == 1 {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
        .padding(.vertical, 4)
    }
}

/*struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        EventRow()
    }
}*/
