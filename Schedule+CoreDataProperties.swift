//
//  Schedule+CoreDataProperties.swift
//  EventZap
//
//  Created by Rhonda Bailey on 10/26/23.
//
//

import Foundation
import CoreData


extension Schedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schedule> {
        return NSFetchRequest<Schedule>(entityName: "Schedule")
    }

    @NSManaged public var eventId: String?
    @NSManaged public var id: Int64
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var scheduleDescription: String?
    @NSManaged public var time: String?
    @NSManaged public var type: String?
    @NSManaged public var scheduleItemId: String?

}

extension Schedule : Identifiable {

}
