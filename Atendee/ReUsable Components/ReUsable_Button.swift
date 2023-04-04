//
//  ReUsable_Button.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 03/04/2023.
//

import Foundation
import SwiftUI

//✅
struct ReUsable_Button: View {
    var title: String
    var buttonBackgroundColor: Color
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Text(title)
                .padding(.vertical)
                .foregroundColor(Color("textColor"))
                .frame(maxWidth: .infinity)
                .font(Font.body.bold())
                .background(buttonBackgroundColor)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .padding(.vertical)
        //.disabled(user_vm.email.isEmpty && user_vm.password.isEmpty)
    }
}


//struct reusable_TextField_Previews: PreviewProvider {
//    static var previews: some View {
//        reusable_TextField()
//    }
//}
