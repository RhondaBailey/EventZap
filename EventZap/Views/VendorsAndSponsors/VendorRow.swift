//
//  VendorRow.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/22/23.
//

import SwiftUI

struct VendorRow: View {
    var vendor: Vendors
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    /*Image(vendor.logo ?? "saddle2")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(5)*/
                    if let imageData = vendor.logo,
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
                    Text(vendor.name ?? "")
                        .bold()
                        .onTapGesture {
                            if let url = URL(string: vendor.website ?? "") {
                                UIApplication.shared.open(url)
                            }
                        }
                    
                }
            #if !os(watchOS)
                HStack {
                        Text(vendor.productLine ?? "")
                        .font(.caption)
                        .foregroundColor(.primary)
                    Text(" - ")
                        .font(.caption)
                        .foregroundColor(.primary)
                    
                        Text(vendor.vendorDescription ?? "")
                            .font(.caption)
                            .foregroundColor(.primary)
                        Text(vendor.website ?? "")
                            .font(.caption)
                            .foregroundColor(.primary)
                }
                Text(vendor.phone ?? "")
                    .font(.caption)
                    .foregroundColor(.primary)
                    .onTapGesture {
                        if let phoneURL = URL(string: "tel://\(vendor.phone)") {
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

/*struct VendorRow_Previews: PreviewProvider {
    static var previews: some View {
        VendorRow()
    }
}*/
