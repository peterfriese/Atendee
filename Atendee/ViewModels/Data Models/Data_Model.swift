////
////  Data_Model.swift
////  Atendee
////
////  Created by Muhammad Farid Ullah on 03/04/2023.
////
//
//import Foundation
//import SwiftUI
//import Firebase
//import FirebaseFirestore
//import GoogleSignIn
//import FirebaseStorage
//
////✅
////extension homeView {
//    @MainActor class UserData_VM: ObservableObject {
////        let fireStore = FirebaseManager()
////        let adminUser_vm = Authentication_AdminUser_VM()
////        
////        @Published var currentUser_email = ""
////        @Published var error_Message = ""
////        @Published var currentUser_uid = ""
////        @Published var progressBar_rolling = false
////        @Published var users: [User] = []
////        @Published var admin_profileImage: UIImage? = nil
////        
////        //add user - no worries of internet connection.
////         func addUser(name: String, serialNo: String, profileUIimage: Data) {
////             //guard let uid = Auth.auth().currentUser?.uid else { return }
////
////             guard let currentuser = Auth.auth().currentUser else {
////                 print("There is no user")
////                 return
////             }
////
////             print("The current user is: \(currentuser)")
////
////
////             let storageRef = Storage.storage().reference(withPath: serialNo)
////
////    //         guard let imageData = profileUIimage.jpegData(compressionQuality: 0.5) else {
////    //             self.error_Message = "Error converting image to data"
////    //             self.progressBar_rolling = false
////    //             return
////    //         }
////
////    //         guard let uiImageData = profileUIimage.jpegData(compressionQuality: 0.5) else {
////    //             self.error_Message = "Error converting image to data"
////    //             self.progressBar_rolling = false
////    //             return
////    //         }
////
////
////
////             storageRef.putData(profileUIimage, metadata: nil) { metaData, error in
////                 print("The currentUser_email inside: \(self.currentUser_email)")
////                 print(self.currentUser_email)
////                 if let error = error {
////                     self.error_Message = "Error uploading image: \(error.localizedDescription)"
////                     self.progressBar_rolling = false
////                     return
////                 }
////                 
////                 storageRef.downloadURL { result in
////                     switch result {
////                     case .success(let url):
////                         let userData: [String: Any] = [
////                             "name": name,
////                             "serialNo": serialNo,
////                             "profileUIimage": url.absoluteString
////                         ]
////                         self.fireStore.firestore.collection(self.currentUser_email).addDocument(data: userData) { error in
////                             if let error = error {
////                                 self.error_Message = "Error storing user data: \(error.localizedDescription)"
////                                 self.progressBar_rolling = false
////                                 print("error while saving user to firestore")
////                                 return
////                             }
////
////                             self.error_Message = "User data stored successfully"
////                             //self.newMessage = self.currentUser_email
////                             self.progressBar_rolling = false
////                         }
////                         
////                     case .failure(let error):
////                         self.error_Message = "Error retrieving download URL: \(error.localizedDescription)"
////                         self.progressBar_rolling = false
//////                     default:
//////                         print("Nothing done")
////                     }
////                 }
////             }
////         }
////
////        func fetchUsers() {
////            let ref = fireStore.firestore.collection(currentUser_email).addSnapshotListener { snapShot, error in
////                guard let documents = snapShot?.documents else {
////                    print("No documents!")
////                    return
////                }
////
////                self.users = documents.map { query_snapShot -> User in
////                    let data = query_snapShot.data()
////                    let id = query_snapShot.documentID
////
////                    let name = data["name"] as? String ?? ""
////
////                    let serialNo = data["serialNo"] as? String ?? ""
////
////                    let profileUIimage = data["profileUIimage"] as? Data ?? Data()
////
////                    let user = User(id: UUID().uuidString, name: name, serialNo: serialNo, profileUIimage: profileUIimage)
////                    print("User is \(user)")
////                    return user
////                }
////
////                print("Total users: \(self.users)")
////            }
////
////
////
////
////
////    //        ref.getDocuments { snapshot, error in
////    //            guard error == nil else {
////    //                print("There was an error while fetching data: \(error?.localizedDescription ?? "")")
////    //                return
////    //            }
////    //
////    //            if let snapshot = snapshot {
////    //                for doc in snapshot.documents {
////    //                    let id = doc.documentID
////    //                    let data = doc.data()
////    //
////    //                    let name = data["name"] as? String ?? ""
////    //
////    //                    let serialNo = data["serialNo"] as? String ?? ""
////    //
////    //                    let profileImageURL = data["profileImageURL"] as? String ?? "nothing"
////    //
////    //                    let user = User(id: id, name: name, serialNo: serialNo, profileImageURL: profileImageURL)
////    //
////    //
////    //                    self.fileManager.saveData([user], fileName: self.fileName)
////    //                    print("The new user is: \(user)")
////    //                    //self.fileManager.getData(fileName: self.fileName)
////    //
////    //        DispatchQueue.main.async { //try it. for delete, check the app on desktop...GM
////    //            self.users.append(user)
////    //        }
////    //
////    //                }
////    //
////    //                //check here.
////    //
////    //            }
////    //
////    //            //n1. not works
////    //            guard let savedUsers = self.fileManager.getData(fileName: self.fileName) else { return }
////    ////
////    //            print("All users in FM: \(savedUsers)")
////    ////            for savedUser in savedUsers {
////    ////                self.users.append(savedUser)
////    ////            }
////    //        }
////
////            //1. not work here
////        }
////
////        
////        //No need of this. we migh use @AppStorage for this.
////        func fetch_Admins() {
////
////            guard let uid = Auth.auth().currentUser?.uid else { return }
////
////            Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
////                guard let data = snapshot?.data() else {
////                    self.error_Message = "Error fetching user data: \(error?.localizedDescription ?? "unknown error")"
////                    return
////                }
////
////                guard let admin_pp = self.loadImageFromDiskWith(fileName: "\(self.currentUser_uid)") else {
////                    print("fetch_admin else part is called.")
////                    if let admin_image_data = data["profileImageURL"] as? Data, let uiImagee = UIImage(data: admin_image_data) {
////                        //self.profileImageURL = url
////                        //now here we can store the image in the FM. and retrieve for offline use.
////                        print("The uiImagee: is: \(uiImagee)")
////                        self.saveImage(imageName: "iphone", image: uiImagee)
////                        print("User image has been added to FM from FireStore")
////
////                        guard let fireStore_admin_pic = self.loadImageFromDiskWith(fileName: "iphone") else {return }
////
////                        self.admin_profileImage = fireStore_admin_pic
////                        print("Succesfuly displayed")
////                    }
////
////                    return
////                }
////
////                self.admin_profileImage = admin_pp
////            }
////
////        }
////
////        
////        
////        
////        func saveImage(imageName: String, image: UIImage) {
////            guard let documentsDirectory = FileManager
////            .default
////            .urls(for: .documentDirectory, in: .userDomainMask)
////            .first else { return }
////            
////            let fileName = imageName
////            let fileURL = documentsDirectory.appendingPathComponent(fileName)
////            guard let data = image.jpegData(compressionQuality: 1) else { return }
////
////            //Checks if file exists, removes it if so.
////            if FileManager.default.fileExists(atPath: fileURL.path) {
////                do {
////                    try FileManager.default.removeItem(atPath: fileURL.path)
////                    print("Removed old image")
////                } catch let removeError {
////                    print("couldn't remove file at path", removeError)
////                }
////            }
////
////            do {
////                try data.write(to: fileURL)
////                print("Image has been stored in FM...")
////            } catch let error {
////                print("error saving file with error", error)
////            }
////
////        }
////            
////        func loadImageFromDiskWith(fileName: String) -> UIImage? {
////            
////            if fileName.isEmpty {   //fileName.isReallyEmpty
////                return nil
////            }
////            
////            let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
////            
////            let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
////            let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
////            
////            if let dirPath = paths.first {
////                let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
////                let image = UIImage(contentsOfFile: imageUrl.path)
////                return image
////                
////            }
////            
////            return nil
////        }
////        
////        func get_admin_profileImage() {
////            admin_profileImage = loadImageFromDiskWith(fileName: "\(currentUser_uid)")
////            
////        }
//    }
////}
//
//
//
//
//
//
//
///*
// storageRef.downloadURL { url, error in
//     if let error = error {
//         self.error_Message = "Error retrieving download URL: \(error.localizedDescription)"
//         self.progressBar_rolling = false
//         return
//     }
//
//     guard let downloadURL = url else {
//         self.error_Message = "Error retrieving download URL: no URL found"
//         self.progressBar_rolling = false
//         return
//     }
//
//     let userData: [String: Any] = [
//         "name": name,
//         "serialNo": serialNo,
//         "profileUIimage": downloadURL.absoluteString
//     ]
//
//
//     print("The profileUIimage is: \(profileUIimage)")
//
//     //MARK: do not forget to get a unique number or a serial number, to save new instance, otherwise it'll updata only
//     print("The currentUser_email: before || after opening: \(self.currentUser_email)")
//
//     //guard let em
//     self.db.collection(self.currentUser_email).addDocument(data: userData) { error in
//         if let error = error {
//             self.error_Message = "Error storing user data: \(error.localizedDescription)"
//             self.progressBar_rolling = false
//             print("error while saving user to firestore")
//             return
//         }
//
//         self.error_Message = "User data stored successfully"
//         self.newMessage = self.currentUser_email
//         self.progressBar_rolling = false
//     }
//
////                 Firestore.firestore().collection(self.currentUser_email).document(serialNo).setData(userData) { error in
////                     if let error = error {
////                         self.error_Message = "Error storing user data: \(error.localizedDescription)"
////                         self.progressBar_rolling = false
////                         print("error while saving user to firestore")
////                         return
////                     }
////
////                     self.error_Message = "User data stored successfully"
////                     self.progressBar_rolling = false
////                 }
// }
// */
