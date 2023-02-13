//
//  ProgressBar.swift
//  MSG
//
//  Created by sehooon on 2023/01/18.
//

import SwiftUI

struct ProgressBar: View {
    
    var limitMoney: Float = 0
    @Binding var progress:[(tag:String, money:Float)]
    @Binding var percentArr:[(to: Float, from: Float, percent: Float)]
    @Binding var totalMoney: Float
    @Binding var selection:String
    @State private var selectMoney = 0
    @State private var selectPercent = 0
    @State private var colorArr:[Color] = [Color("Chart1"), Color("Chart2"), Color("Chart3"), Color("Chart4"), Color("Chart5"), Color("Chart6"), Color("Chart7"),Color("Chart8")]
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    
    var body: some View {
        ZStack{
            Circle()
                .fill(Color("Shadow3"))
                .frame(width: 240, height: 240)
            Circle()
                .fill(Color("Color1"))
                .frame(width: 200, height: 200)
                .blur(radius: 10)
                .shadow(color: Color("Shadow"), radius: 15, x: -5, y: -5)
                .shadow(color: Color("Shadow2"), radius: 15, x: 5, y: 5)
            Circle()
                .fill(Color("Color1"))
                .frame(width: 160, height: 160)
                .shadow(color: Color("Shadow3"), radius: 2, x: -2, y: -2)
                .shadow(color: Color("Shadow"), radius: 2, x: 2, y: 2)
            
            
            VStack{
                if selection == "" || selection == "전체"{
                    VStack{
                        Text("\(Int(totalMoney/limitMoney * 100))%")
                        Text("총 지출 금액")
                            .padding(.bottom, 4)
                        Text("\(Int(totalMoney))원")
                            .modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.title3, color: .color2))
                    }
                }else{
                    VStack{
                        Text("\(selectPercent)%")
                        Text("\(selectMoney)원")
                            .padding()
                            .modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.title3, color: .color2))
                        Text("\(selection)")
                        
                    }.modifier(TextModifier(fontWeight: .bold, fontType: FontCustomType.callout, color: .color2))
                }
            }
            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
            .onChange(of: selection) { tagName in
                var find = false
                for expenditure in progress{
                    if tagName == expenditure.tag{
                        self.selectMoney = Int(expenditure.money)
                        self.selectPercent = Int(expenditure.money / limitMoney * 100)
                        find = true
                        break
                    }
                }
                if !find{
                    selectMoney = 0
                    selectPercent = 0
                }
            }
            
            ForEach(progress.indices.reversed(),id:\.self){ index in
                Circle()
                    .trim(from: CGFloat(percentArr[index].from), to: CGFloat(min(percentArr[index].to, 1.0)))
                    .stroke(lineWidth: 28)
//                    .stroke(style: StrokeStyle(lineWidth: 27.0, lineCap: .round, lineJoin: .round))
//                    .shadow(color: selection == progress[index].tag ? .white: .clear, radius:2)
                    .frame(width: 200, height: 200)
                    .rotationEffect(Angle(degrees: 270.0))
                    .foregroundColor(colorArr[index])
                    .opacity(selection == progress[index].tag || selection == "전체" ? 1 : 0.2)
                    //.foregroundColor(selection == progress[index].tag || selection == "전체" ? colorArr[index] : .clear)
                    .onAppear{
                        withAnimation{
                            let percent = progress[index].money / limitMoney
                            percentArr[index].to = percentArr[index].from + percent
                            if index < progress.count-1 { percentArr[index+1].from = percentArr[index].to }
                        }
                    }
            }
        }
    }
}
//
//struct ProgressBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressBar()
//    }
//}
