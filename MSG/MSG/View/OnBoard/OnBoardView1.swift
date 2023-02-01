//
//  OnBoardView1.swift
//  MSG
//
//  Created by kimminho on 2023/01/18.
//

import SwiftUI

struct OnBoardView1: View {
    
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
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("내 소비 습관을")
                                .modifier(TextTitleBold())
                            
                            Text("한 화면에서 확인하세요 👀")
                                .modifier(TextTitleBold())
                        }
                        Spacer()
                    }
                    .frame(width: g.size.width / 1.1)
                    .offset(y: g.size.height / -10)
                    
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
                            .frame(width: g.size.width / 1.1, height: g.size.height / 2.8)
                            .offset(y: g.size.height / -10)
                        //                    Image("Screen1")
                        //                        .resizable()
                        //                        .frame(width:220, height: 280)
                        //                        .cornerRadius(8)
                        //                        .padding(.bottom, 130)
                    }
                }
                .padding(.bottom, 90)
                
                HStack(spacing: 4) {
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
                    
                    // MARK: Ready ProgressView
                    ProgressView(value: progressReady)
                        .frame(width: 55)
                        .padding(.bottom, 19)
                    
                    // MARK: Ready ProgressView
                    ProgressView(value: progressReady)
                        .frame(width: 55)
                        .padding(.bottom, 19)
                }
                .padding(.top,300)
            }
        }
        
//        VStack {
//            HStack {
//                Image(systemName: "person")
//                    .frame(width:130, height: 130)
//                    .background(.red)
//                Divider()
//                    .padding(20)
//                Image(systemName: "person")
//                    .frame(width:130, height: 130)
//                    .background(.red)
//            }.frame(height:150)
//            Text("함께 도전하는 가계부 챌린지!")
//                .modifier(TextViewModifier())
//                .padding(15)
//            Text("“ 나를 위한 챌린지 또는  여러 사람들과 함께 챌린지에  목표를 설정하여,  소비습관을 재미있게  만들어가요!  “ ")
//                .modifier(TextViewModifier())
//        }
    }
}

struct OnBoardView1_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardView1()
    }
}
