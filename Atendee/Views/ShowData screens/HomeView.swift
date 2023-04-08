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
    @State private var isShowingadd_view = false
    @Environment(\.managedObjectContext) var moc

    @State var profileImage: Data = .init(count: 0)
    
    let fileManager = FileManagerClass()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    Text(userAdmin_vm.error_Message)
                        .foregroundColor(.red)
                    
                    Text(userAdmin_vm.newMessage)
                        .foregroundColor(.red)
                    Button("Check all FM users") {
                        userAdmin_vm.getUsers()
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    
                    Button("Fetch Users and save to FM") {
                        userAdmin_vm.fetchUsers2()
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    
                    ForEach(userAdmin_vm.users) { user in
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
                            Text(user.serialNo) 
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
        }
            
    }

//    var filteredList: [User] {
//        return userAdmin_vm.users.sorted { $0.name < $1.name }
//    }
    
//    func deleteAllObjects() {
//        for user in user_vm.users {
//            moc.delete(user)
//            print("All users are deleting...")
//        }
//        try? moc.save()
//    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}


/*
 if let imageData = user.profileImage, let image = UIImage(data: imageData) {
     // Use WebImage to load the profile image asynchronously
     Image(uiImage: image)
     //Image(uiImage: UIImage(data: user.profileImage ?? profileImage)!)
         .resizable()
         .scaledToFill()
         .frame(width: 30, height: 30)
         .clipShape(Circle())
         .overlay(Circle().stroke(Color.gray, lineWidth: 2))
         .shadow(radius: 10)
     
 } else {
     // Show a placeholder image if the profile image URL is not available
     Image(systemName: "person.crop.circle")
         .resizable()
         .scaledToFill()
         .frame(width: 75, height: 75)
         .clipShape(Circle())
         .overlay(Circle().stroke(Color.gray, lineWidth: 2))
         .shadow(radius: 10)
 }
 */


/*
 struct HomeView: View {
     @EnvironmentObject var user_vm: User_VM
     @State private var isShowingadd_view = false
     @Environment(\.managedObjectContext) var moc
     
 //    @FetchRequest(entity: User_CoreDM.entity(), sortDescriptors: []) var cachedUsers: FetchedResults<User_CoreDM>
     //let currentUser = Auth.auth().currentUser?.email ?? "UnknowUserHomeView"

     @State var profileImage: Data = .init(count: 0)
     
     @State var image : Data = .init(count: 0)
     
     
     var body: some View {
         NavigationView {
             VStack(spacing: 0) {
                 Text(user_vm.newMessage)
                 VStack {
                     ForEach(filteredList, id: \.serialNo) { user in
                         HStack { //work here.........MARK:
                             if let imageData = user.profileImage ?? self.image,
                                let uiImage = UIImage(data: imageData) {
                                 Image(uiImage: uiImage)
                                     .frame(width: 50, height: 50)
                                     .clipShape(Circle())
                             } else {
                                 // Handle the case where image data is nil
                                 Image(systemName: "person.fill")
                                     .frame(width: 50, height: 50)
                                     .clipShape(Circle())
                                 
                             }
                                 
                             
                             Text(user.wrappedName)
                             Text(user.wrappedSerialNo)
                             
                         }
                     }
                 }
                 .onAppear {
                     if user_vm.users.isEmpty {  //updated with cachedUsers.isempty()
                         let db = Firestore.firestore()
                         let ref = db.collection(user_vm.currentUser_email)
                         ref.getDocuments { snapshot, error in
                             guard error == nil else {
                                 print("There was an error while fetching data: \(error?.localizedDescription ?? "")")
                                 return
                             }
                             
                             if let snapshot = snapshot {
                                 for doc in snapshot.documents {
                                     let data = doc.data()
                                     let newUser = User_CoreDM(context: self.moc)
                                     
                                     //updated
                                     newUser.name = data["name"] as? String ?? ""
                                     newUser.serialNo = data["serialNo"] as? String ?? "1"
                                     
                                     //MARK: work here...
 //                                    if let profileImageURLString = data["profileImage"] as? String,
 //                                       let profileImageURL = URL(string: profileImageURLString) {
 //                                        self.user_vm.downloadImage(from: profileImageURL) { image in
 //                                            if let image = image {
 //                                                newUser.profileImage = image.pngData()
 //                                            }
 //                                        }
 //                                    }
                                 }
                             }
                         }
                     }
                 }
                 .navigationTitle("Atendees")
                 //.navigationBarTitleDisplayMode(.inline)
                 .toolbar {
                     ToolbarItem(placement: .navigationBarTrailing) {
                         Button("Add") {
                             isShowingadd_view = true
                         }
                     }
                     ToolbarItem(placement: .navigationBarLeading) {
                         Button("SignOut") {
                             user_vm.currentUser_email = "UnknownUser" //added
                             user_vm.users = []
                             deleteAllObjects()
                             user_vm.signOut()
                             user_vm.isUserLoggedIn = false
                         }
                         .tint(.red)
                     }
                 }
                 .sheet(isPresented: $isShowingadd_view, onDismiss: nil) {
                     Add_UserView()
                         .environment(\.managedObjectContext, moc)
                 }
             }
         }
             
     }

     var filteredList: [User_CoreDM] {
         return user_vm.users.sorted { $0.wrappedName < $1.wrappedName }
     }
     
     func deleteAllObjects() {
         for user in user_vm.users {
             moc.delete(user)
             print("All users are deleting...")
         }
         try? moc.save()
     }
 }
 */

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}


/*
 if let imageData = user.profileImage, let image = UIImage(data: imageData) {
     // Use WebImage to load the profile image asynchronously
     Image(uiImage: image)
     //Image(uiImage: UIImage(data: user.profileImage ?? profileImage)!)
         .resizable()
         .scaledToFill()
         .frame(width: 30, height: 30)
         .clipShape(Circle())
         .overlay(Circle().stroke(Color.gray, lineWidth: 2))
         .shadow(radius: 10)
     
 } else {
     // Show a placeholder image if the profile image URL is not available
     Image(systemName: "person.crop.circle")
         .resizable()
         .scaledToFill()
         .frame(width: 75, height: 75)
         .clipShape(Circle())
         .overlay(Circle().stroke(Color.gray, lineWidth: 2))
         .shadow(radius: 10)
 }
 */


/*
 struct HomeView: View {
     @EnvironmentObject var user_vm: User_VM
     @State private var isShowingadd_view = false
     @Environment(\.managedObjectContext) var moc
     
 //    @FetchRequest(entity: User_CoreDM.entity(), sortDescriptors: []) var cachedUsers: FetchedResults<User_CoreDM>
     //let currentUser = Auth.auth().currentUser?.email ?? "UnknowUserHomeView"

     @State var profileImage: Data = .init(count: 0)
     
     @State var image : Data = .init(count: 0)
     
     
     var body: some View {
         NavigationView {
             VStack(spacing: 0) {
                 Text(user_vm.newMessage)
                 VStack {
                     ForEach(filteredList, id: \.serialNo) { user in
                         HStack { //work here.........MARK:
                             if let imageData = user.profileImage ?? self.image,
                                let uiImage = UIImage(data: imageData) {
                                 Image(uiImage: uiImage)
                                     .frame(width: 50, height: 50)
                                     .clipShape(Circle())
                             } else {
                                 // Handle the case where image data is nil
                                 Image(systemName: "person.fill")
                                     .frame(width: 50, height: 50)
                                     .clipShape(Circle())
                                 
                             }
                                 
                             
                             Text(user.wrappedName)
                             Text(user.wrappedSerialNo)
                             
                         }
                     }
                 }
                 .onAppear {
                     if user_vm.users.isEmpty {  //updated with cachedUsers.isempty()
                         let db = Firestore.firestore()
                         let ref = db.collection(user_vm.currentUser_email)
                         ref.getDocuments { snapshot, error in
                             guard error == nil else {
                                 print("There was an error while fetching data: \(error?.localizedDescription ?? "")")
                                 return
                             }
                             
                             if let snapshot = snapshot {
                                 for doc in snapshot.documents {
                                     let data = doc.data()
                                     let newUser = User_CoreDM(context: self.moc)
                                     
                                     //updated
                                     newUser.name = data["name"] as? String ?? ""
                                     newUser.serialNo = data["serialNo"] as? String ?? "1"
                                     
                                     //MARK: work here...
 //                                    if let profileImageURLString = data["profileImage"] as? String,
 //                                       let profileImageURL = URL(string: profileImageURLString) {
 //                                        self.user_vm.downloadImage(from: profileImageURL) { image in
 //                                            if let image = image {
 //                                                newUser.profileImage = image.pngData()
 //                                            }
 //                                        }
 //                                    }
                                 }
                             }
                         }
                     }
                 }
                 .navigationTitle("Atendees")
                 //.navigationBarTitleDisplayMode(.inline)
                 .toolbar {
                     ToolbarItem(placement: .navigationBarTrailing) {
                         Button("Add") {
                             isShowingadd_view = true
                         }
                     }
                     ToolbarItem(placement: .navigationBarLeading) {
                         Button("SignOut") {
                             user_vm.currentUser_email = "UnknownUser" //added
                             user_vm.users = []
                             deleteAllObjects()
                             user_vm.signOut()
                             user_vm.isUserLoggedIn = false
                         }
                         .tint(.red)
                     }
                 }
                 .sheet(isPresented: $isShowingadd_view, onDismiss: nil) {
                     Add_UserView()
                         .environment(\.managedObjectContext, moc)
                 }
             }
         }
             
     }

     var filteredList: [User_CoreDM] {
         return user_vm.users.sorted { $0.wrappedName < $1.wrappedName }
     }
     
     func deleteAllObjects() {
         for user in user_vm.users {
             moc.delete(user)
             print("All users are deleting...")
         }
         try? moc.save()
     }
 }
 
 
 
 
 
 
 
 
 
 
//                    .onAppear {
//                        user_vm.fetchUsersFm()
////                        if user_vm.users.isEmpty {
////                            let db = Firestore.firestore()
////                            let ref = db.collection(user_vm.currentUser_email)
////                            ref.getDocuments { snapshot, error in
////                                guard error == nil else {
////                                    print("There was an error while fetching data: \(error?.localizedDescription ?? "")")
////                                    return
////                                }
////
////                                if let snapshot = snapshot {
////                                    for doc in snapshot.documents {
////                                        let id = doc.documentID
////                                        let name = doc.get("name") as? String ?? ""
////                                        let serialNo = doc.get("serialNo") as? String ?? ""
////                                        let profileImageURL = doc.get("profileImageURL") as? String ?? "nothing"
////                                        let user = User(id: id, name: name, serialNo: serialNo, profileImageURL: profileImageURL)
////
////                                        self.fileManager.saveData([user], fileName: user_vm.fileName)
////
////                                        //self.users.append(user)
////                                    }
////                                }
////
////                                // Do something with the retrieved user objects here
////                                //print("Users loaded: \(self.users)")
////                            }
////                        }
//                    }
 
 */
