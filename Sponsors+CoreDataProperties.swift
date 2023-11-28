//
//  Sponsors+CoreDataProperties.swift
//  EventZap
//
//  Created by Rhonda Bailey on 10/26/23.
//
//

import Foundation
import CoreData


extension Sponsors {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sponsors> {
        return NSFetchRequest<Sponsors>(entityName: "Sponsors")
    }

    @NSManaged public var desc: String?
    @NSManaged public var eventId: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var logo: Data?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var sponsorDescription: Bool
    @NSManaged public var type: String?
    @NSManaged public var website: String?
    @NSManaged public var sponsorId: String?

}

extension Sponsors : Identifiable {

}
