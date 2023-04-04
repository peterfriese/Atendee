//
//  SignUp_View.swift
//  GymTendy
//
//  Created by Muhammad Farid Ullah on 05/02/2023.
//

import SwiftUI
import FirebaseAuth
import SwiftfulRouting

struct SignUp_View: View {
    @EnvironmentObject var userAdmin_vm: Authentication_AdminUser_VM
    
    @State private var image: UIImage?
    @State private var isShowingImagePciker = false
    let router: AnyRouter
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    
                    HStack(alignment: .top) {
                        ReUsable_BackButton {
                            router.dismissScreen()
                        }
                        
                        ReUsable_Logo()
                            .padding(.leading, 20)
                        
                    }.padding(.top, 7)
                    Spacer()
                    
                    
                    
                    //Image picker.
                    HStack {
                        Text("Sign Up")
                            .font(.title.bold())
                            .padding(.top)
                            .padding(.top)
                        
                        Button {
                            isShowingImagePciker = true
                        } label: {
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                    
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(.primary)
                                }
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(.black, lineWidth: 2)
                            )
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    
                    
                    //textfeilds
                    ReUsable_TextFeild(imageName: "envelope.fill", title: "Enter your email here...", email: $userAdmin_vm.email).padding(.vertical)
                    
                    ReUsable_TextFeild(imageName: "lock.fill", title: "Enter your password here...", email: $userAdmin_vm.password)//.padding(.vertical)
                    
                    Text(userAdmin_vm.error_Message)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                    
                    ReUsable_Button(title: "Register", buttonBackgroundColor: Color("softbutton_Color")) {
                        
                        if let wrappedImage = image {
                            userAdmin_vm.validateEmail_Password_adminRegister(image: wrappedImage)
                        }
                        userAdmin_vm.progressBar_rolling = false
                        
                    }
                    
                    
                    
                    HStack {
                        Spacer()
                        Text("Already have an account?")
                        Button {
                            router.showScreen(.push) { router in
                                Login_View(router: router)
                            }
                        } label: {
                            Text("Login")
                        }
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding(.horizontal)
                
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
            .sheet(isPresented: $isShowingImagePciker) {
                ImagePicker2(image: $image)
            }
            
        }
        .navigationBarBackButtonHidden(true)
    }
    

}
