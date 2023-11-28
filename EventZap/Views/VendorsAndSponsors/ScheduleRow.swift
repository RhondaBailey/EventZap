//
//  ScheduleRow.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/22/23.
//

import SwiftUI

struct ScheduleRow: View {
    var schedule: Schedule
    
    var body: some View {
       
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(String(schedule.id))
                    Text(" - ")
                        .bold()
                    Text(schedule.name ?? "")
                        .bold()
                    
                }
            #if !os(watchOS)
                HStack {
                    Text((schedule.time ?? "") + " - ")
                        .font(.caption)
                        .foregroundColor(.primary)
                    
                    Text(schedule.location ?? "")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                
                Text(schedule.scheduleDescription  ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)

                #endif
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

/*struct ScheduleRow_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleRow()
    }
}*/
