//
//  File.swift
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
//extension Admin_Login {
@MainActor class Authentication_AdminUser_VM: ObservableObject {
    
    var isUserLoggedIn = false
    @Published var email = ""
    @Published var password = ""
    
    @Published var error_Message = "errorMessage"
    @Published var newMessage = "New message"
    @Published var progressBar_rolling = false
    @Published var users: [User] = []
    //@Published var users = file
    
    @AppStorage("currentUser_email") var currentUser_email = "Unknow_email"
    @AppStorage("currentUser_uid") var currentUser_uid = "Unknow_uid"
    
    init() {
        fetchUsers2()
    }
    
    let fireStore = Firestore.firestore()
    let fireStorage = Storage.storage()
    
    let fileManager = FileManagerClass()
    let fileName = "testing_09"
    
    @Published var profileImageURL: URL?
    @Published var profileImage: URL?
    
    @Published var admin_profileImage: UIImage? = nil
    
    @Published var signedIn = false
    
    var isUserSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    
    func addUser(name: String, serialNo: String, profileUIimage: Data) {
        //we need set the path for the Firebase Storage reference, which means that it needs to be unique to ensure that each file uploaded to Firebase Storage has a unique path.
        let storageRef = self.fireStorage.reference(withPath: serialNo)
        
        
        //upload the user's profile image to Firebase Storage.
        storageRef.putData(profileUIimage, metadata: nil) { metaData, error in
            if let error = error {
                self.error_Message = "Error uploading image: \(error.localizedDescription)"
                self.progressBar_rolling = false
                return
            }//error during the uploading.
            
            //as we have uploaded the user profileImage, now we need to download its url so that we add this profileImage to the document as well with the name and serialNo.
            storageRef.downloadURL { result in
                switch result {
                case .success(let url):
                    let userData: [String: Any] = [
                        "name": name,
                        "serialNo": serialNo,
                        "profileUIimage": url.absoluteString
                    ]
                    
                    self.fireStore.collection(self.currentUser_email).addDocument(data: userData) { error in
                        if let error = error {
                            self.error_Message = "Error storing user data: \(error.localizedDescription)"
                            self.progressBar_rolling = false
                            print("error while saving user to firestore")
                            return
                        }
                        
                        self.error_Message = "User data stored successfully"
                        //self.newMessage = self.currentUser_email
                        self.progressBar_rolling = false
                    }
                    
                case .failure(let error):
                    self.error_Message = "Error retrieving download URL: \(error.localizedDescription)"
                    self.progressBar_rolling = false
                }
            }
        }
    }
    
    func fetchUsers2() {
        //go to the specific collection, and then we put a listener. Local writes in your app will invoke snapshot listeners immediately. When you perform a write, your listeners will be notified with the new data before the data is sent to the backend.
        Firestore.firestore().collection(currentUser_email).addSnapshotListener { snapShot, error in
            
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
                
                let user = User(id: id, name: name, serialNo: serialNo, profileUIimage: profileUIimage)
                print("User is \(user)")
                //self.fileManager.saveData([user], fileName: "test1")
                //print("User: \(user) is added to FM")
                return user
            }
            
            self.fileManager.saveUsers_toFM(self.users, fileName: "test2")
            //                print("Total users: \(self.users)")
            //                for user in self.users {
            //                    print("Single user: \(user)")
            //                    self.fileManager.saveData([user], fileName: "test1")
            //                }
        }
    }
    
    func getUsers() {
        guard let users = fileManager.getUsers_fromFM(fileName: "test2") else { return }
        self.users = users
        print("All FM users are: \(users)")
    }
    
    
    
    
    
    //✅
    //MARK: Admin Authentication.
    func admin_registeration(profileImage: UIImage, completion: @escaping (String) -> Void) {
        self.isUserLoggedIn = false
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                self.progressBar_rolling = false
                return
            }
            
            guard let user = result?.user else {
                self.error_Message = "Error creating user: no user object found"
                self.progressBar_rolling = false
                return
            }
            
            self.currentUser_uid = user.uid
            print("calling the updated uid: \(self.currentUser_uid)")
            
            //guard let u_id = currentUser_uid else { return }
            completion(self.currentUser_uid)
            print("after completion: uid: \(self.currentUser_uid)")
            
            let storageRef = Storage.storage().reference(withPath: user.uid)
            
            guard let imageData = profileImage.jpegData(compressionQuality: 0.5) else {
                self.error_Message = "Error converting image to data"
                self.progressBar_rolling = false
                return
            }
            
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    self.error_Message = "Error uploading image: \(error.localizedDescription)"
                    self.progressBar_rolling = false
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        self.error_Message = "Error retrieving download URL: \(error.localizedDescription)"
                        self.progressBar_rolling = false
                        return
                    }
                    
                    guard let downloadURL = url else {
                        self.error_Message = "Error retrieving download URL: no URL found"
                        self.progressBar_rolling = false
                        return
                    }
                    
                    let userData: [String: Any] = [
                        "email": user.email ?? "unKnownEmail",
                        "profileImageURL": downloadURL.absoluteString
                    ]
                    
                    Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
                        if let error = error {
                            self.error_Message = "Error storing user data: \(error.localizedDescription)"
                            self.progressBar_rolling = false
                            return
                        }
                        
                        self.error_Message = "User data stored successfully"
                        self.progressBar_rolling = false
                    }
                }
            }
        }
        
        self.isUserLoggedIn = false
    }
    
    func validateEmail_Password_adminRegister(image: UIImage) {
        progressBar_rolling = true
        if !email.isEmpty && !password.isEmpty {
            if isValidateEmail() {
                if isValidPassword() {
                    
                    admin_registeration(profileImage: image) { currentUser_uid in
                        //self.current_admin_uid = currentUser_uid
                        print("Admin user id assigned: \(currentUser_uid)")
                        //self.saveImage(imageName: "\(currentUser_uid)", image: image)
                        print("Admin picture saved in FM with the uid: \(currentUser_uid)")
                        //self.error_Message = "Successfully Registered"
                        //self.progressBar_rolling = true
                    }
                    print("Admin picture saved in FM with the uid: \(currentUser_uid)")
                    error_Message = "Sucessfully Registered"
                    
                } else {
                    self.progressBar_rolling = false
                    error_Message = "Wrong Password"
                }
                
            } else {
                self.progressBar_rolling = false
                error_Message = "Wrong email"
            }
        }
        self.progressBar_rolling = false
    }
    
    
    func validateEmail_Password_adminLogin() {
        if !email.isEmpty && !password.isEmpty {
            if isValidateEmail() {
                if isValidPassword() {
                    progressBar_rolling = true
                    admin_Login()
                } else { error_Message = "Wrong Password" }
                
            } else {
                error_Message = "Wrong email"
            }
        }
    }
    //MARK: It is a part of the above func.
    func admin_Login() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if error != nil {
                print("There was an error while login...\(String(describing: error?.localizedDescription))")
                self?.error_Message = String(describing: error?.localizedDescription)
                self?.progressBar_rolling = false
                self?.isUserLoggedIn = false
            }
            
            self?.currentUser_email = Auth.auth().currentUser?.email ?? "UnknownUser_email"
            //updated
            self?.currentUser_uid = Auth.auth().currentUser?.uid ?? "Unknown currentUser_uid"
            //self.fetchUsers()
            self?.progressBar_rolling = false
            //self.isUserLoggedIn = true
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func admin_signInWithGoogle() {
        //get app client id.
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        //sign In method goes here...
        GIDSignIn.sharedInstance.signIn(
            withPresenting: SceneDelegate.rootViewController) { user, error in
                
                if let error = error {
                    self.progressBar_rolling = false
                    print(error.localizedDescription)
                    return
                }
                
                guard
                    let user = user?.user,
                    let idToken = user.idToken else { return }
                
                let accessToken = user.accessToken
                
                self.currentUser_email = user.profile?.email ?? "Unknow_signInwithEmail" // new method to get the email of the user.
                let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
                
                
                Auth.auth().signIn(with: credential) { res, error in
                    if let error = error {
                        self.progressBar_rolling = false
                        print(error.localizedDescription)
                        return
                    }
                    
                    //store the email in the users collection.
                    guard let user = res?.user else { return }
                    self.currentUser_uid = user.uid
                    let userData = ["email": user.email ?? ""]
                    Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
                        if let error = error {
                            self.progressBar_rolling = false
                            print("Error storing user data: \(error.localizedDescription)")
                        } else {
                            print("User data stored successfully")
                        }
                    }
                    //self.fetchUsers()
                    //print(user)
                }
                
                
                //self.progressBar_rolling = false
            }
    }
    
    func admin_signOut() {
        //show progress view after logging out
        do {
            try Auth.auth().signOut()
            self.isUserLoggedIn = false
            print("User logged out successfully")
            
        } catch let error as NSError {
            print("There was an error while signing Out! \(error)")
        }
    }
    
    
    
    
    //MARK: User Authentication.
    func validate_user(email: String, secretCode: String, completion: @escaping (Bool) ->() ) {
        let email = email // email
        
        // Query the "users" collection for a document with the specified email address
        Firestore.firestore().collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                completion(false)
            } else if let snapshot = querySnapshot, !snapshot.documents.isEmpty {
                // User document exists
                let uid = snapshot.documents[0].documentID
                if secretCode == uid {
                    print("User exists with secretCode: \(uid)")
                    self.isUserLoggedIn = true
                    self.currentUser_email = email
                    //self.fetchUsers()
                    completion(true)
                } else {
                    print("Secret Code is invalid")
                }
            } else {
                // User document does not exist
                print("No user exists with email: \(email)")
                print("Email is invalid")
                completion(false)
            }
        }
    }
    
    func user_signOut() {
        //show progress view after logging out
        do {
            try Auth.auth().signOut()
            self.isUserLoggedIn = false
            print("User logged out successfully")
            
        } catch let error as NSError {
            print("There was an error while signing Out! \(error)")
        }
    }
    
    
    //MARK: For both
    func isValidateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]{3,12}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: trimmedEmail)
    }
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let trimmedPassword = password.trimmingCharacters(in: .whitespaces)
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: trimmedPassword)
    }
    
    
    //No need of this. we migh use @AppStorage for this.
    func fetch_Admins() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() else {
                self.error_Message = "Error fetching user data: \(error?.localizedDescription ?? "unknown error")"
                return
            }
            
            guard let admin_pp = self.loadImageFromDiskWith(fileName: "\(self.currentUser_uid)") else {
                print("fetch_admin else part is called.")
                if let admin_image_data = data["profileImageURL"] as? Data, let uiImagee = UIImage(data: admin_image_data) {
                    //self.profileImageURL = url
                    //now here we can store the image in the FM. and retrieve for offline use.
                    print("The uiImagee: is: \(uiImagee)")
                    self.saveImage(imageName: "iphone", image: uiImagee)
                    print("User image has been added to FM from FireStore")
                    
                    guard let fireStore_admin_pic = self.loadImageFromDiskWith(fileName: "iphone") else {return }
                    
                    self.admin_profileImage = fireStore_admin_pic
                    print("Succesfuly displayed")
                }
                
                return
            }
            
            self.admin_profileImage = admin_pp
        }
        
    }
    
    
    
    
    func saveImage(imageName: String, image: UIImage) {
        guard let documentsDirectory = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
            print("Image has been stored in FM...")
        } catch let error {
            print("error saving file with error", error)
        }
        
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        if fileName.isEmpty {   //fileName.isReallyEmpty
            return nil
        }
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        
        return nil
    }
    
    func get_admin_profileImage() {
        admin_profileImage = loadImageFromDiskWith(fileName: "\(currentUser_uid)")
        
    }
}
//}














//MARK: optional fetch user.
/*
 func fetchUsers() {
     let ref = Firestore.firestore().collection(currentUser_email)
     
     ref.getDocuments { querysnapShot, error in
         guard error == nil else {
             print("There was an error while fetching data: \(error?.localizedDescription ?? "")")
             return
         }
         
         var users = self.fileManager.getData(fileName: "test1") ?? []
         
         if let snapShot = querysnapShot {
             for doc in snapShot.documents {
                 let data = doc.data()
                 let id = doc.documentID
                 
                 let name = data["name"] as? String ?? ""
                 
                 let serialNo = data["serialNo"] as? String ?? ""
                 
                 let profileImageURLString = data["profileUIimage"] as? String ?? ""
                 let profileUIimage = URL(string: profileImageURLString) // convert the string to a URL object
                 
                 //let profileUIimage = data["profileUIimage"] as? URL ?? Data()
                 
                 let user = User(id: id, name: name, serialNo: serialNo, profileUIimage: profileUIimage)
                 
                 
                 if !users.contains(where: { $0.id != user.id }) {
                     users.append(user)
                 }
                 
//                        self.fileManager.saveData([user], fileName: self.fileName)
//                        print("The new user is: \(user)")
                 //self.fileManager.getData(fileName: self.fileName)
                 
//                        DispatchQueue.main.async { //try it. for delete, check the app on desktop...GM
//                            self.fileManager.saveData([user], fileName: self.fileName)
//                            print("The new user is: \(user)")
//                        }
                 
             }
         }
         
         self.fileManager.saveData(users, fileName: "test1")
     
 }
     /*
      let ref = Firestore.firestore().collection(currentUser_email)
      
      
      
      addSnapshotListener { snapShot, error in
          guard let documents = snapShot?.documents else {
              print("No documents!")
              return
          }
          
//                self.users = documents.map { query_snapShot -> User in
//                    let data = query_snapShot.data()
//                    let id = query_snapShot.documentID
//
//                    let name = data["name"] as? String ?? ""
//
//                    let serialNo = data["serialNo"] as? String ?? ""
//
//                    let profileUIimage = data["profileUIimage"] as? Data ?? Data()
//
//                    let user = User(id: UUID().uuidString, name: name, serialNo: serialNo, profileUIimage: profileUIimage)
//                    print("User is \(user)")
//                    return user
//                }
//
//                print("Total users: \(self.users)")
//            }
//
//
      
      
      
              ref.getDocuments { snapshot, error in
                  guard error == nil else {
                      print("There was an error while fetching data: \(error?.localizedDescription ?? "")")
                      return
                  }
      
                  if let snapshot = snapshot {
                      for doc in snapshot.documents {
                          let id = doc.documentID
                          let data = doc.data()
      
                          let name = data["name"] as? String ?? ""
      
                          let serialNo = data["serialNo"] as? String ?? ""
      
                          let profileImageURL = data["profileImageURL"] as? String ?? "nothing"
      
                          let user = User(id: id, name: name, serialNo: serialNo, profileImageURL: profileImageURL)
      
      
                          self.fileManager.saveData([user], fileName: self.fileName)
                          print("The new user is: \(user)")
                          self.fileManager.getData(fileName: self.fileName)
      
              DispatchQueue.main.async { try it. for delete, check the app on desktop...GM
                  self.users.append(user)
              }
      
                      }
      
                      //check here.
      
                  }
      
                  //n1. not works
                  guard let savedUsers = self.fileManager.getData(fileName: self.fileName) else { return }
      //
                  print("All users in FM: \(savedUsers)")
      //            for savedUser in savedUsers {
      //                self.users.append(savedUser)
      //            }
              }
      
      //1. not work here
  }
      */
 
 
//        func fetchUsers() {
//            let ref = Firestore.firestore().collection(currentUser_email)
//            ref.getDocuments { snapshot, error in
//                guard error == nil else {
//                    print("There was an error while fetching data: \(error?.localizedDescription ?? "")")
//                    return
//                }
//
//                if let snapshot = snapshot {
//                    var profileImage: Data = .init(count: 0)
//                    for doc in snapshot.documents {
//                        let data = doc.data()
//
//
//                    }
//                }
//
//            }
//        }
 
//    func fetchUsers() {
//        let ref = Firestore.firestore().collection(currentUser_email).addSnapshotListener { snapShot, error in
//            guard let documents = snapShot?.documents else {
//                print("No documents!")
//                return
//            }
//
//            self.users = documents.map { query_snapShot -> User in
//                let data = query_snapShot.data()
//                let id = query_snapShot.documentID
//
//                let name = data["name"] as? String ?? ""
//
//                let serialNo = data["serialNo"] as? String ?? ""
//
//                let profileUIimage = data["profileUIimage"] as? Data ?? Data()
//
//                let user = User(id: id, name: name, serialNo: serialNo, profileUIimage: profileUIimage)
////                   print("User is \(user)")
//                self.fileManager.saveData([user], fileName: "test1")
//                print("User: \(user) is added to FM")
//                return user
//            }
//
//            print("Total users: \(self.users)")
//        }
//    }
 

//✅
 //MARK: Admin Authentication.
 func admin_registeration(profileImage: UIImage, completion: @escaping (String) -> Void) {
     self.isUserLoggedIn = false
     Auth.auth().createUser(withEmail: email, password: password) { result, error in
         if let error = error {
             print("Error creating user: \(error.localizedDescription)")
             self.progressBar_rolling = false
             return
         }

         guard let user = result?.user else {
             self.error_Message = "Error creating user: no user object found"
             self.progressBar_rolling = false
             return
         }

         self.currentUser_uid = user.uid
         print("calling the updated uid: \(self.currentUser_uid)")

         //guard let u_id = currentUser_uid else { return }
         completion(self.currentUser_uid)
         print("after completion: uid: \(self.currentUser_uid)")

         print("The admin registeration is called, uid is: \(self.currentUser_uid)")

         let storageRef = Storage.storage().reference(withPath: user.uid)

         guard let imageData = profileImage.jpegData(compressionQuality: 0.5) else {
             self.error_Message = "Error converting image to data"
             self.progressBar_rolling = false
             return
         }

         storageRef.putData(imageData, metadata: nil) { metadata, error in
             if let error = error {
                 self.error_Message = "Error uploading image: \(error.localizedDescription)"
                 self.progressBar_rolling = false
                 return
             }

             storageRef.downloadURL { url, error in
                 if let error = error {
                     self.error_Message = "Error retrieving download URL: \(error.localizedDescription)"
                     self.progressBar_rolling = false
                     return
                 }

                 guard let downloadURL = url else {
                     self.error_Message = "Error retrieving download URL: no URL found"
                     self.progressBar_rolling = false
                     return
                 }

                 let userData: [String: Any] = [
                     "email": user.email ?? "unKnownEmail",
                     "profileImageURL": downloadURL.absoluteString
                 ]

                 Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
                     if let error = error {
                         self.error_Message = "Error storing user data: \(error.localizedDescription)"
                         self.progressBar_rolling = false
                         return
                     }

                     self.error_Message = "User data stored successfully"
                     self.progressBar_rolling = false
                 }
             }
         }
     }

     self.isUserLoggedIn = false
     //completion(self.cur)
 }

 func validateEmail_Password_adminRegister(image: UIImage) {
     if !email.isEmpty && !password.isEmpty {
         if isValidateEmail() {
             if isValidPassword() {
                 self.progressBar_rolling = true
                 admin_registeration(profileImage: image) { currentUser_uid in
                     //self.current_admin_uid = currentUser_uid
                     print("Admin user id assigned: \(currentUser_uid)")
                     //self.saveImage(imageName: "\(currentUser_uid)", image: image)
                     print("Admin picture saved in FM with the uid: \(currentUser_uid)")
                     self.error_Message = "Successfully Registered"
                     self.progressBar_rolling = false
                 }
                 //MARK: Add the image to File Manager.
                 //self.saveImage(imageName: "\(self.current_admin_uid)", image: image)
                 print("Admin picture saved in FM with the uid: \(currentUser_uid)")
                 error_Message = "Sucessfully Registered"
                 progressBar_rolling = false
             } else { error_Message = "Wrong Password" }

         } else { error_Message = "Wrong email" }
     }
     self.progressBar_rolling = true
 }

 //MARK: It is a part of the above func.
 func admin_Login() {
     Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
         if error != nil {
             print("There was an error while login...\(String(describing: error?.localizedDescription))")
             self?.error_Message = String(describing: error?.localizedDescription)
             self?.progressBar_rolling = false
             self?.isUserLoggedIn = false
         }

         self?.currentUser_email = Auth.auth().currentUser?.email ?? "UnknownUser_email"
         //updated
         self?.currentUser_uid = Auth.auth().currentUser?.uid ?? "Unknown currentUser_uid"
         //self.fetchUsers()
         self?.progressBar_rolling = false
         //self.isUserLoggedIn = true
         
         DispatchQueue.main.async {
             self?.signedIn = true
         }
     }
 }

 func admin_signInWithGoogle() {
     //get app client id.
     guard let clientID = FirebaseApp.app()?.options.clientID else { return }

     // Create Google Sign In configuration object.
     let config = GIDConfiguration(clientID: clientID)
     GIDSignIn.sharedInstance.configuration = config

     //sign In method goes here...
     GIDSignIn.sharedInstance.signIn(
         withPresenting: SceneDelegate.rootViewController) { user, error in

             if let error = error {
                 self.progressBar_rolling = false
                 print(error.localizedDescription)
                 return
             }

             guard
                 let user = user?.user,
                 let idToken = user.idToken else { return }

             let accessToken = user.accessToken

             self.currentUser_email = user.profile?.email ?? "Unknow_signInwithEmail" // new method to get the email of the user.
             let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)


             Auth.auth().signIn(with: credential) { res, error in
                 if let error = error {
                     self.progressBar_rolling = false
                     print(error.localizedDescription)
                     return
                 }

                 //store the email in the users collection.
                 guard let user = res?.user else { return }
                 self.currentUser_uid = user.uid
                 let userData = ["email": user.email ?? ""]
                 Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
                     if let error = error {
                         self.progressBar_rolling = false
                         print("Error storing user data: \(error.localizedDescription)")
                     } else {
                         print("User data stored successfully")
                     }
                 }
                 //self.fetchUsers()
                 //print(user)
             }


             //self.progressBar_rolling = false
         }
 }

 func admin_signOut() {
     //show progress view after logging out
     do {
         try Auth.auth().signOut()
         self.isUserLoggedIn = false
         print("User logged out successfully")

     } catch let error as NSError {
         print("There was an error while signing Out! \(error)")
     }
 }

 func validateEmail_Password_adminLogin() {
     if !email.isEmpty && !password.isEmpty {
         if isValidateEmail() {
             if isValidPassword() {
                 progressBar_rolling = true
                 admin_Login()
             } else { error_Message = "Wrong Password"}

         } else {
             error_Message = "Wrong email"
         }
     }
 }


 //MARK: User Authentication.
 func validate_user(email: String, secretCode: String, completion: @escaping (Bool) ->() ) {
     let email = email // email

     // Query the "users" collection for a document with the specified email address
     Firestore.firestore().collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
         if let error = error {
             print("Error fetching user document: \(error.localizedDescription)")
             completion(false)
         } else if let snapshot = querySnapshot, !snapshot.documents.isEmpty {
             // User document exists
             let uid = snapshot.documents[0].documentID
             if secretCode == uid {
                 print("User exists with secretCode: \(uid)")
                 self.isUserLoggedIn = true
                 self.currentUser_email = email
                 //self.fetchUsers()
                 completion(true)
             } else {
                 print("Secret Code is invalid")
             }
         } else {
             // User document does not exist
             print("No user exists with email: \(email)")
             print("Email is invalid")
             completion(false)
         }
     }
 }

 func user_signOut() {
     //show progress view after logging out
     do {
         try Auth.auth().signOut()
         self.isUserLoggedIn = false
         print("User logged out successfully")

     } catch let error as NSError {
         print("There was an error while signing Out! \(error)")
     }
 }


 //MARK: For both
 func isValidateEmail() -> Bool {
     let emailRegex = "[A-Z0-9a-z._%+-]{3,12}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
     let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
     return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: trimmedEmail)
 }
 func isValidPassword() -> Bool {
     let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
     let trimmedPassword = password.trimmingCharacters(in: .whitespaces)
     return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: trimmedPassword)
 }

  


 //No need of this. we migh use @AppStorage for this.
 func fetch_Admins() {

     guard let uid = Auth.auth().currentUser?.uid else { return }

     Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
         guard let data = snapshot?.data() else {
             self.error_Message = "Error fetching user data: \(error?.localizedDescription ?? "unknown error")"
             return
         }

         guard let admin_pp = self.loadImageFromDiskWith(fileName: "\(self.currentUser_uid)") else {
             print("fetch_admin else part is called.")
             if let admin_image_data = data["profileImageURL"] as? Data, let uiImagee = UIImage(data: admin_image_data) {
                 //self.profileImageURL = url
                 //now here we can store the image in the FM. and retrieve for offline use.
                 print("The uiImagee: is: \(uiImagee)")
                 self.saveImage(imageName: "iphone", image: uiImagee)
                 print("User image has been added to FM from FireStore")

                 guard let fireStore_admin_pic = self.loadImageFromDiskWith(fileName: "iphone") else {return }

                 self.admin_profileImage = fireStore_admin_pic
                 print("Succesfuly displayed")
             }

             return
         }

         self.admin_profileImage = admin_pp
     }

 }




 func saveImage(imageName: String, image: UIImage) {
     guard let documentsDirectory = FileManager
     .default
     .urls(for: .documentDirectory, in: .userDomainMask)
     .first else { return }

     let fileName = imageName
     let fileURL = documentsDirectory.appendingPathComponent(fileName)
     guard let data = image.jpegData(compressionQuality: 1) else { return }

     //Checks if file exists, removes it if so.
     if FileManager.default.fileExists(atPath: fileURL.path) {
         do {
             try FileManager.default.removeItem(atPath: fileURL.path)
             print("Removed old image")
         } catch let removeError {
             print("couldn't remove file at path", removeError)
         }
     }

     do {
         try data.write(to: fileURL)
         print("Image has been stored in FM...")
     } catch let error {
         print("error saving file with error", error)
     }

 }

 func loadImageFromDiskWith(fileName: String) -> UIImage? {

     if fileName.isEmpty {   //fileName.isReallyEmpty
         return nil
     }

     let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

     let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
     let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

     if let dirPath = paths.first {
         let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
         let image = UIImage(contentsOfFile: imageUrl.path)
         return image

     }

     return nil
 }

 func get_admin_profileImage() {
     admin_profileImage = loadImageFromDiskWith(fileName: "\(currentUser_uid)")

 }
}
 
 
 
 
 //         guard let imageData = profileUIimage.jpegData(compressionQuality: 0.5) else {
 //             self.error_Message = "Error converting image to data"
 //             self.progressBar_rolling = false
 //             return
 //         }

 //         guard let uiImageData = profileUIimage.jpegData(compressionQuality: 0.5) else {
 //             self.error_Message = "Error converting image to data"
 //             self.progressBar_rolling = false
 //             return
 //         }
 */


/*
 */
