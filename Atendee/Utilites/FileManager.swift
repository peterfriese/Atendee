//
//  FileManager.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 03/04/2023.
//

import Foundation
import SwiftUI


//✅
class FileManagerClass {
    
    func saveData(_ data: [User], fileName: String) {
        guard let fileURL = getFilePathURL(fileName: fileName) else { return }
        
        let encoder = JSONEncoder()
        do {
            guard let data = try? encoder.encode(data) else {
                print("Can not encode the data")
                return
            }
            
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    
    func getData(fileName: String) -> [User]? {
        guard let fileURL = getFilePathURL(fileName: fileName) else { return nil }
        let decoder = JSONDecoder()
        do {
            guard let data = try? Data(contentsOf: fileURL, options: .mappedIfSafe) else {
                return nil
            }
            
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
    
    private func getFilePathURL(fileName: String) -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        return fileURL
    }
    
    
    
    func deleteUserData(fileName: String, userToDelete: User) {
        // Load the data from the file
        guard var users = getData(fileName: fileName) else { return }
        
        // Remove the user to delete from the list
        users.removeAll { $0.serialNo == "Ddduser1" }
        
        // Write the updated user list back to the file
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(users)
            guard let fileURL = getFilePathURL(fileName: fileName) else { return }
            try data.write(to: fileURL)
        } catch {
            print("Error deleting user data: \(error.localizedDescription)")
        }
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
}
