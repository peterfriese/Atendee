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
                        
                        Button("Check FM Admin") {
                            userData_vm.getAdmin()
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        
                        Button("Fetch admin and save to FM") {
                            userData_vm.fetch_Admins2()
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        
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
                                    Text(user.userContact)
                                }
                                Text(user.serialNo)
                                Text(user.userAdding_date, formatter: dateFormatter)
                            }
                        }
                    }
                    .onAppear() {
                        print("here is a user email from homeView: \(userAdmin_vm.currentUser_email)")
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
        .onAppear {
            userData_vm.fetchUsers2()
        }
            
    }

    var filteredList: [User] {
        return userData_vm.users.sorted { $0.name < $1.name }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Authentication_AdminUser_VM())
            .environmentObject(UserData_VM())
    }
}
