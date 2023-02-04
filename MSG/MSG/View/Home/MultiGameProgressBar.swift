//
//  MultiGameProgressBar.swift
//  MSG
//
//  Created by 정소희 on 2023/01/19.
//

//MARK: -삭제될 뷰입니다.
import SwiftUI

struct MultiGameProgressBar: View {
    
    @State private var fill: CGFloat = 100.0
    var frameWidth = UIScreen.main.bounds.width
    var frameHeight = UIScreen.main.bounds.height
    let stats: Stats
    var colums = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
    func getPercent(current: CGFloat, Goal: CGFloat) -> String {
        let per = (current / Goal)
        return String(format: "%.1f", per)
    }
    var body: some View {
        LazyVGrid(columns: colums, spacing: 30) {
            
            ForEach(stats_Data) { stat in
                
                VStack(spacing: 22) {
                    
                    HStack{
                        Text(stat.title)
                            .font(.title3.bold())
                    }.padding(.bottom, -20)
                    ZStack{
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(Color.purple.opacity(0.09), lineWidth: 10)
                            .frame(width: frameWidth / 3, height: frameHeight / 6)
                        Circle()
                            .trim(from: 0, to: stat.currentDate / stat.goal)
                            .stroke(stat.color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .frame(width: frameWidth / 3, height: frameHeight / 6)
                            .rotationEffect(.init(degrees: -90))
                            .animation(.default, value: fill)
                        
                        Text(getPercent(current: stat.currentDate ,Goal: stat.goal) + " %")
                    }
                }
                .padding()
                .background(Color.white.opacity(0.06))
                .cornerRadius(15)
                .shadow(color: Color.white.opacity(0.1), radius: 10, x:0, y:0)
                .padding(.bottom, -20)
            }
            
           
        }
    }
}

struct Stats: Identifiable {
    
    var id = UUID()
    var title: String
    var currentDate: CGFloat
    var goal: CGFloat
    var color: Color
    
    
}
var stats_Data = [
    Stats(title: "민호", currentDate: 5, goal: 10, color: Color.red),
    Stats(title: "준수", currentDate: 5, goal: 15, color: Color.orange),
    Stats(title: "세훈", currentDate: 5, goal: 20, color: Color.yellow),
    Stats(title: "주희", currentDate: 6.8, goal: 15, color: Color.blue)
    
]

//struct ProgressBar2_Previews: PreviewProvider {
//    static var previews: some View {
//        MultiGameProgressBar(stats: Stats(title: "", currentDate: 0, goal: 0, color: Color.blue))
////        ProgressBar2(expend: expenditure(id: "", expenditureHistory: ["식비" : ["김밥천국 3000원"]]))
//    }
//}
//                LazyVGrid(columns: colums, spacing: 30) {
//
//                    ForEach(stats_Data) { stat in
//
//                        VStack(spacing: 22) {
//
//                            HStack{
//                                Text(stat.title)
//                                    .font(.title3.bold())
//                            }.padding(.bottom, -20)
//                            ZStack{
//                                Circle()
//                                    .trim(from: 0, to: 1)
//                                    .stroke(Color.purple.opacity(0.09), lineWidth: 10)
//                                    .frame(width: frameWidth / 3, height: frameHeight / 6)
//                                Circle()
//                                    .trim(from: 0, to: stat.currentDate / stat.goal)
//                                    .stroke(stat.color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
//                                    .frame(width: frameWidth / 3, height: frameHeight / 6)
//                                    .rotationEffect(.init(degrees: -90))
//                                    .animation(.default, value: fill)
//
//                                Text(getPercent(current: stat.currentDate ,Goal: stat.goal) + " %")
//                            }
//                        }
//                        .padding()
//                        .background(Color.white.opacity(0.06))
//                        .cornerRadius(15)
//                        .shadow(color: Color.white.opacity(0.1), radius: 10, x:0, y:0)
//                        .padding(.bottom, -20)
//                    }
//                }
