//
//  OnBoardView4.swift
//  MSG
//
//  Created by kimminho on 2023/01/18.
//

import SwiftUI

struct OnBoardView4: View {
    
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
                Color("Color1").ignoresSafeArea()
                VStack{
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("챌린지에 도전하며")
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title, color: FontCustomColor.color2))
                                
                                Text("소비습관 기록을 쌓아가요! 📖")
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title, color: FontCustomColor.color2))
                            }
                            Spacer()
                        }
                        .frame(width: g.size.width / 1.1)
                        .padding(.top, 5)
                        //                    .offset(y: g.size.height / -10)
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
                            
                            Image("Screen4")
                                .resizable()
                                .frame(width: 341 , height: 427)
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
                    }
                    .padding(.top, -120)
                }
                .padding(.top)
            }
        }
//        VStack {
//            Text("내가 도전했던 챌린지 이력을 볼 수 있어요!")
//                .font(.title)
//                .modifier(TextViewModifier())
//                .padding(20)
//            Text("“ 꾸준한 챌린지 성공을 통해 나를 움직여보세요!“")
//                .modifier(TextViewModifier())
//        }
//        .padding()
    }
}

struct OnBoardView4_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardView4()
    }
}
