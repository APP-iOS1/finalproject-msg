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
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("매일 나를 이기는 도전!")
                            .foregroundColor(Color("Font"))
                            .font(.title)
                            .bold()
                        
                        Text("MSG, 준비됐나요? ❤️")
                            .foregroundColor(Color("Font"))
                            .font(.title)
                            .bold()
                    }
                    Spacer()
                }
                .frame(width: 330)
                .padding(.bottom, 30)
                
                Image("Screen1")
                    .resizable()
                    .frame(width:220, height: 280)
                    .cornerRadius(8)
                    .shadow(radius: 10)
                    .padding(.bottom, 130)
             
            }
            .padding(.bottom, 90)
            
            HStack(spacing: 4) {
                // MARK: Start ProgressView
                ProgressView(timerInterval: progressEnd, countsDown: false)
                    .tint(Color("Point2"))
                    .foregroundColor(.clear)
                    .frame(width: 55)
                
                // MARK: Start ProgressView
                ProgressView(timerInterval: progressEnd, countsDown: false)
                    .tint(Color("Point2"))
                    .foregroundColor(.clear)
                    .frame(width: 55)
                
                // MARK: Start ProgressView
                ProgressView(timerInterval: progressEnd, countsDown: false)
                    .tint(Color("Point2"))
                    .foregroundColor(.clear)
                    .frame(width: 55)
                
                // MARK: Start ProgressView
                ProgressView(timerInterval: progressEnd, countsDown: false)
                    .tint(Color("Point2"))
                    .foregroundColor(.clear)
                    .frame(width: 55)
                
                // MARK: Start ProgressView
                ProgressView(timerInterval: progressStart, countsDown: false)
                    .tint(Color("Point2"))
                    .foregroundColor(.clear)
                    .frame(width: 55)
            }
            .padding(.top,300)
            
            
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
