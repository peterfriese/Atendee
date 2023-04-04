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
        .navigationBarBackButtonHidden(true)
        .onAppear {//it ensure that the user is always logged out when the Login_View is presented.
            if let user = Auth.auth().currentUser {
                //user_vm.signOut()
                print("Firuser in login view: \(user)")
                print("User is logedOut from UserLogin_View")
            }
            //also work.
            //user_vm.signOut()
        }
    }
    
    var userLoginView: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                //MARK: The fitness Club logo.
                HStack(alignment: .top) {
                    
                    ReUsable_BackButton {
                        router.dismissScreen()
                    }
                    
                    ReUsable_Logo()
                        .padding(.leading, 20)
                    
                }.padding(.top, 7)
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
                    
                    
//                    user_vm.userLogin(email: user_vm.email) { isAvailable in
//                        if isAvailable {
//                            print("Email is available")
//                            alertTitle = "Email is available"
//                            alertTitle = "SecretCode is available"
//                            user_vm.currentUser = user_vm.email
//                            user_vm.isUserLoggedIn = true
//                            user_vm.fetchUsers()
//                        } else {
//                            print("Email is not available")
//                            alertTitle = "Email is not available"
//                        }
//
//                    }
                }
                
                Text(alertTitle)
                    .font(.title)
                    .foregroundColor(alertTitle == "Email is available" ? .green : .red)
                
                Spacer()
                
            }
            .padding(.horizontal)
        }
    }
    
//    var textFields: some View {
//        Group {
//            HStack {
//                Image(systemName: "envelope.fill")
//                TextField("Enter your gym incharge email", text: $user_vm.email)
//                    .foregroundColor(.secondary)
//                    .font(Font.body.weight(.bold))
//            }
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color("backgroundColor"))
//                    .softInnerShadow(RoundedRectangle(cornerRadius: 10), lightShadow: Color("shadow"))
//            )
//            .padding(.vertical)
//
//            HStack {
//                Image(systemName: "envelope.fill")
//                TextField("Secret Code", text: $secretCode)
//                    .foregroundColor(.secondary)
//                    .font(Font.body.weight(.bold))
//            }
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color("backgroundColor"))
//                    .softInnerShadow(RoundedRectangle(cornerRadius: 10), lightShadow: Color("shadow"))
//            )
//        }
//    }
}








//struct UserLogin_View_Previews: PreviewProvider {
//    static var previews: some View {
//        UserLogin_View(router: AnyRouter(object: Router.self as! Router ))
//    }
//}


//button
/*
 //                Button {
 //                    user_vm.userLogin(email: user_vm.email) { isAvailable in
 //                        if isAvailable {
 //                            print("Email is available")
 //                            alertTitle = "Email is available"
 //                            user_vm.currentUser = user_vm.email
 //                            user_vm.isUserLoggedIn = true
 //                            user_vm.fetchUsers()
 //                        } else {
 //                            print("Email is not available")
 //                            alertTitle = "Email is not available"
 //                        }
 //                    }
 //                } label: {
 //                    Text("Login")
 //                        .frame(maxWidth: .infinity)
 //                        .font(Font.body.bold())
 //                }
 //                .softButtonStyle(
 //                    RoundedRectangle(cornerRadius: 10),
 //                    mainColor: Color("backgroundColor"),
 //                    textColor: Color.primary,
 //                    lightShadowColor: Color("shadow")
 //                )
 //                .padding(.vertical)
                 
                 
 */
