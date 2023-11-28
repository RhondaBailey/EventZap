//
//  SponsorRow.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/25/23.
//

import SwiftUI

struct SponsorRow: View {
    var sponsor: Sponsors
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    /*Image(sponsor.logo ?? "saddle2")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(5)*/
                    if let imageData = sponsor.logo,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 50, height: 50)
                    } else {
                        Image("saddle2") // Use a default image if event.image is nil
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    Text(" - ")
                        .bold()
                    Text(sponsor.name ?? "")
                        .bold()
                        /*.onTapGesture {
                            if let url = URL(string: sponsor.website ?? "") {
                                UIApplication.shared.open(url)
                            }
                        }*/
                    
                }
            #if !os(watchOS)
                HStack {
                    Text(sponsor.type ?? "")
                        .font(.caption)
                        .foregroundColor(.primary)
                    Text(" - ")
                        .font(.caption)
                        .foregroundColor(.primary)
                    
                        Text(sponsor.desc ?? "")
                            .font(.caption)
                            .foregroundColor(.primary)
                    Text(sponsor.website ?? "")
                            .font(.caption)
                            .foregroundColor(.primary)
                }
                Text(sponsor.phone ?? "")
                    .font(.caption)
                    .foregroundColor(.primary)
                    .onTapGesture {
                        if let phoneURL = URL(string: "tel://\(sponsor.phone)") {
                            if UIApplication.shared.canOpenURL(phoneURL) {
                                UIApplication.shared.open(phoneURL)
                            } else {
                                #if targetEnvironment(simulator)
                                print("Phone calls are not available in the simulator.")
                                #else
                                // Handle the case where the device can't make phone calls, if necessary.
                                #endif
                            }
                        }
                    }
                
                #endif
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

/*struct SponsorRow_Previews: PreviewProvider {
    static var previews: some View {
        SponsorRow()
    }
}*/
