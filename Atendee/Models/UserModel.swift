//
//  File.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 03/04/2023.
//

import Foundation
import SwiftUI

struct User: Identifiable, Codable {
    var id: String = UUID().uuidString  //MARK: @docID
    var name: String
    var serialNo: String  //combination of string or only int
    var profileUIimage: URL?
    let userAdding_date: Date
    let userContact: String
}
//    var timeAgo: String {
//        let formatter = RelativeDateTimeFormatter()
//        formatter.unitsStyle = .abbreviated
//        return formatter.localizedString(for: userAdding_date, relativeTo: Date())
//    }
