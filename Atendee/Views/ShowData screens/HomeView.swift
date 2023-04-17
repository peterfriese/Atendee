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
                ScrollView {
                    VStack(spacing: 0) {
                        Text(userAdmin_vm.error_Message)
                            .foregroundColor(.red)
                        
                        Text(userAdmin_vm.newMessage)
                            .foregroundColor(.red)
                        
                        Button("Check FM Users") {
                            userData_vm.getUsers()
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        .foregroundColor(.green)
                        
                        Button("Delete Users!") {
                            //userData_vm.deletFM_Users2()
                            userData_vm.deleteUsers()
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        .foregroundColor(.red)
                        
                        ForEach(filteredList) { user in
                            HStack {
                                if let imageURL = user.profileUIimage {
                                    WebImage(url: imageURL)
                                        .resizable()
                                        .scaledToFit()
                                        
                                        .clipShape(Circle())
                                        .frame(width: 60, height: 60)
                                        .shadow(radius: 5)
                                }
                                
                                VStack {
                                    Text(user.name)
                                    Text(user.id)
                                }
                                Text(user.serialNo)
                                Text(user.userAdding_date, formatter: dateFormatter)
                            }
                        }
                        //.onDelete(perform: userData_vm.deleteUsers)
                    }
                    .navigationTitle("Users")
                    //.navigationBarTitleDisplayMode(.inline)
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
                }
            }
        }
        //MARK: i want to fetch when the admin is correctly authenticated and signing in.
        .onAppear {
            print("here is a user email from homeView: \(userAdmin_vm.currentUser_email)")
            userData_vm.fetchUsers2()
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
