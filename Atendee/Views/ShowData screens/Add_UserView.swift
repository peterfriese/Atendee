//
//  Add_UserView.swift
//  GymTendy
//
//  Created by Muhammad Farid Ullah on 13/02/2023.
//

import SwiftUI
import CoreData
import Firebase
import FirebaseFirestore

struct Add_UserView: View {
    @EnvironmentObject var userAdmin_vm: Authentication_AdminUser_VM
    @State private var name = ""
    @State private var serialNo = ""
    @State private var fName = ""
    @State private var contact: String = ""
    @State private var userDate: Date = .now
    
    //fees
    @State private var feeMonth1: Int = 0
    @State private var feeMonth2: Int = 0
    @State private var feeMonth3: Int = 0
    @State private var feeMonth4: Int = 0
    @State private var feeMonth5: Int = 0
    @State private var feeMonth6: Int = 0
    @State private var feeMonth7: Int = 0
    @State private var feeMonth8: Int = 0
    @State private var feeMonth9: Int = 0
    @State private var feeMonth10: Int = 0
    @State private var feeMonth11: Int = 0
    @State private var feeMonth12: Int = 0
    //Months Names
    @State var selectedMonth1 = "Jan"
    @State var selectedMonth2 = "Fab"
    @State var selectedMonth3 = "Mar"
    @State var selectedMonth4 = "Apr"
    @State var selectedMonth5 = "May"
    @State var selectedMonth6 = "Jun"
    @State var selectedMonth7 = "Jul"
    @State var selectedMonth8 = "Aug"
    @State var selectedMonth9 = "Sep"
    @State var selectedMonth10 = "Oct"
    @State var selectedMonth11 = "Nov"
    @State var selectedMonth12 = "Dec"
    
    //optional
    @State private var showMonth_line2 = true
    @State private var showMonth_line3 = true
    @State private var showMonth_line4 = true
    
    

    
    @State private var isShowingImagePciker = false
    @Environment(\.dismiss) var dismiss
    //@Environment(\.managedObjectContext) var moc
    @State var image: UIImage?
    @State var isImageSelected: Bool = false
    
    let roundedCornerButtonColor = Color("softbutton_Color").opacity(0.3)

    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        firstHalfView
                        
                        HStack {
                            Text("Monthly Fees")
                                .font(.title2.bold())
                            Spacer()
                        }.padding(.top)
                        
                        SecondHalfView
                        
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .navigationTitle("Add new user")
                    .navigationBarTitleDisplayMode(.inline)
                    .sheet(isPresented: $isShowingImagePciker) {
                        ImagePicker2(image: $image)
                        //.environmentObject(user_vm.moc) //try this as well
                    }
                    
                    progresBar
                }
            }
        }
    }
    
    
    var firstHalfView: some View {
        Group {
            Button {
                isShowingImagePciker = true
            } label: {
                VStack {
                    if let image = self.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                        
                    } else {
                        Image(systemName: "person.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.primary)
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.black, lineWidth: 2)
                )
            }
            
            ReUsable_TextFeild(
                imageName: "person.fill",
                title: "User name",
                text: $name, borderColor: roundedCornerButtonColor)
            .frame(width: .infinity)
            
            
            HStack(spacing: 10) {
                ReUsable_TextFeild(
                    imageName: "person.fill",
                    title: "Father name",
                    text: $fName, borderColor: roundedCornerButtonColor)
                .frame(width: .infinity)
                
                
                ReUsable_TextFeild(
                    imageName: "key.fill",
                    title: "User Serial No",
                    text: $serialNo, borderColor: roundedCornerButtonColor)
                .frame(width: .infinity)
                
            }
            
            
            HStack(spacing: 10) {
                ReUsable_TextFeild(
                    imageName: "phone.fill",
                    title: "User Contact",
                    text: $contact, borderColor: roundedCornerButtonColor)
                .frame(width: .infinity)
                
                
                //MARK: DO NOT FORGET.
                ReUsable_TextFeild(
                    imageName: "calendar.badge.clock",
                    title: "Date",
                    text: $contact, borderColor: roundedCornerButtonColor)
                .frame(width: .infinity)
                
            }
        }
    }
    
    var SecondHalfView: some View {
        Group {
            
            
            //showMonth_line1. defualt
            HStack {
                ReUseable_ValueFeild(title: "Fee", value: $feeMonth1, borderColor: roundedCornerButtonColor, selectedMonth: $selectedMonth1)
                
                ReUseable_ValueFeild(title: "Fee", value: $feeMonth2, borderColor: roundedCornerButtonColor, selectedMonth: $selectedMonth2)
                
                ReUseable_ValueFeild(title: "Fee", value: $feeMonth3, borderColor: roundedCornerButtonColor, selectedMonth: $selectedMonth3)
                
            }
            
            HStack {
                ReUseable_ValueFeild(title: "Fee", value: $feeMonth4, borderColor: roundedCornerButtonColor, selectedMonth: $selectedMonth4)
                
                ReUseable_ValueFeild(title: "Fee", value: $feeMonth5, borderColor: roundedCornerButtonColor, selectedMonth: $selectedMonth5)
                
                ReUseable_ValueFeild(title: "Fee", value: $feeMonth6, borderColor: roundedCornerButtonColor, selectedMonth: $selectedMonth6)
            }
            
            HStack {
                ReUseable_ValueFeild(title: "Fee", value: $feeMonth7, borderColor: roundedCornerButtonColor, selectedMonth: $selectedMonth7)
                
                ReUseable_ValueFeild(title: "Fee", value: $feeMonth8, borderColor: roundedCornerButtonColor, selectedMonth: $selectedMonth8)
                
                ReUseable_ValueFeild(title: "Fee", value: $feeMonth9, borderColor: roundedCornerButtonColor, selectedMonth: $selectedMonth9)
            }
            
            
            
            ReUsable_Button(
                title: "Save",
                buttonBackgroundColor: validat_AddView ? Color("softbutton_Color") : Color("softbutton_Color").opacity(0.5)) {
                if let wrappedImage = image {
                    if let imageData = wrappedImage.jpegData(compressionQuality: 0.5) {
                        userAdmin_vm.progressBar_rolling = true
                        userAdmin_vm.saveImage(imageName: "imageName", image: wrappedImage)
                        userAdmin_vm.addUser(name: name, serialNo: serialNo, profileUIimage: imageData)
                        userAdmin_vm.getUsers()
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    //user_vm.fetchUsers()//
                    isImageSelected = false
                    self.dismiss()
                }
            }
            .disabled(!validat_AddView)
        }
    }
    
    var progresBar: some View {
        Group {
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
            }
        }
    }
    
    var validat_AddView: Bool {
        if image == nil || name.isEmpty || serialNo.isEmpty || fName.isEmpty || contact.isEmpty {
            //_ = wrappedImage.jpegData(compressionQuality: 0.5)
            return false
        }
        
        return true
    }
}

struct Add_UserView_Previews: PreviewProvider {
    static var previews: some View {
        Add_UserView()
            .environmentObject(Authentication_AdminUser_VM())
    }
}


/*
 var addView: some View {
     ZStack {
         
         Color("backgroundColor")
             .ignoresSafeArea()

         VStack(spacing: 20) {
             Button {
                 isShowingImagePciker = true
             } label: {
                 VStack {
                     if let image = self.image {
                         Image(uiImage: image)
                             .resizable()
                             .scaledToFill()
                         
                     } else {
                         Image(systemName: "person.fill")
                             .font(.system(size: 50))
                             .foregroundColor(.primary)
                     }
                 }
                 .frame(width: 80, height: 80)
                 .clipShape(Circle())
                 .overlay(
                     Circle()
                         .stroke(.black, lineWidth: 2)
                 )
             }
             
             ReUsable_TextFeild(
                 imageName: "person.fill",
                 title: "User name",
                 text: $name, borderColor: .red.opacity(0.5))
             .frame(width: .infinity)
             
             
             HStack(spacing: 10) {
                 ReUsable_TextFeild(
                     imageName: "person.fill",
                     title: "Father name",
                     text: $fName, borderColor: .red.opacity(0.5))
                 .frame(width: .infinity)
                 
                 
                 ReUsable_TextFeild(
                     imageName: "key.fill",
                     title: "User Serial No",
                     text: $serialNo, borderColor: .red.opacity(0.5))
                 .frame(width: .infinity)
                 
             }
             
             
             HStack(spacing: 10) {
                 ReUsable_TextFeild(
                     imageName: "phone.fill",
                     title: "User Contact",
                     text: $contact, borderColor: .red.opacity(0.5))
                 .frame(width: .infinity)
                 
                 
                 //MARK: DO NOT FORGET.
                 ReUsable_TextFeild(
                     imageName: "calendar.badge.clock",
                     title: "Date",
                     text: $contact, borderColor: .red.opacity(0.5))
                 .frame(width: .infinity)
                 
             }
             
             Spacer()
             
             
             ReUsable_Button(
                 title: "Save",
                 buttonBackgroundColor: validat_AddView ? .green : .green.opacity(0.4)) {
                 if let wrappedImage = image {
                     if let imageData = wrappedImage.jpegData(compressionQuality: 0.5) {
                         userAdmin_vm.progressBar_rolling = true
                         userAdmin_vm.saveImage(imageName: "imageName", image: wrappedImage)
                         userAdmin_vm.addUser(name: name, serialNo: serialNo, profileUIimage: imageData)
                         userAdmin_vm.getUsers()
                     }
                 }
                 
                 DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                     //user_vm.fetchUsers()//
                     isImageSelected = false
                     self.dismiss()
                 }
             }
             .disabled(!validat_AddView)
             
         }
         //.textFieldStyle(.roundedBorder)
         .padding()
         .navigationTitle("Add new user")
         .navigationBarTitleDisplayMode(.inline)
         .sheet(isPresented: $isShowingImagePciker) {
             ImagePicker2(image: $image)
             //.environmentObject(user_vm.moc) //try this as well
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
         }
     }
 }
 */
