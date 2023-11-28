//
//  Event.swift
//  EventZap
//
//  Created by Rhonda Bailey on 9/12/23.
//

import Foundation
import CloudKit

class Events {
    var name: String
    var endDate: Date
    var startDate: Date
    var address: String
    var facilityName: String

    init(name: String, endDate: Date, startDate: Date, address: String, facilityName: String) {
        self.name = name
        self.endDate = endDate
        self.startDate = startDate
        self.address = address
        self.facilityName = facilityName
    }

    convenience init?(record: CKRecord) {
        guard let name = record["name"] as? String,
              let endDate = record["endDate"] as? Date,
              let startDate = record["startDate"] as? Date,
              let address = record["address"] as? String,
              let facilityName = record["facilityName"] as? String else {
            return nil
        }

        self.init(name: name, endDate: endDate, startDate: startDate, address: address, facilityName: facilityName)
    }
}
