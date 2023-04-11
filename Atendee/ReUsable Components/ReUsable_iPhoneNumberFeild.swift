//
//  SwiftUIView.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 11/04/2023.
//

import SwiftUI
import iPhoneNumberField

struct ReUsable_iPhoneNumberFeild: View {
    var title: String
    @Binding var text: String
    var borderColor: Color
    let roundedCornerButtonColor = Color("softbutton_Color")
    var body: some View {
        
        iPhoneNumberField(title,text: $text)
            .flagHidden(false)
            .flagSelectable(true)
            //.placeholderColor(Color.green)
            .prefixHidden(false)
        //.font(UIFont(size: 30, weight: .light, design: .monospaced))
            .maximumDigits(10)
            //.autocorrectionDisabled()
            //.textInputAutocapitalization(.none)
            //.foregroundColor(.secondary)
            .font(Font.body.weight(.bold))
            .multilineTextAlignment(.center)
            
            //.clearButtonMode(.always)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 1.5)
            }
    }
}

struct ReUsable_iPhoneNumberFeild_Previews: PreviewProvider {
    @State static var text = ""
    static var previews: some View {
        ReUsable_iPhoneNumberFeild(title: "", text: $text, borderColor: .red)
    }
}
