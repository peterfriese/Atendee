//
//  FileManager.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 03/04/2023.
//

import Foundation
import SwiftUI

class MyFileManager {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func saveUsers(users: [User], fileName: String) {
        //get the url for the directory.
        guard let fileUrl = getURL_path(fileName: fileName) else { return }
        
        
        //encode the user objects, into data object and then write the data into the disk
        do {
            guard let userData = try? encoder.encode(users) else {
                print("Can not encode userData")
                return
            }
            
            try userData.write(to: fileUrl, options: .atomic)
        } catch {
            print("Error")
        }
        
        
    }
    
    func getUsers(fileName: String) -> [User]? {
        //get the url for the directory.
        guard let fileUrl = getURL_path(fileName: fileName) else { return nil }
        
        
        
        //decode the data object, into user objects and then returned.
        do {
            guard let userData = try? Data(contentsOf: fileUrl, options: .mappedIfSafe) else { return nil }
            
            guard let users = try? decoder.decode([User].self, from: userData) else {
                print("Oh sorry! Can not decode the userData.")
                return nil
            }
            
            return users
            
        } catch {
            print("Can not decode the data!")
        }
    }
    
    
    func getURL_path(fileName: String) -> URL? {
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let url = docDirectory.appendingPathComponent(fileName)
        
        return url
    }
}
























//✅
class FileManagerClass {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func saveUsers_toFM(_ data: [User], fileName: String) {
        //get the url for the folder we want to save data in...
        guard let fileURL = getFilePathURL(fileName: fileName) else { return }
        
        
        //Encode array of User objects into a Data object
        do {
            guard let data = try? encoder.encode(data) else {
                print("Can not encode the data")
                return
            }
            
            //The Data object is written to disk.
            try data.write(to: fileURL, options: .atomic)//atomic is used to write the data atomically to the file system.
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    func getUsers_fromFM(fileName: String) -> [User]? {
        guard let fileURL = getFilePathURL(fileName: fileName) else { return nil }
        
        do {
            //read the data on the specified file.
            guard let data = try? Data(contentsOf: fileURL, options: .mappedIfSafe) else {
                return nil
            }
            
            //decode the Data object into an array of User objects
            guard let users = try? decoder.decode([User].self, from: data) else {
                print("Can not decode the Data")
                return nil
            }
            
            return users
        } catch {
            print("Error getting data: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    func saveAdmin_toFM(_ data: Admin, fileName: String) {
        //get the url for the folder we want to save data in...
        guard let fileURL = getFilePathURL(fileName: fileName) else { return }
        
        
        //Encode array of User objects into a Data object
        do {
            guard let data = try? encoder.encode(data) else {
                print("Can not encode the data")
                return
            }
            
            //The Data object is written to disk.
            try data.write(to: fileURL, options: .atomic)//atomic is used to write the data atomically to the file system.
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    func getAdmin_fromFM(fileName: String) -> Admin? {
        guard let fileURL = getFilePathURL(fileName: fileName) else { return nil }
        
        do {
            //read the data on the specified file.
            guard let data = try? Data(contentsOf: fileURL, options: .mappedIfSafe) else {
                return nil
            }
            
            //decode the Data object into an array of User objects
            guard let admin = try? decoder.decode(Admin.self, from: data) else {
                print("Can not decode the Data")
                return nil
            }
            
            return admin
        } catch {
            print("Error getting data: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    private func getFilePathURL(fileName: String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        //if we get into that particular directory.
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        return fileURL
    }
    
}












//For Reuse. It tries to save image.
class Local_FileManager2 {

    static let instance = Local_FileManager2()

    private init() { }


    func saveData_to_FM(image: UIImage, imageName: String, folderName: String) {

        //create folder:
        createFolder_ifNeeded(folderName: folderName)

        //get path for image.
        guard
            let data = image.jpegData(compressionQuality: 0.5),
            let url = getUrl_forImage(imageName: imageName, folderName: folderName) else { return }


        //Checks if file exists, removes it if so.
//        if FileManager.default.fileExists(atPath: url.path) {
//            do {
//                try FileManager.default.removeItem(atPath: url.path)
//                print("Removed old image")
//            } catch let removeError {
//                print("couldn't remove file at path", removeError)
//            }
//        }

        //save image to that path.
        do {
            try data.write(to: url)
        } catch {
            print("There was an error while saving data to FM. error: \(error) and image: \(imageName)")
        }

    }

    func getData_from_FM(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getUrl_forImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path()) else { return nil }  //path.

        return UIImage(contentsOfFile: url.path()) //path
    }

    //create the folder for that particular url
    private func createFolder_ifNeeded(folderName: String) {
        //check the url exist
        guard let url = getUrl_forFolder(folderName: folderName) else { return }

        //if not exist, then create it.
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("Folder can not be created for that url: \(error) and folderName: \(folderName)")
            }
        }
    }


    //get the url for the folder we want to save data in...
    private func getUrl_forFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }

        return url.appendingPathComponent(folderName)
    }

    //now save the image in that particular folder.
    private func getUrl_forImage(imageName: String, folderName: String) -> URL? {
        guard let folder_url = getUrl_forFolder(folderName: folderName) else { return nil }

        //if we get into that particular folder, then save the image
        return folder_url.appendingPathComponent(imageName + ".jpg")
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
//        if FileManager.default.fileExists(atPath: fileURL.path) {
//            do {
//                try FileManager.default.removeItem(atPath: fileURL.path)
//                print("Removed old image")
//            } catch let removeError {
//                print("couldn't remove file at path", removeError)
//            }
//        }

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
}
