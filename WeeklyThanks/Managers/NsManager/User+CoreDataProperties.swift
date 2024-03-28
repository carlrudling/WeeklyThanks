//
//  User+CoreDataProperties.swift
//  WeeklyThanks
//
//  Created by Carl Rudling on 2024-03-28.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var count: Int64
    @NSManaged public var email: String?
    @NSManaged public var goalWeekStrike: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var sendCardGoal: Int64
    @NSManaged public var sentCardsThisWeek: Int64
    @NSManaged public var thankYouCards: NSSet?

}

// MARK: Generated accessors for thankYouCards
extension User {

    @objc(addThankYouCardsObject:)
    @NSManaged public func addToThankYouCards(_ value: ThankYouCard)

    @objc(removeThankYouCardsObject:)
    @NSManaged public func removeFromThankYouCards(_ value: ThankYouCard)

    @objc(addThankYouCards:)
    @NSManaged public func addToThankYouCards(_ values: NSSet)

    @objc(removeThankYouCards:)
    @NSManaged public func removeFromThankYouCards(_ values: NSSet)

}

extension User : Identifiable {

}
