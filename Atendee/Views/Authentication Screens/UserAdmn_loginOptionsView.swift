//
//  UserAdmn_loginOptionsView.swift
//  GymTendy
//
//  Created by Muhammad Farid Ullah on 26/02/2023.
//

import SwiftUI
import SwiftfulRouting
import FirebaseAuth

struct UserAdmn_loginOptionsView: View {
    let router: AnyRouter
    @EnvironmentObject var userAdmin_vm: Authentication_AdminUser_VM
    
    var body: some View {
        NavigationView {
            Two_optionsView
        }
        .toolbarRole(.editor)
    }
    
    var Two_optionsView: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    ReUsable_Logo(width: 250)
                    Spacer()
                }
                Spacer()
                
                Text("There are two options, one is for Gym incharge and one is for a specific gym user. So if you are gym incharge then go with Login as an Admin else Login as a User if the Gym incharge provided you his email and secret code")
                    .font(.title3)
                
                Text("Login Methods")
                    .font(.title.bold())
                    .padding(.top)
                
                ReUsable_Button(title: "Login as an Admin", buttonBackgroundColor: Color("softbutton_Color")) {
                    router.showScreen(.push) { router in
                        Admin_LoginView(router: router)
                    }
                }.foregroundColor(.white)
                
                ReUsable_Button(title: "Login as a User", buttonBackgroundColor: Color("softbutton_Color")) {
                    //let currentUser = Auth.auth().currentUser
                    //print("Here is the current user logged in user: \(currentUser)")
                    router.showScreen(.push) { router in
                        UserLogin_View(router: router)
                    }
                }
                Spacer()
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
}

struct UserAdmn_loginOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        RouterView { router in
            UserAdmn_loginOptionsView(router: router)
                .environmentObject(Authentication_AdminUser_VM())
                .environmentObject(UserData_VM())
        }
    }
}
