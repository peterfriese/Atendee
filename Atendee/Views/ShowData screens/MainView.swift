//
//  MainView.swift
//  GymTendy
//
//  Created by Muhammad Farid Ullah on 12/02/2023.
//

import SwiftUI
struct MainView: View {
    //@Environment(\.managedObjectContext) var moc
//    @EnvironmentObject var user_vm: User_VM
    @EnvironmentObject var userAdmin_vm: Authentication_AdminUser_VM
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            Text("Workout View")
                .tabItem {
                    Label("Workout", systemImage: "figure.strengthtraining.traditional")
                }
            
            Show_chartView()
                .tabItem {
                    Label("Chart", systemImage: "chart.bar.xaxis")
                }
            
            Admin_Profile_View()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            
        }        
    }
}
