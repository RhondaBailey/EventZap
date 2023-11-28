//
//  AdvancedDetails.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/21/23.
//

import SwiftUI

struct AdvancedDetails: View {
    var event: Event
    
    var body: some View {
        
        HStack {
            
            Text("Show Manager - ")
                .font(.system(size: 14))
                .bold()
                .frame(width: 140, height: 30, alignment: .leading)
            Text(event.showManager ?? "")
                .font(.system(size: 14))
              
        }
        HStack {
            Text("Phone Number - ")
                .font(.system(size: 14))
                .bold()
                .frame(width: 140, height: 30, alignment: .leading)
            Text(event.phoneNumber ?? "")
                .font(.system(size: 14))
        }
        HStack {
            Text("Email - ")
                .font(.system(size: 14))
                .bold()
                .frame(width: 140, height: 30, alignment: .leading)
            Text(event.email ?? "" )
                .font(.system(size: 14))
        }
        HStack {
            Text("Addresss - ")
                .font(.system(size: 14))
                .bold()
                .frame(width: 140, height: 30, alignment: .leading)
            if let address = event.address, !address.isEmpty {
                Text(address)
                    .font(.system(size: 14))
                    .onTapGesture {
                        if let address = event.address {
                            let urlString = "http://maps.apple.com/?address=" + address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                            if let url = URL(string: urlString) {
                                UIApplication.shared.open(url)
                            } else {
                                print("Invalid URL")
                            }
                        } else {
                            print("Empty address")
                        }
                    }


            } else {
                Text("N/A") // or any other placeholder text if address is nil or empty
            }
        }
        Divider()
        
        HStack {
            NavigationLink(destination: ScheduleView(event: event)) {
                Text("Schedule")
                    .font(.system(size: 14))
                    .bold()
                //.fontWeight(.semibold)
            }
            .frame(width: 100.0, height: 1)
            .tag(event)
          
            //.background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))
            
            NavigationLink(destination: VendorView(event: event)) {
                Text("Vendors")
                    .font(.system(size: 14))
                    .bold()
                //.fontWeight(.semibold)
            }
            .frame(width: 100.0, height: 1)
            .tag(event)
           
            //.background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))
            
            NavigationLink(destination: SponsorView(event: event)) {
                Text("Sponsors")
                    .font(.system(size: 14))
                    .bold()
                //.fontWeight(.semibold)
            }
            .frame(width: 100.0, height: 1)
            .tag(event)
           
            //.background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))
        
        }
        .padding()
            
        Divider()
        /*MapView(coordinate: event.locationCoordinate, pins: [])
            .ignoresSafeArea(edges: .top)
            .frame(height: 300)
            .onTapGesture {
                if !event.address.isEmpty, let url = URL(string: "http://maps.apple.com/?address=" + event.address) {
                        UIApplication.shared.open(url)
                    }
            }*/
        HStack {
            VStack {
                Link(destination: URL(string: event.website ?? "")!)
                {
                    Image(systemName: "w.circle.fill")
                        .font(.largeTitle)
                }
                Text("Web")
                    .font(.system(size: 14))
                    .bold()
            }
            /*Spacer()
            Link(destination: URL(string: event.email)!)
            {
                Image(systemName: "envelope.circle.fill")
                    .font(.largeTitle)
            }*/
            Spacer()
            VStack {
                Link(destination: URL(string: event.facebook ?? "")!)
                {
                    Image(systemName: "link.circle.fill")
                        .font(.largeTitle)
                }
                Text("Facebook")
                    .font(.system(size: 14))
                    .bold()
            }
            Spacer()
            VStack {
                Link(destination: URL(string: event.twitter ?? "")!)
                {
                    Image(systemName: "t.circle.fill")
                        .font(.largeTitle)
                }
                Text("Twitter")
                
            }
        }
        .frame(alignment: .bottom)
    }
}

/*struct AdvancedDetails_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedDetails()
    }
}*/
