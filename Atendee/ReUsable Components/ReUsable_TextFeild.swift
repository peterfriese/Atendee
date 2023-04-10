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
    @Binding var text: String
    var borderColor: Color
    var body: some View {
        HStack {
            Image(systemName: imageName)
            TextField(title, text: $text)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.none)
                .foregroundColor(.secondary)
                .font(Font.body.weight(.bold))
            
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor, lineWidth: 1.1)
        }
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
