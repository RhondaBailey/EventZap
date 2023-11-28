//
//  Vendors+CoreDataProperties.swift
//  EventZap
//
//  Created by Rhonda Bailey on 10/26/23.
//
//

import Foundation
import CoreData


extension Vendors {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vendors> {
        return NSFetchRequest<Vendors>(entityName: "Vendors")
    }

    @NSManaged public var eventId: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var logo: Data?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var productLine: String?
    @NSManaged public var vendorDescription: String?
    @NSManaged public var vendorName: String?
    @NSManaged public var website: String?
    @NSManaged public var vendorId: String?

}

extension Vendors : Identifiable {

}
