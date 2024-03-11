//
//  ThankYouCard+CoreDataProperties.swift
//  WeeklyThanks
//
//  Created by Carl Rudling on 2024-03-10.
//
//

import Foundation
import CoreData


extension ThankYouCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ThankYouCard> {
        return NSFetchRequest<ThankYouCard>(entityName: "ThankYouCard")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var message: String?
    @NSManaged public var sent: Bool
    @NSManaged public var writeDate: Date?
    @NSManaged public var receiver: Receiver?
    @NSManaged public var user: User?

}

extension ThankYouCard : Identifiable {

}
