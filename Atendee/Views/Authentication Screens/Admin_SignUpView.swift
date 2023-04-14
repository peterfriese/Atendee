//
//  SignUp_View.swift
//  GymTendy
//
//  Created by Muhammad Farid Ullah on 05/02/2023.
//

import SwiftUI
import FirebaseAuth
import SwiftfulRouting

struct Admin_SignUpView: View {
    @EnvironmentObject var userAdmin_vm: Authentication_AdminUser_VM
    
    @State private var image: UIImage?
    @State private var isShowingImagePciker = false
    let router: AnyRouter
    let roundedCornerButtonColor = Color("roundedLineColor").opacity(0.3)
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Spacer()
//                    HStack {
//                        Spacer()
//                        ReUsable_Logo(width: 100)
//                        Spacer()
//                    }
                    
                    
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
                                        .font(.system(size: 70))
                                        .foregroundColor(.primary)
                                }
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(roundedCornerButtonColor, lineWidth: 1.7)
                            )
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    
                    
                    ReUsable_TextFeild(imageName: "person.fill", title: "Enter your Name", text: $userAdmin_vm.name, borderColor: roundedCornerButtonColor)//.padding(.vertical)
                    
                    //textfeilds
                    ReUsable_TextFeild(imageName: "envelope.fill", title: "Enter your email", text: $userAdmin_vm.email, borderColor: roundedCornerButtonColor).padding(.vertical)
                    
                    ReUsable_TextFeild(imageName: "lock.fill", title: "Enter your password", text: $userAdmin_vm.password, borderColor: roundedCornerButtonColor)
                    
                    Text(userAdmin_vm.error_Message)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                    
                    ReUsable_Button(title: "Register", buttonBackgroundColor: Color("softbutton_Color")) {
                        if let wrappedImage = image {
                            if let imageData = wrappedImage.jpegData(compressionQuality: 0.5) {
                                userAdmin_vm.validateEmail_Password_adminRegister(name: userAdmin_vm.name, email: userAdmin_vm.email, password: userAdmin_vm.password, profileImage: imageData)
                            }
                            //MARK: show password if face lock is done.
                        }
                    }
                    
                    
                    
                    HStack {
                        Spacer()
                        Text("Already have an account?")
                        Button {
                            router.dismissScreen()
                        } label: {
                            Text("Login")
                        }
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
                } else {
                    //Text("Nothing")
                }
            }
        }
        .sheet(isPresented: $isShowingImagePciker) {
            ImagePicker2(image: $image)
        }
        .toolbarRole(.editor)
    }
}

struct Admin_SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        RouterView { router in
            Admin_SignUpView(router: router)
                .environmentObject(Authentication_AdminUser_VM())
        }
    }
}
