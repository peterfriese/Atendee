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
import GoogleSignIn
import FirebaseStorage

//✅
//extension homeView {
@MainActor class UserData_VM: ObservableObject {
    
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
    let fileName = "testing_09"
    
    
    func addUser(name: String, serialNo: String, profileUIimage: Data, userAdding_date: Date, userContact: String, completion: @escaping (Bool) -> ()) {
        self.progressBar_rolling = true
        
        //we need set the path for the Firebase Storage reference, which means that it needs to be unique to ensure that each file uploaded to Firebase Storage has a unique path.
        let storageRef = self.fireStorage.reference(withPath: serialNo)
        
        
        //upload the user's profile image to Firebase Storage.
        storageRef.putData(profileUIimage, metadata: nil) { metaData, error in
            if let error = error {
                self.error_Message = "Error uploading image: \(error.localizedDescription)"
                self.progressBar_rolling = false
                completion(false)
                return
            }//error during the uploading.
            
            //as we have uploaded the user profileImage, now we need to download its url so that we add this profileImage to the document as well with the name and serialNo.
            storageRef.downloadURL { result in
                switch result {
                case .success(let url):
                    let userData: [String: Any] = [
                        "name": name,
                        "serialNo": serialNo,
                        "profileUIimage": url.absoluteString,
                        "userAdding_date": userAdding_date,
                        "userContact": userContact
                    ]
                    
                    self.fireStore.collection(self.currentUser_email).addDocument(data: userData) { error in
                        if let error = error {
                            self.error_Message = "Error storing user data: \(error.localizedDescription)"
                            self.progressBar_rolling = false
                            completion(false)
                            print("error while saving user to firestore")
                            return
                        }
                        
                        self.error_Message = "User data stored successfully"
                        //self.newMessage = self.currentUser_email
                        self.progressBar_rolling = false
                        DispatchQueue.main.async {
                            self.getUsers()
                        }
                        
                        completion(true)
                    }
                    
                case .failure(let error):
                    self.error_Message = "Error retrieving download URL: \(error.localizedDescription)"
                    self.progressBar_rolling = false
                    completion(false)
                }
            }
        }
    }
    
    func fetchUsers2() {
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
            
            self.fileManager.saveUsers_toFM(self.users, fileName: "test2")
        }
    }
    func getUsers() {
        guard let users = fileManager.getUsers_fromFM(fileName: "test2") else { return }
        self.users = users
        print("All FM users are: \(users)")
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

            self.fileManager.saveAdmin_toFM(admin, fileName: "admin")
        }
    }
    
    func getAdmin() {
        guard let admin = self.fileManager.getAdmin_fromFM(fileName: "admin") else {
            print("No admin Data")
            return
        }
        self.admin = admin
        print(admin)
    }
}
//}
