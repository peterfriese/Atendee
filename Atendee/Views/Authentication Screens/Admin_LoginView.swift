
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

struct Admin_LoginView: View {
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
        //.navigationBarBackButtonHidden(true)
        .toolbarRole(.editor)
    }
    
    var loginView: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                
                HStack {
                    Spacer()
                    ReUsable_Logo(width: 270)
                    Spacer()
                }
                
                Text("Admin Login")
                    .font(.title.bold())
                    .padding(.top)
                    .padding(.top)
                
                
                //MARK: The Textfields.
                //textfeilds
                ReUsable_TextFeild(imageName: "envelope.fill", title: "Enter your email here...", text: $userAdmin_vm.email, borderColor: .white.opacity(0.5))
                    .padding(.vertical)
                
                ReUsable_TextFeild(imageName: "lock.fill", title: "Enter your password here...", text: $userAdmin_vm.password, borderColor: .white.opacity(0.5))
                    //.padding(.vertical)
                
                //MARK: forgot button.
                HStack {
                    Text(userAdmin_vm.error_Message)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                    Spacer()
                    Text("Forgot password")
                        .font(.subheadline)
                        .padding(.vertical)
                }
                
                
                //MARK: login button.
                
                ReUsable_Button(
                    title: "Login",
                    buttonBackgroundColor:
                        userAdmin_vm.email.isEmpty || userAdmin_vm.password.isEmpty ?
                        Color("softbutton_Color").opacity(0.4) :
                        Color("softbutton_Color")) {
                        userAdmin_vm.validateEmail_Password_adminLogin()
                }
                .padding(.top)
                .disabled(userAdmin_vm.email.isEmpty || userAdmin_vm.password.isEmpty)
                
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
                        
                        Sign_inWith_Button(title: "Sign In with", image: "apple.logo") {
                        }
                    }
                }

                
                //MARK: don't have an account button.
                HStack {
                    Spacer()
                    Text("Don't have an account?")
                    Button {
                        router.showScreen(.push) { router in
                            Admin_SignUpView(router: router)
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
        
    }
}

struct Admin_LoginView_Previews: PreviewProvider {
    static var previews: some View {
        RouterView { router in
            Admin_LoginView(router: router)
                .environmentObject(Authentication_AdminUser_VM())
        }
    }
}
