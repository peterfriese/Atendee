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
    @EnvironmentObject var userData_vm: UserData_VM
    
    @State private var name = ""
    @State private var serialNo = ""
    @State private var fName = ""
    @State private var userContact: String = ""
    @State private var userAdding_date: Date = .now
    @State private var optional: String = ""
    
    //computed property
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }

    
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
    @State var image: UIImage?
    @State var isImageSelected: Bool = false
    
    let roundedCornerButtonColor = Color("roundedLineColor").opacity(0.3)

    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        firstHalfView
                            //.padding(.horizontal)
                        
                        HStack {
                            Text("Monthly Fees")
                                .font(.title2.bold())
                            Spacer()
                        }.padding(.top)
                        
                        SecondHalfView
                            //.padding(.horizontal)
                            
                        
                        
                        ReUsable_Button(
                            title: "Save",
                            buttonBackgroundColor: validat_AddView ? Color("softbutton_Color") : Color("softbutton_Color").opacity(0.5)) {
                            if let wrappedImage = image {
                                if let imageData = wrappedImage.jpegData(compressionQuality: 0.5) {
                                    userAdmin_vm.progressBar_rolling = true
                                    //userAdmin_vm.saveImage(imageName: "imageName", image: wrappedImage)
                                    userData_vm.addUser(
                                        name: name,
                                        serialNo: serialNo,
                                        profileUIimage: imageData,
                                        userAdding_date: userAdding_date,
                                        userContact: userContact
                                    )
                                    userData_vm.getUsers()
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                //user_vm.fetchUsers()//
                                isImageSelected = false
                                self.dismiss()
                            }
                        }
                        .disabled(!validat_AddView)
                        
                        
                        Spacer()
                    }
                    .padding(.horizontal, 10)
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
                            .foregroundColor(Color("softbutton_Color"))
                    }
                }
                .frame(width: 80, height: 80)
                
                .clipShape(Circle())
                
                .overlay(
                    Circle()
                        .stroke(roundedCornerButtonColor, lineWidth: 1.5)
                    
                        
                )
            }
            
            ReUsable_TextFeild(
                imageName: "person.fill",
                title: "User name",
                text: $name, borderColor: roundedCornerButtonColor)
            //.frame(width: .infinity)
            
            
            HStack(spacing: 10) {
                ReUsable_TextFeild(
                    imageName: "person.fill",
                    title: "Father name",
                    text: $fName, borderColor: roundedCornerButtonColor)
                //.frame(width: .infinity)
                
                //MARK: IT IS NUMBER. Adjust accordingly.
                ReUsable_TextFeild(
                    imageName: "key.fill",
                    title: "Serial No",
                    text: $serialNo, borderColor: roundedCornerButtonColor)
                .frame(width: 135)
                .keyboardType(.numberPad)
                //.frame(width: 150)
                
            }
            
            
            HStack(spacing: 10) {
                
                ReUsable_iPhoneNumberFeild(
                    title: "+92-000-0000000",
                    text: $userContact,
                    borderColor: roundedCornerButtonColor)
                .keyboardType(.numberPad)

                
                
                //MARK: DO NOT FORGET.
                ReUsable_TextFeild(
                    imageName: "",
                    title: "",
                    text: $optional, borderColor: roundedCornerButtonColor)
                .frame(width: 135)
                .overlay {
                    DatePicker("", selection: $userAdding_date, in: ...Date.now, displayedComponents: .date)
                        //.frame(width: 200, height: 200)
                        //.scaleEffect(0.8)
                        .padding(.trailing, 8)
                }
                
                
            }
        }
        
    }
    
    var SecondHalfView: some View {
        Group {
            //showMonth_line1. defualt
            HStack(spacing: 10) {
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
    
    //MARK: do not forget
    var validat_AddView: Bool {
        if image == nil || name.isEmpty || serialNo.isEmpty || fName.isEmpty || userContact.isEmpty {
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
            .environmentObject(UserData_VM())
    }
}

