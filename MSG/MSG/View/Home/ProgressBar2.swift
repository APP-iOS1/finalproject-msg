//
//  ProgressBar2.swift
//  MSG
//
//  Created by 정소희 on 2023/01/19.
//

import SwiftUI

struct ProgressBar2: View {
    
    @State private var progress:[Float] = [25000, 20000, 45000, 13500, 20000]
    @State private var percentArr:[(to: Float, from: Float, percent: Float)] = [(0.0,0.0,0.0), (0.0,0.0,0.0),(0.0,0.0,0.0),(0.0,0.0,0.0),(0.0,0.0,0.0)]
    @State var totalMoney:Float = 123500
    @State private var colorArr:[Color] = [.red, .blue, .green, .brown, .purple]
    @State private var friendArr:[String] = ["민호", "준수", "세훈", "소희", "주희"]
    @State private var coinArr:[Int] = [130000, 120000, 220000, 75500, 120000]
    
    var body: some View {
        ZStack{
            
            Capsule()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
                .frame(width: 350,height: 240)
            
            ForEach(progress.indices.reversed(),id:\.self){ index in
                Capsule()
                    .trim(from: CGFloat(percentArr[index].from), to: CGFloat(min(percentArr[index].to, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(colorArr[index])
                    .frame(width: 350,height: 240)
                    //.rotationEffect(Angle(degrees: 270.0))
                    .onAppear{
                        withAnimation{
                            percentArr[index].percent = progress[index] / totalMoney
                            percentArr[index].to = percentArr[index].from + percentArr[index].percent
                            if index < progress.count-1 {
                                percentArr[index+1].from = percentArr[index].to
                            }
                        }
                    }
            }
            VStack(alignment: .leading){
                Group{
                    ForEach(0..<friendArr.count, id: \.self) { index in
                        HStack{
                            Circle()
                                .fill(colorArr[index])
                                .frame(width: 14, height: 14)
                            Text(friendArr[index])
                            Text("\(coinArr[index])원")
                        }
                    }
                }
            }
        }
    }
}


struct ProgressBar2_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar2()
    }
}
