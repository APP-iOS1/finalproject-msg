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
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("내가 도전했던")
                            .foregroundColor(Color("Font"))
                            .font(.title)
                            .bold()
                        
                        Text("챌린지를 확인해볼까요? 📖")
                            .foregroundColor(Color("Font"))
                            .font(.title)
                            .bold()
                    }
                    Spacer()
                }
                .frame(width: 330)
                .padding(.bottom, 30)
                
                Image("Screen2")
                    .resizable()
                    .frame(width:220, height: 280)
                    .cornerRadius(8)
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
                ProgressView(timerInterval: progressStart, countsDown: false)
                    .tint(Color("Point2"))
                    .foregroundColor(.clear)
                    .frame(width: 55)
                
                // MARK: Ready ProgressView
                ProgressView(value: progressReady)
                    .frame(width: 55)
                    .padding(.bottom, 19)
            }
            .padding(.top,300)
            
            
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
