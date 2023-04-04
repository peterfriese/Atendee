//
//  djjw.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 03/04/2023.
//

import SwiftUI

//✅
struct Sign_inWith_Button: View {
    var title: String
    var image: String
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Label(title, systemImage: image)
            .font(Font.body.bold())
            .padding()
            .foregroundColor(Color("textColor"))
            .frame(width: 177, height: 55)
            .background(Color("softbutton_Color"))
            .cornerRadius(10)
            .shadow(radius: 5)
            
        }
        //.padding(.horizontal)
    }
}

struct Sign_inWith_Button_Previews: PreviewProvider {
    static var previews: some View {
        Sign_inWith_Button(title: "Sign In with Google", image: "g.circle", onClick: {})
    }
}
