//
//  DatabaseManager.swift
//  ContactsDemoWithSQLite
//
//  Created by Pritesh Patel on 15/04/23.
//

import SQLite

class DatabaseManager {
    
    private let contacts = Table("contacts")
    private let id = Expression<Int64>("id")
    private let name = Expression<String?>("name")
    private let phone = Expression<String>("phone")
    private let email = Expression<String>("email")
    private let profilePhoto = Expression<Data>("profilePhoto")

    static let shared = DatabaseManager()
    private let dbConnection: Connection?
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            dbConnection = try Connection("\(path)/ContactsDB.sqlite3")
            createTable()
        } catch {
            dbConnection = nil
            print ("Unable to open database")
        }
    }
    
    func createTable() {
        do {
            try dbConnection!.run(contacts.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(phone, unique: true)
                table.column(email)
                table.column(profilePhoto)
                })
        } catch {
            print("Unable to create table")
        }
    }
    
    func addContact(cname: String, cphone: String, cemail: String, cprofilePhoto: Data) -> Int64? {
        do {
            let insert = contacts.insert(name <- cname, phone <- cphone, email <- cemail, profilePhoto <- cprofilePhoto)
            let id = try dbConnection!.run(insert)
            
            return id
        } catch {
            print("Insert failed")
            return nil
        }
    }
    
    func getContacts() -> [ContactModel] {
        var contacts = [ContactModel]()
        
        do {
            for contact in try dbConnection!.prepare(self.contacts) {
                contacts.append(ContactModel(
                    id: contact[id],
                    name: contact[name]!,
                    phone: contact[phone],
                    email: contact[email],
                    profilePhoto: contact[profilePhoto]))
            }
        } catch {
            print("Select failed")
        }
        
        return contacts
    }
    
    func deleteContact(cid: Int64) -> Bool {
        do {
            let contact = contacts.filter(id == cid)
            try dbConnection!.run(contact.delete())
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    
    func updateContact(cid:Int64, newContact: ContactModel) -> Bool {
        let contact = contacts.filter(id == cid)
        do {
            let update = contact.update([
                name <- newContact.name,
                phone <- newContact.phone,
                email <- newContact.email,
                profilePhoto <- newContact.profilePhoto
                ])
            if try dbConnection!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
}
