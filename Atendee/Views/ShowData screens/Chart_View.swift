//
//  Chart_View.swift
//  GymTendy
//
//  Created by Muhammad Farid Ullah on 21/03/2023.
//

import Foundation
import SwiftUI
import Charts

struct SavingsDataPoint: Identifiable {
    let month: String
    let value: Double
    var id = UUID()
}

struct Chart_View: View {
    let data: [SavingsDataPoint]
    
    var body: some View {
           VStack {
               Chart {
                   ForEach(Array(data.enumerated()), id: \.offset) { index, element in
                       BarMark(x: .value("month", element.month), y: .value("value", element.value))
                           .foregroundStyle(index % 2 == 0 ? Color.lightBar : Color.darkBar)
                   }
               }
               .chartXAxis {
                   AxisMarks(values: .automatic) { _ in
                       AxisValueLabel()
                   }
               }
               .chartYAxis {
                   AxisMarks(position: .leading, values: .automatic) { value in
                       AxisValueLabel() {
                           if let intValue = value.as(Int.self) {
                               if intValue < 1000 {
                                   Text("\(intValue)")
                                       .font(.body)
                               } else {
                                   Text("\(intValue/1000)\(intValue == 0 ? "" : "k")")
                                       .font(.body)
                               }
                           }
                       }
                   }
               }
           }
       }
}

extension Color {
    static let darkBar = Color(red: 0.11, green: 0.133, blue: 0.173)
    static let lightBar = Color(red: 0.776, green: 0.878, blue: 0.91)
}

struct Chart_View_Previews: PreviewProvider {
    static var previews: some View {
        Show_chartView ()
    }
}


struct Show_chartView: View {
    @State var selectedTab = "Monthly"
    var tabs = ["Monthly", "Weekly", "Daily"]
    
    var chartData = ["Monthly" : [SavingsDataPoint(month: "May", value: 4000),
                                  SavingsDataPoint(month: "Jun", value: 9880),
                                  SavingsDataPoint(month: "Jul", value: 6500),
                                  SavingsDataPoint(month: "Aug", value: 5500),
                                  SavingsDataPoint(month: "Sep", value: 8000),
                                  SavingsDataPoint(month: "Oct", value: 4000)],
                     "Weekly" : [SavingsDataPoint(month: "Mon", value: 342),
                                 SavingsDataPoint(month: "Tue", value: 567),
                                 SavingsDataPoint(month: "Wed", value: 231),
                                 SavingsDataPoint(month: "Thu", value: 234),
                                 SavingsDataPoint(month: "Fri", value: 986),
                                 SavingsDataPoint(month: "Sat", value: 564)],
                     "Daily" : [SavingsDataPoint(month: "May", value: 4000),
                                SavingsDataPoint(month: "Jun", value: 9880),
                                SavingsDataPoint(month: "Jul", value: 6500),
                                SavingsDataPoint(month: "Aug", value: 5500),
                                SavingsDataPoint(month: "Sep", value: 8000),
                                SavingsDataPoint(month: "Oct", value: 4000)]]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("50,000 PKR")
                    .font(.headline.bold())
                Text("estimated")
                    .font(.subheadline)
                    .foregroundColor(.gray.opacity(0.3))
                
                Chart_View(data: chartData[selectedTab]!)
                    .frame(width: 325, height: 200)
                    .padding()
                    .animation(.easeInOut, value: selectedTab)
                
                ScrollView {
                    ForEach(1..<10, id: \.self) { item in
                        HStack {
                            Image(systemName: "house").padding(.leading).font(.subheadline)
                            Text("Admission").font(.subheadline)
                            Spacer()
                            Text("10,000").padding(.trailing).font(.subheadline)
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.primary)
                        .cornerRadius(10)
                        
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                }
                
                
                
            }
        }.navigationTitle("Tracking")
    }
}
