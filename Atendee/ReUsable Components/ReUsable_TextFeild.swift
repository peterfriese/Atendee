//
//  File.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 03/04/2023.
//

import Foundation
import SwiftUI

//✅
struct ReUsable_TextFeild: View {
    var imageName: String
    var title: String
    @Binding var email: String
    var body: some View {
        HStack {
            Image(systemName: imageName)
            TextField(title, text: $email)
                .foregroundColor(.secondary)
                .font(Font.body.weight(.bold))
        }
        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 10)
//                .fill(Color("backgroundColor"))
//                .softInnerShadow(RoundedRectangle(cornerRadius: 10), lightShadow: Color("shadow"))
//                .overlay {
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color("softbutton_Color").opacity(0.4), lineWidth: 2)
//                }
//        )
    }
}


//struct reusable_TextField_Previews: PreviewProvider {
//    static var previews: some View {
//        reusable_TextField()
//    }
//}
