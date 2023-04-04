//
//  ImagePicker.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 03/04/2023.
//


import Foundation
import SwiftUI
import PhotosUI
import Combine

//✅
struct ImagePicker : UIViewControllerRepresentable {
    @Binding var show : Bool
    @Binding var image : Data
    var sourceType : UIImagePickerController.SourceType = .photoLibrary
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        
        return ImagePicker.Coordinator(child1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var child : ImagePicker
        
        init(child1: ImagePicker) {
            
            child = child1
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.child.show.toggle()
            
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let image = info[.originalImage]as! UIImage
            
            let data = image.jpegData(compressionQuality: 0.45)
            
            self.child.image = data!
            self.child.show.toggle()
            
        }
    }
}


struct ImagePicker2: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        /*
         That does three things:

         It makes the class inherit from NSObject, which is the parent class for almost everything in UIKit. NSObject allows Objective-C to ask the object what functionality it supports at runtime, which means the photo picker can say things like “hey, the user selected an image, what do you want to do?”
         It makes the class conform to the PHPickerViewControllerDelegate protocol, which is what adds functionality for detecting when the user selects an image. (NSObject lets Objective-C check for the functionality; this protocol is what actually provides it.)
         It stops our code from compiling, because we’ve said that class conforms to PHPickerViewControllerDelegate but we haven’t implemented the one method required by that protocol.
         */

        //Rather than just pass the data down one level, a better idea is to tell the coordinator what its parent is, so it can modify values there directly. That means adding an ImagePicker property and associated initializer to the Coordinator class, like this:
        var parent: ImagePicker2
        init(_ parent: ImagePicker2) {
            self.parent = parent
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            /*
             It’s our job to do three things:

             1.Tell the picker to dismiss itself.
             2.Exit if the user made no selection – if they tapped Cancel.
             3.therwise, see if the user’s results includes a UIImage we can actually load, and if so place it into the parent.image property.
             */
            // Tell the picker to go away
            picker.dismiss(animated: true)

            // Exit if no selection was made
            guard let provider = results.first?.itemProvider else { return }

            // If this has an image we can use, use it
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }


    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration() // what kind of things you want to work with.
        config.filter = .images //what kind, videos, images, yes only pics.

        let picker = PHPickerViewController(configuration: config) //put in the viewController.
        picker.delegate = context.coordinator //tell the PHPickerViewController that when something happens it should tell our coordinator.
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        //
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
