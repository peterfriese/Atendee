//
//  MainView.swift
//  GymTendy
//
//  Created by Muhammad Farid Ullah on 12/02/2023.
//

import SwiftUI
struct MainView: View {
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

struct MainView_Previews: PreviewProvider {
    @ObservedObject var userAdmin_vm  = Authentication_AdminUser_VM()
    static var previews: some View {
        MainView()
            .environmentObject(Authentication_AdminUser_VM())
    }
}
