
//  Login_View.swift
//  GymTendy
//
//  Created by Muhammad Farid Ullah on 04/02/2023.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import SwiftfulRouting

struct Login_View: View {
    @EnvironmentObject var userAdmin_vm: Authentication_AdminUser_VM
    @State private var isLoginView = false
    let router: AnyRouter
    
    var body: some View {
        NavigationView {
            if userAdmin_vm.isUserLoggedIn {
                MainView()
            } else {
                loginView
            }
        }
        .navigationBarBackButtonHidden(true)
//        .onAppear { //it ensure that the user is always logged out when the Login_View is presented.
//            print("the user is")//check user
//            if let user = Auth.auth().currentUser {
//                //user_vm.signOut()
//                user_vm.isUserLoggedIn = false
//                print("Firuser: \(user)")
//                print("current user is available...")
//            }
//        }
    }
    
    var loginView: some View {
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
                    
                }
                .padding(.top, 7)
                Spacer()
                
                Text("Admin Login")
                    .font(.title.bold())
                    .padding(.top)
                    .padding(.top)
                
                
                //MARK: The Textfields.
                //textfeilds
                ReUsable_TextFeild(imageName: "envelope.fill", title: "Enter your email here...", email: $userAdmin_vm.email)
                    .padding(.vertical)
                
                ReUsable_TextFeild(imageName: "lock.fill", title: "Enter your password here...", email: $userAdmin_vm.password)
                    //.padding(.vertical)
                
                //MARK: forgot button.
                HStack {
                    Text(userAdmin_vm.error_Message)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                    Spacer()
                    Text("Forgot password")
                        .font(.subheadline)
                }
                
                
                //MARK: login button.
                
                ReUsable_Button(
                    title: "Login", buttonBackgroundColor: userAdmin_vm.email.isEmpty ? Color("softbutton_Color").opacity(0.4) : Color("softbutton_Color")) {
                        userAdmin_vm.validateEmail_Password_adminLogin()
                }
                .padding(.top)
                .disabled(userAdmin_vm.email.isEmpty && userAdmin_vm.password.isEmpty)
                
                //MARK: The OR section.
                VStack {
                    Text("OR")
                    HStack(spacing: 5) {
                        //MARK: Google sign in.
                        Sign_inWith_Button(title: "Sign in with", image: "g.circle", onClick: {
//                            userAdmin_vm.progressBar_rolling = true
//                            userAdmin_vm.admin_signInWithGoogle()
                            userAdmin_vm.progressBar_rolling = true
                        })
                        //.padding(.vertical)
                        
                        Sign_inWith_Button(title: "Sign In with", image: "apple.logo") {
                            //
                        }
                    }
                }

                //Spacer()
                
                //MARK: don't have an account button.
                HStack {
                    Spacer()
                    Text("Don't have an account?")
                    Button {
                        router.showScreen(.push) { router in
                            SignUp_View(router: router)
                        }
                    } label: {
                        Text("Sign Up")
                    }.foregroundColor(.blue)
                    Spacer()
                }
                .padding()
                
                Spacer()
                
            }
            .padding(.horizontal)
            
            
            // MARK: The progress bar when user click on the login button
            if userAdmin_vm.progressBar_rolling {
                ZStack {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Material.ultraThin)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                    
                    
                    RoundedRectangle(cornerRadius: 8)
                        //.fill(Material.ultraThin)
                        .fill(Color.green)
                        .frame(width: 125, height: 125)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .overlay {
                            VStack(spacing: 15) {
                                Spacer()
                                ProgressView()
                                //Spacer()
                                Text("Logging...")
                                Spacer()
                            }
                        }
                }
            }
            
            
        }
        .onAppear {
//            Auth.auth().addStateDidChangeListener { auth, user in
//                print("loginView c_user: \(String(describing: auth.currentUser))")
//                if user != nil {
//                    userAdmin_vm.isUserLoggedIn = true
//                    print("Akh drama: \(userAdmin_vm.isUserLoggedIn)")
//                }
//            }
        }
        
    }
}

//struct Login_View_Previews: PreviewProvider {
//    static var previews: some View {
//        Login_View()
//    }
//}









//Button
/*
 //                Button {
 //                    user_vm.login()
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












/*
 VStack {
     Text("OR")
     
     //MARK: Google sign in.
     Button {
         vm.signInWithGoogle()
     } label: {
             Text("Sign In with Google")
             .frame(maxWidth: .infinity)
             .font(Font.body.bold())               .overlay(
                 HStack { //now i need you guidline...
                     Spacer()
                     Image(systemName: "g.circle")
                         .font(.title2)
                         .padding()
                         .foregroundColor(.white)
                         .padding(.trailing, 40)
                 }
             )
     }
     .softButtonStyle(
         RoundedRectangle(cornerRadius: 10),
         mainColor: Color("backgroundColor"),
         textColor: Color.primary,
         lightShadowColor: Color("shadow")
     )
     .padding(.vertical)
     
     
     Button {
         
     } label: {
             Text("Sign In with Apple")
             .frame(maxWidth: .infinity)
             .font(Font.body.bold())
             .overlay(
                 HStack { //now i need you guidline...
                     Spacer()
                     Image(systemName: "apple.logo")
                         .font(.title2)
                         .padding()
                         .foregroundColor(.white)
                         .padding(.trailing, 40)
                 }
             )
     }
     .softButtonStyle(
         RoundedRectangle(cornerRadius: 10),
         mainColor: Color("backgroundColor"),
         textColor: Color.primary,
         lightShadowColor: Color("shadow")
     )
     //.padding(.vertical)
 }
 */

