//
//  AdminModel.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 12/04/2023.
//

import Foundation
struct Admin: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var email: String
    var password: String
    var uid: String
    var profileUIimage: URL?
}

/*
 let id = snapshot?.documentID
 
 let name = data["name"] as? String ?? ""
 
 let email = data["email"] as? String ?? ""
 
 let password = data["password"] as? String ?? ""
 
 let uid = data["uid"] as? String ?? ""
 
 let profileImageURLString = data["profileUIimage"] as? String ?? ""
 let profileUIimage = URL(string: profileImageURLString) 
 */
