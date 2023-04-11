//
//  File.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 03/04/2023.
//

import Foundation
import SwiftUI
import iPhoneNumberField

//✅
struct ReUsable_TextFeild: View {
    var imageName: String
    var title: String
    @Binding var text: String
    var borderColor: Color
    let roundedCornerButtonColor = Color("softbutton_Color")
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(roundedCornerButtonColor)
            TextField(title, text: $text)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.none)
                .foregroundColor(.secondary)
                .font(Font.body.weight(.bold))
            
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor, lineWidth: 1.5)
        }
    }
}

//struct reusable_TextField_Previews: PreviewProvider {
//    static var previews: some View {
//        reusable_TextField()
//    }
//}
