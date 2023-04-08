//
//  Add_UserView.swift
//  GymTendy
//
//  Created by Muhammad Farid Ullah on 13/02/2023.
//

import SwiftUI
import CoreData
import Firebase
import FirebaseFirestore

struct Add_UserView: View {
    @EnvironmentObject var userAdmin_vm: Authentication_AdminUser_VM
    @State private var name = ""
    @State private var serialNo = ""
    @State private var isShowingImagePciker = false
    @Environment(\.dismiss) var dismiss
    //@Environment(\.managedObjectContext) var moc
    @State var image: UIImage?
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    
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

                    
                    TextField("Enter your name", text: $name)
                    TextField("Enter your serial number", text: $serialNo)
                    
                    Button("Save") {
                        //moc.save not work here..
//                        if let wrappedImage = image {
//                            user_vm.addUser(name: name, serialNo: serialNo, profileImageURL: wrappedImage)
//                            //user_vm.fetchUsers()
//                        }
                        
                        //print(user_vm.currentUser_email)//okay
                        
                        if let wrappedImage = image {
                            if let imageData = wrappedImage.jpegData(compressionQuality: 0.5) {
                                //guard let uiImage = UIImage(data: imageData) else { return }
                                userAdmin_vm.saveImage(imageName: "imageName", image: wrappedImage)
                                userAdmin_vm.addUser(name: name, serialNo: serialNo, profileUIimage: imageData)
                                userAdmin_vm.getUsers()
                            } else {
                                // handle error if image data could not be created
                            }
                        }
                        
                        userAdmin_vm.progressBar_rolling = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            //user_vm.fetchUsers()//
                            self.dismiss()
                        }
                    }
                }
                .textFieldStyle(.roundedBorder)
                .padding()
                .navigationTitle("Add new user")
                .sheet(isPresented: $isShowingImagePciker) {
                    ImagePicker2(image: $image)
                    //.environmentObject(user_vm.moc) //try this as well
                }
                
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
}

//struct Add_UserView_Previews: PreviewProvider {
//    static var previews: some View {
//        Add_UserView()
//    }
//}


/*
 struct Add_UserView: View {
     @EnvironmentObject var user_vm: User_VM
     @State private var name = ""
     @State private var serialNo = ""
     @State private var isShowingImagePciker = false
     @Environment(\.dismiss) var dismiss
     //@Environment(\.managedObjectContext) var moc
     //@State var image: UIImage?
     @State var image: Data = .init(count: 0)
     
     var body: some View {
         NavigationView {
             VStack {
                 
                 if image.count != 0 {
                     Button {
                         isShowingImagePciker = true
                     } label: {
                          Image(uiImage: UIImage(data: image)!)
                             .frame(width: 50, height: 50)
                             .clipShape(Circle())
                     }
                 } else {
                     Button {
                         isShowingImagePciker = true
                     } label: {
                          Image(systemName: "phot.fill")
                             .frame(width: 50, height: 50)
                             .clipShape(Circle())
                             .overlay {
                                 Circle()
                                     .stroke(.red, lineWidth: 2)
                             }
                     }
                 }
                 
 //                Button {
 //                    isShowingImagePciker = true
 //                } label: {
 //                    VStack {
 //                        if let image = self.image {
 //                            Image(uiImage: image)
 //                                .resizable()
 //                                .scaledToFill()
 //
 //                        } else {
 //                            Image(systemName: "person.fill")
 //                                .font(.system(size: 60))
 //                                .foregroundColor(.primary)
 //                        }
 //                    }
 //                    .frame(width: 100, height: 100)
 //                    .clipShape(Circle())
 //                    .overlay(
 //                        Circle()
 //                            .stroke(.black, lineWidth: 2)
 //                    )
 //                }
 //                .padding(.horizontal)

                 
                 TextField("Enter your name", text: $name)
                 TextField("Enter your serial number", text: $serialNo)
                 
                 Button("Save") {
                     //moc.save not work here..
 //                    if let wrappedImage = image {
 //                        user_vm.addUser(name: name, serialNo: serialNo, profileImage: wrappedImage)
 //                        //user_vm.fetchUsers()
 //                    }
                     
                     if image.count != 0 {
                         user_vm.addUser(name: name, serialNo: serialNo, profileImage: image)
                         self.user_vm.newMessage = "addUser func is called"
                     }
                     
                     self.dismiss()
                 }
             }
             .textFieldStyle(.roundedBorder)
             .padding()
             .navigationTitle("Add new user")
             .sheet(isPresented: $isShowingImagePciker) {
                 ImagePicker(show: $isShowingImagePciker, image: $image)
                 //.environmentObject(user_vm.moc) //try this as well
             }
         }
     }
 }
 */
