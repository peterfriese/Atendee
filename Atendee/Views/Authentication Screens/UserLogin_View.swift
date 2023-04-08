//
//  UserLogin_View.swift
//  GymTendy
//
//  Created by Muhammad Farid Ullah on 26/02/2023.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import SwiftfulRouting

struct UserLogin_View: View {
    @EnvironmentObject var userAdmin_vm: Authentication_AdminUser_VM
    @State private var alertTitle = "User is getting"
    let router: AnyRouter
    @State private var secretCode: String = ""
    
    var body: some View {
        NavigationView {
            if userAdmin_vm.isUserLoggedIn {
                MainView()
            } else {
                userLoginView
            }
        }
        //.navigationBarBackButtonHidden(true)
        .toolbarRole(.editor)
    }
    
    var userLoginView: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    ReUsable_Logo(width: 275)
                    Spacer()
                }
                Spacer()
                
                Text("User Login")
                    .font(.title.bold())
                
                //textFields
                ReUsable_TextFeild(imageName: "envelope.fill", title: "Enter your gym incharge email", email: $userAdmin_vm.email).padding(.vertical)
                
                ReUsable_TextFeild(imageName: "lock.fill", title: "Enter the provided Secret Code", email: $secretCode)
                
                ReUsable_Button(title: "Login", buttonBackgroundColor: Color("softbutton_Color")) {
                    
                    userAdmin_vm.validate_user(email: userAdmin_vm.email, secretCode: secretCode) { isAvailable in
                        if isAvailable {
                            print("User is exist...")
                            alertTitle = "User is exist"
                        } else {
                            print("user is not exist...")
                            alertTitle = "user is not exist"
                            
                        }
                    }
                }
                
                Text(alertTitle)
                    .font(.title)
                    .foregroundColor(alertTitle == "Email is available" ? .green : .red)
                
                Spacer()
                
            }
            .padding(.horizontal)
        }
    }
}

struct UserLogin_View_Previews: PreviewProvider {
    static var previews: some View {
        RouterView { router in
            UserLogin_View(router: router)
                .environmentObject(Authentication_AdminUser_VM())
        }
    }
}
