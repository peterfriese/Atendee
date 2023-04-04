
//  Admin_Profile_View.swift
//  GymTendy
//
//  Created by Muhammad Farid Ullah on 21/03/2023.
//

import SwiftUI
import SDWebImageSwiftUI


struct Admin_Profile_View: View {
    @EnvironmentObject var userAdmin_vm: Authentication_AdminUser_VM
    @State private var isShowingImagePciker = false
    @State private var image: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                if let url = userAdmin_vm.profileImageURL {
                    // Use WebImage to load the profile image asynchronously
                    WebImage(url: url)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .shadow(radius: 10)
                    
                } else if let image = userAdmin_vm.admin_profileImage {
                    // Show a placeholder image if the profile image URL is not available
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .shadow(radius: 10)
                }
                
                List {
                    Text(userAdmin_vm.currentUser_email)
                    Text(userAdmin_vm.currentUser_uid)
                }
                
                
            }
            .sheet(isPresented: $isShowingImagePciker) {
                ImagePicker2(image: $image)
            }
            .navigationTitle("Admin Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                userAdmin_vm.fetch_Admins()
            }
        }
    }
}

struct Admin_Profile_View_Previews: PreviewProvider {
    static var previews: some View {
        Admin_Profile_View()
    }
}
