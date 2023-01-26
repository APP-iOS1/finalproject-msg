//
//  ProgressBar.swift
//  MSG
//
//  Created by sehooon on 2023/01/18.
//

import SwiftUI

struct ProgressBar: View {
    
    @State private var progress:[Float] = [25000, 40000, 45000, 13500, 12000, 30000, 34000, 15000]
    @State private var percentArr:[(to: Float, from: Float, percent: Float)] = [(0.0,0.0,0.0), (0.0,0.0,0.0),(0.0,0.0,0.0),(0.0,0.0,0.0),(0.0,0.0,0.0), (0.0,0.0,0.0),(0.0,0.0,0.0),(0.0,0.0,0.0)]
    @State var totalMoney: Float = 214500
    @State private var colorArr:[Color] = [Color("Chart1"), Color("Chart2"), Color("Chart3"), Color("Chart4"), Color("Chart5"), Color("Chart6"), Color("Chart7"),Color("Chart8")]
    
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
                .frame(width: 250,height: 250)
            Text("총액: \(totalMoney)")
            ForEach(progress.indices.reversed(),id:\.self){ index in
                Circle()
                    .trim(from: CGFloat(percentArr[index].from), to: CGFloat(min(percentArr[index].to, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(colorArr[index])
                    .frame(width: 250,height: 250)
                    .rotationEffect(Angle(degrees: 270.0))
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
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar()
    }
}
