//
//  ConatctModel.swift
//  ContactsDemoWithSQLite
//
//  Created by Pritesh Patel on 15/04/23.
//

import Foundation

struct ContactModel {
    let id: Int64?
    var name: String
    var phone: String
    var email: String
    var profilePhoto: Data

    init(id: Int64, name: String, phone: String, email: String, profilePhoto: Data) {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
        self.profilePhoto = profilePhoto
    }
    
    mutating func update(name: String, phone: String, email: String, profilePhoto: Data) {
        self.name = name
        self.phone = phone
        self.email = email
        self.profilePhoto = profilePhoto
    }
}
