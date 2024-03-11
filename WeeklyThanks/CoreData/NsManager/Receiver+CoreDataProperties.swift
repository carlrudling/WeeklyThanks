//
//  Receiver+CoreDataProperties.swift
//  WeeklyThanks
//
//  Created by Carl Rudling on 2024-03-10.
//
//

import Foundation
import CoreData


extension Receiver {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receiver> {
        return NSFetchRequest<Receiver>(entityName: "Receiver")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var telephoneNumber: String?
    @NSManaged public var userNickname: String?
    @NSManaged public var thankYouCards: NSSet?

}

// MARK: Generated accessors for thankYouCards
extension Receiver {

    @objc(addThankYouCardsObject:)
    @NSManaged public func addToThankYouCards(_ value: ThankYouCard)

    @objc(removeThankYouCardsObject:)
    @NSManaged public func removeFromThankYouCards(_ value: ThankYouCard)

    @objc(addThankYouCards:)
    @NSManaged public func addToThankYouCards(_ values: NSSet)

    @objc(removeThankYouCards:)
    @NSManaged public func removeFromThankYouCards(_ values: NSSet)

}

extension Receiver : Identifiable {

}
