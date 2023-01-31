//
//  OnBoardView2.swift
//  MSG
//
//  Created by kimminho on 2023/01/18.
//

import SwiftUI

struct OnBoardView5: View {
    
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
                            Text("매일 나를 이기는 도전!")
                                .font(.title)
                                .bold()
                            
                            Text("MSG, 준비됐나요? ❤️")
                                .font(.title)
                                .bold()
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
                        
//                        Image("Screen1")
//                            .resizable()
//                            .frame(width:220, height: 280)
//                            .cornerRadius(8)
//                            .padding(.bottom, 130)
                    }
                }
                .padding(.bottom, 90)
                
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
                    ProgressView(timerInterval: progressEnd, countsDown: false)
                        .tint(Color("Color2"))
                        .foregroundColor(.clear)
                        .frame(width: 55)
                    
                    // MARK: Start ProgressView
                    ProgressView(timerInterval: progressStart, countsDown: false)
                        .tint(Color("Color2"))
                        .foregroundColor(.clear)
                        .frame(width: 55)
                }
                .padding(.top,300)
            }
            .foregroundColor(Color("Color2"))
        }
//        VStack(spacing: 48.0) {
//
//            Spacer()
//            Text("매일 매일 나를 이기는 도전!")
//                .modifier(TextViewModifier())
//                .font(.title2)
//            Text("MSG에서 시작해보세요!")
//                .modifier(TextViewModifier())
//                .font(.title2)
//            Spacer()
//
//
//
//        }
//        .padding(16.0 * 2.0)
    }
}

struct OnBoardView5_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardView5()
    }
}
