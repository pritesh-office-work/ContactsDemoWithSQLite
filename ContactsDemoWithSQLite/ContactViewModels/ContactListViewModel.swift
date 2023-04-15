//
//  ContactListViewModel.swift
//  ContactsDemoWithSQLite
//
//  Created by Pritesh Patel on 15/04/23.
//

import Foundation

class ContactListViewModel {
    
    internal var contacts: [ContactModel] = []
    
    func getContacts() {
        
        contacts = DatabaseManager.shared.getContacts()
        print(contacts)
    }
}
