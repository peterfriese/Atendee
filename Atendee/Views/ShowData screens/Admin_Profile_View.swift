
//  Admin_Profile_View.swift
//  GymTendy
//
//  Created by Muhammad Farid Ullah on 21/03/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct Admin_Profile_View: View {
    @EnvironmentObject var userAdmin_vm: Authentication_AdminUser_VM
    @EnvironmentObject var userData_vm: UserData_VM
    
    @State private var isShowingImagePciker = false
    @State private var image: UIImage?
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                VStack {
                    Text(userData_vm.admin.name)
                    Text(userData_vm.admin.email)
                    Text(userData_vm.admin.password)
                    
                    if let imageurl = userData_vm.admin.profileUIimage {
                        WebImage(url: imageurl)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .shadow(radius: 10)
                    }
                    
                    
                }
                .sheet(isPresented: $isShowingImagePciker) {
                    ImagePicker2(image: $image)
                }
                .navigationTitle("Admin Profile")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    userData_vm.getAdmin()
                }
            }
        }
    }
}

struct Admin_Profile_View_Previews: PreviewProvider {
    static var previews: some View {
        Admin_Profile_View()
            .environmentObject(Authentication_AdminUser_VM())
            .environmentObject(UserData_VM())
    }
}
