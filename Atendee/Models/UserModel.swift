//
//  File.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 03/04/2023.
//

import Foundation
import SwiftUI

struct User: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var serialNo: String
    var profileUIimage: Data
    
    
    
//    let example = User(name: "Jemmy", serialNo: "Khan", profileUIimage: Data(count: 0), example: <#T##arg#>)
}
