//
//  Data_Model.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 03/04/2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn
import FirebaseStorage

//✅
//extension homeView {
class UserData_VM: ObservableObject {

@Published var error_Message = "errorMessage"
@Published var progressBar_rolling = false
@Published var users: [User] = []
@Published var admin = Admin(name: "", email: "", password: "", uid: "")

@AppStorage("currentUser_email") var currentUser_email = "Unknow_email"
@AppStorage("current_admin_uid") var current_admin_uid = "Unknow_admin_uid"

init() {
    fetchUsers2()
}

let fireStore = Firestore.firestore()
let fireStorage = Storage.storage()
let fileManager = FileManagerClass()
let userfileName = "userTest1"
let adminfileName = "adminTest1"


    func addUser(name: String, serialNo: String, profileUIimage: Data, userAdding_date: Date, userContact: String) async -> Bool {
        self.progressBar_rolling = true

        // Instead of using the user's email address, you should:
        // 0. import FirebaseFirestoreSwift
        // 1. store *all* user documents in a collection called "users"
        // 2. let Firestore create a unique document ID for you (by calling `.addDocument(from: user)`
        do {
            let storageRef = self.fireStorage.reference(withPath: serialNo)
            let _ = try await storageRef.putDataAsync(profileUIimage)
            let profileImageURL = try await storageRef.downloadURL()

            let  user = User(name: name,
                             serialNo: serialNo,
                             profileUIimage: profileImageURL,
                             userAdding_date: Date(),
                             userContact: userContact) // <-- you should probably also use the user's UID to set the userId field
            let _ = try self.fireStore.collection("users").addDocument(from: user)

            self.error_Message = "User data stored successfully"
            self.progressBar_rolling = false
            return true
        }
        catch {
            self.error_Message = "Error storing user data: \(error.localizedDescription)"
            self.progressBar_rolling = false
            return false
        }
    }

func fetchUsers2() {
    print("Called again")
    //go to the specific collection, and then we put a listener. Local writes in your app will invoke snapshot listeners immediately. When you perform a write, your listeners will be notified with the new data before the data is sent to the backend.
    fireStore.collection(self.currentUser_email).addSnapshotListener { snapShot, error in
        
        //doc exist.
        guard let documents = snapShot?.documents else {
            print("No documents!")
            return
        }
        
        //now transorm the documents into User model.
        self.users = documents.map { query_snapShot -> User in
            
            //go into each doc and read the data.
            let data = query_snapShot.data()
            let id = query_snapShot.documentID
            
            let name = data["name"] as? String ?? ""
            
            let serialNo = data["serialNo"] as? String ?? ""
            
            let profileImageURLString = data["profileUIimage"] as? String ?? ""
            let profileUIimage = URL(string: profileImageURLString) // convert the string to a URL object
            
            let userAdding_date = data["userAdding_date"] as? Date ?? Date()
            
            let userContact = data["userContact"] as? String ?? ""
            
            let user = User(id: id, name: name, serialNo: serialNo, profileUIimage: profileUIimage, userAdding_date: userAdding_date, userContact: userContact)
            print("User is \(user)")
            return user
        }
        
        self.fileManager.saveUsers_toFM(self.users, fileName: self.userfileName)
    }
}

func getUsers() {
    guard let users = fileManager.getUsers_fromFM(fileName: self.userfileName) else { return }
    self.users = users
    print("All FM users are: \(users)")
}


//MARK: We need this, becuase when a user want to logout, the FM Data will be removed.
    func deletFM_Users2() {
        //Dete all those user at that fileName.
        fileManager.delete_FM_Users(fileName: self.userfileName)
        getUsers()
    }

    func deletFM_admin2() {
        //Dete all those user at that fileName.
        fileManager.deleteFM_admin(fileName: self.adminfileName)
    }


func fetch_Admins2() {
    guard let uid = Auth.auth().currentUser?.uid else {
        print("No data with the of the uid")
        return
    }
    
    let docRef = fireStore.collection("admins").document(uid)
    docRef.getDocument { snapshot, error in
        if let error = error {
            print("Error fetching admin data: \(error.localizedDescription)")
            return
        }
        

        guard let data = snapshot?.data() else {
            print("No data available for admin with: \(self.current_admin_uid)")
            return
        }

        let id = snapshot?.documentID ?? UUID().uuidString
        let name = data["name"] as? String ?? ""
        let email = data["email"] as? String ?? ""
        let password = data["password"] as? String ?? ""
        let uid = data["uid"] as? String ?? ""
        let profileImageURLString = data["profileUIimage"] as? String ?? ""
        let profileImageURL = URL(string: profileImageURLString)

        let admin = Admin(id: id, name: name, email: email, password: password, uid: uid, profileUIimage: profileImageURL)
        print("Admin fetched from Firestore: \(admin)")

        self.fileManager.saveAdmin_toFM(admin, fileName: self.adminfileName)
    }
}
    
    
func getAdmin() {
    guard let admin = self.fileManager.getAdmin_fromFM(fileName: self.adminfileName) else {
        print("No admin Data")
        return
    }
    self.admin = admin
    print(admin)
}


//delete all users
func deleteUsers() {
    fireStore.collection(self.currentUser_email).getDocuments { snapShot, error in
        if let error = error {
            print("Error deleting all users:\(error)")
        }
        
        for doc in snapShot?.documents ?? [] {
            doc.reference.delete()
        }
        
        //MARK: fetchUpdated users.
    }
}

//delete a sinlge user by the id
func delete_User(at indexSet: IndexSet) {
    indexSet.forEach { index in
        let user = users[index]
        //delete from the fireStore
        fireStore.collection(self.currentUser_email)
            .document(user.id)
            .delete() { error in
                if let error = error {
                    print("Can not be deleted! \(error.localizedDescription)")
                } else {
                    self.fetchUsers2()
                }
            }
    }
}
    
}
//}
