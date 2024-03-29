//
//  ContactsManager.swift
//  WeeklyThanks
//
//  Created by Carl Rudling on 2024-03-03.
//

import Foundation
import Contacts


struct ContactsManager {
    
    func requestAccessToContacts(completion: @escaping (Bool) -> Void) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    
    func fetchContacts(completion: @escaping ([CNContact]) -> Void) {
        let store = CNContactStore()
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        var contacts: [CNContact] = []
        
        do {
            try store.enumerateContacts(with: fetchRequest) { (contact, stop) in
                contacts.append(contact)
            }
            // Sort the contacts array based on the givenName
            contacts.sort { $0.givenName < $1.givenName }
            
            DispatchQueue.main.async {
                completion(contacts)
            }
        } catch let error {
            print("Failed to fetch contacts: \(error)")
        }
    }


    
    
}
