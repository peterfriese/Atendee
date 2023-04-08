//
//  frrre.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 03/04/2023.
//

import SwiftUI

//✅
struct ReUsable_Logo: View {
    let width: CGFloat
    var body: some View {
        Image("logo6")
            .resizable()
            .scaledToFit()
            .frame(width: width)
    }
}

struct ReUsable_Logo_Previews: PreviewProvider {
    static var previews: some View {
        ReUsable_Logo(width: 275.7)
    }
}
