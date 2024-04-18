//
//  ThankYouCard+CoreDataProperties.swift
//  WeeklyThanks
//
//  Created by Carl Rudling on 2024-04-18.
//
//

import Foundation
import CoreData


extension ThankYouCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ThankYouCard> {
        return NSFetchRequest<ThankYouCard>(entityName: "ThankYouCard")
    }

    @NSManaged public var count: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var message: String?
    @NSManaged public var sent: Bool
    @NSManaged public var theme: String?
    @NSManaged public var writeDate: Date?
    @NSManaged public var sentToSelf: Bool
    @NSManaged public var receiver: Receiver?
    @NSManaged public var user: User?

}

extension ThankYouCard : Identifiable {

}
