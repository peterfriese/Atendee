//
//  ReUseable_ValueFeild.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 10/04/2023.
//

import SwiftUI

struct ReUseable_ValueFeild: View {
    var title: String
    @Binding var value: Int
    var borderColor: Color
    @Binding var selectedMonth: String
    let months = ["Jan", "Fab", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            TextField(title, value: $value, format: .number)
                .multilineTextAlignment(.center)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.none)
                .foregroundColor(.secondary)
                .font(Font.body.weight(.bold))
                .padding(.top, 5)
            
            Picker("", selection: $selectedMonth) {
                ForEach(months, id: \.self) {
                    Text($0)
                }
            }
            .padding(.top, 4)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor, lineWidth: 1.1)
        }
    }
}

struct ReUseable_ValueFeild_Previews: PreviewProvider {
    @State static var value = 4843
    @State static var selectedMonth = "Jan"
    
    static var previews: some View {
        HStack(spacing: 10){
            ReUseable_ValueFeild(title: "Fee", value: $value, borderColor: .red, selectedMonth: $selectedMonth)
                .previewLayout(.sizeThatFits)
                //.padding()
            
            ReUseable_ValueFeild(title: "Fee", value: $value, borderColor: .red, selectedMonth: $selectedMonth)
                .previewLayout(.sizeThatFits)
                //.padding()
            
            ReUseable_ValueFeild(title: "Fee", value: $value, borderColor: .red, selectedMonth: $selectedMonth)
                .previewLayout(.sizeThatFits)
                //.padding()
        }
        .padding()
    }
}
