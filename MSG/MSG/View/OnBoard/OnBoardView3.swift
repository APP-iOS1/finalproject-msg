//
//  OnBoardView3.swift
//  MSG
//
//  Created by kimminho on 2023/01/18.
//

import SwiftUI

struct OnBoardView3: View {
    
    // MARK: Ready ProgressView
    var progressReady : Double = 0.0
    
    // MARK: Start ProgressView
    var progressStart: ClosedRange<Date> {
        let start = Date()
        let end = start.addingTimeInterval(3)
        return start...end
    }
    
    // MARK: End ProgressView
    var progressEnd: ClosedRange<Date> {
        let start = Date()
        let end = start.addingTimeInterval(0)
        return start...end
    }
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("Color1")
                    .ignoresSafeArea()
                VStack{
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("깔끔한 차트로 나만의 지출을")
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title, color: FontCustomColor.color2))
                                
                                Text("분석해보아요 🧐")
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title, color: FontCustomColor.color2))
                            }
                            Spacer()
                        }
                        .frame(width: g.size.width / 1.1)
                        .padding(.top, 5)
//                        .offset(y: g.size.height / -10)
                        .padding(.bottom)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("Color1"),
                                        lineWidth: 4)
                                .shadow(color: Color("Shadow"),
                                        radius: 3, x: 5, y: 5)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color("Shadow3"), radius: 2, x: -2, y: -2)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 15))
                                .background(Color("Color1"))
                                .cornerRadius(20)
                                .frame(width: g.size.width / 1.04, height: g.size.height / 1.40)
                                .offset(y: g.size.height / -48.5)
                            
                            Image("Screen3")
                                .resizable()
                                .frame(width: g.size.width / 1.1 , height: g.size.height / 1.7)
                                .cornerRadius(20)
                                .offset(y: g.size.height / -150)
                        }
                    }
                    .padding(.bottom, 110)
                    
                    HStack(spacing: 4) {
                        // MARK: Start ProgressView
                        ProgressView(timerInterval: progressEnd, countsDown: false)
                            .tint(Color("Color2"))
                            .foregroundColor(.clear)
                            .frame(width: 55)
                        
                        // MARK: Start ProgressView
                        ProgressView(timerInterval: progressEnd, countsDown: false)
                            .tint(Color("Color2"))
                            .foregroundColor(.clear)
                            .frame(width: 55)
                        
                        // MARK: Start ProgressView
                        ProgressView(timerInterval: progressStart, countsDown: false)
                            .tint(Color("Color2"))
                            .foregroundColor(.clear)
                            .frame(width: 55)
                        
                        // MARK: Ready ProgressView
                        ProgressView(value: progressReady)
                            .frame(width: 55)
                            .padding(.bottom, 19)
                        
                        // MARK: Ready ProgressView
                        ProgressView(value: progressReady)
                            .frame(width: 55)
                            .padding(.bottom, 19)
                    }
                    .padding(.top, -120)
                }
                .padding(.top)
            }
        }
//        VStack {
//            Text(" 깔끔한 차트로 나만의  지출 분석을 확인해 볼 수 있어요!")
//                .modifier(TextViewModifier())
//                .font(.title)
//                .padding(20)
//            Text("“ 현재 도전하고있는 챌린지의 소비습관과 소비패턴을  확인해보고 더 합리적인 소비를 계획해보세요!“")
//                .modifier(TextViewModifier())
//        }
//        .padding()
    }
}

struct OnBoardView3_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardView3()
    }
}
