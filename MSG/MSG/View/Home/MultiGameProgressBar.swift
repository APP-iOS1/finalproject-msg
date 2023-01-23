//
//  MultiGameProgressBar.swift
//  MSG
//
//  Created by 정소희 on 2023/01/19.
//

import SwiftUI

struct MultiGameProgressBar: View {
    
    //    @State private var progress:[Float] = [25000, 20000, 45000, 13500, 20000]
    //    @State private var percentArr:[(to: Float, from: Float, percent: Float)] = [(0.0,0.0,0.0), (0.0,0.0,0.0),(0.0,0.0,0.0),(0.0,0.0,0.0),(0.0,0.0,0.0)]
    //    @State var totalMoney:Float = 123500
    //    @State private var colorArr:[Color] = [.red, .blue, .green, .brown, .purple]
    //    @State private var friendArr:[String] = ["민호", "준수", "세훈", "소희", "주희"]
    //    @State private var coinArr:[Int] = [130000, 120000, 220000, 75500, 120000]
    
    @State private var fill: CGFloat = 100.0
    var frameWidth = UIScreen.main.bounds.width
    var frameHeight = UIScreen.main.bounds.height
    //    let expend: expenditure
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
            
            //  ScrollView{
            //            VStack{
            //
            //                LazyVGrid(columns: colums, spacing: 30) {
            //
            //                        VStack(spacing: 22) {
            //
            //                            ZStack{
            //                                Circle()
            //                                    .trim(from: 0, to: 1)
            //                                    .stroke(Color.purple.opacity(0.09), lineWidth: 10)
            //                                    .frame(width: frameWidth / 3, height: frameHeight / 6)
            //                                Circle()
            //                                    .trim(from: 0, to: self.fill)
            //                                    .stroke(Color.purple, lineWidth: 10)
            //                                    .frame(width: frameWidth / 3, height: frameHeight / 6)
            //                                    .rotationEffect(.init(degrees: -90))
            //                                    .animation(.default, value: fill)
            //
            //                                Text("\(Int(self.fill * 100.0)) 원")
            //                            }
            //                        }
            //                        .padding()
            //                        .background(Color.white.opacity(0.06))
            //                        .cornerRadius(15)
            //                        .shadow(color: Color.white.opacity(0.1), radius: 10, x:0, y:0)
            //                        .padding(.bottom, -20)
            //
            //                }
            //                VStack{
            //                    if fill > 0 {
            //                        Button(action: {
            //                            self.fill -= 10.0
            //                        }) {
            //                            Text("추가하기")
            //                        }
            //                    }else if fill < -0 {
            //
            //                    }
            //                }
            //                //.padding(.horizontal, 20)
            //            }
            // }
            //        ZStack{
            //
            //            Capsule()
            //                .stroke(lineWidth: 20.0)
            //                .opacity(0.3)
            //                .foregroundColor(Color.red)
            //                .frame(width: 350,height: 240)
            //
            //            ForEach(progress.indices.reversed(),id:\.self){ index in
            //                Capsule()
            //                    .trim(from: CGFloat(percentArr[index].from), to: CGFloat(min(percentArr[index].to, 1.0)))
            //                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
            //                    .foregroundColor(colorArr[index])
            //                    .frame(width: 350,height: 240)
            //                    //.rotationEffect(Angle(degrees: 270.0))
            //                    .onAppear{
            //                        withAnimation{
            //                            percentArr[index].percent = progress[index] / totalMoney
            //                            percentArr[index].to = percentArr[index].from + percentArr[index].percent
            //                            if index < progress.count-1 {
            //                                percentArr[index+1].from = percentArr[index].to
            //                            }
            //                        }
            //                    }
            //            }
            //            VStack(alignment: .leading){
            //                Group{
            //                    ForEach(0..<friendArr.count, id: \.self) { index in
            //                        HStack{
            //                            Circle()
            //                                .fill(colorArr[index])
            //                                .frame(width: 14, height: 14)
            //                            Text(friendArr[index])
            //                            Text("\(coinArr[index])원")
            //                        }
            //                    }
            //                }
            //            }
            //        }
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

struct ProgressBar2_Previews: PreviewProvider {
    static var previews: some View {
        MultiGameProgressBar(stats: Stats(title: "", currentDate: 0, goal: 0, color: Color.blue))
//        ProgressBar2(expend: expenditure(id: "", expenditureHistory: ["식비" : ["김밥천국 3000원"]]))
    }
}
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
