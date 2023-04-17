//
//  HomeView.swift
//  GymTendy
//
//  Created by Muhammad Farid Ullah on 29/01/2023.

import SwiftUI
import CoreData
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI
import FirebaseStorage

struct HomeView: View {
    @EnvironmentObject var userAdmin_vm: Authentication_AdminUser_VM
    @EnvironmentObject var userData_vm: UserData_VM
    @State private var isShowingadd_view = false
    
    let fileManager = FileManagerClass()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        NavigationView {
            
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                VStack {
                    Button("Delete Users!") {
                        //userData_vm.deletFM_Users2()
                        userData_vm.deleteUsers()
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.red)
                    
                    List {
                        ForEach(userData_vm.users) { user in
                            HStack {
                                if let imageURL = user.profileUIimage {
                                    WebImage(url: imageURL)
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .frame(width: 60, height: 60)
                                        .shadow(radius: 5)
                                }
                                Text(user.name)
                                Text(user.id)
                            }
                        }
                        .onDelete(perform: userData_vm.delete_User)
                    }
                }
                .tint(Color("backgroundColor"))
                .navigationTitle("Users")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add") {
                            isShowingadd_view = true
                            let currentUser = Auth.auth().currentUser?.uid ?? "no uid"
                            print("Here is the current logged in user: \(currentUser)")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("SignOut") {
                            userAdmin_vm.currentUser_email = "UnknownEmail" //added
                            //userAdmin_vm.users = []
                            //deleteAllObjects()
                            userAdmin_vm.admin_signOut()
                            //userAdmin_vm.isUserLoggedIn = false
                            userAdmin_vm.signedIn = false
                        }
                        .tint(.red)
                    }
                }
                .sheet(isPresented: $isShowingadd_view, onDismiss: nil) {
                    Add_UserView()
                }
                .onAppear {
                    userData_vm.fetchUsers2()
                }
            }
        }
        
    }

    var filteredList: [User] {
        return userData_vm.users.sorted { $0.name < $1.name }
    }
    
//    func deleteUser(index: IndexSet) {
//        return userData_vm.deleteUser(uid: index)
//    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Authentication_AdminUser_VM())
            .environmentObject(UserData_VM())
    }
}
