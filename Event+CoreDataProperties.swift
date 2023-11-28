//
//  Event+CoreDataProperties.swift
//  EventZap
//
//  Created by Rhonda Bailey on 10/16/23.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var address: String?
    @NSManaged public var categoryId: Int32
    @NSManaged public var city: String?
    @NSManaged public var email: String?
    @NSManaged public var endDate: String?
    @NSManaged public var eventDescription: String?
    @NSManaged public var eventId: String?
    @NSManaged public var eventType: String?
    @NSManaged public var facebook: String?
    @NSManaged public var facilityName: String?
    @NSManaged public var hasVendors: Int64
    @NSManaged public var id: String?
    @NSManaged public var image: Data?
    @NSManaged public var imageName: String?
    @NSManaged public var isFavorite: Int64
    @NSManaged public var isFeatured: Int64
    @NSManaged public var isSponsored: Int64
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var scheduleType: Int64
    @NSManaged public var showManager: String?
    @NSManaged public var startDate: String?
    @NSManaged public var state: String?
    @NSManaged public var twitter: String?
    @NSManaged public var website: String?

}

extension Event : Identifiable {

}
