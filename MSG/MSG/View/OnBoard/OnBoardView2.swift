//
//  OnBoardView5.swift
//  MSG
//
//  Created by kimminho on 2023/01/18.
//

import SwiftUI

struct OnBoardView2: View {
    
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
                        Text("친구들과 함께")
                            .foregroundColor(Color("Font"))
                            .font(.title)
                            .bold()
                        
                        Text("챌린지에 도전하세요 💸")
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
                ProgressView(timerInterval: progressStart, countsDown: false)
                    .tint(Color("Point2"))
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
            }
            .padding(.top,300)
            
            
        }
//        VStack {
//            Image("logo")
//                .resizable()
//                .scaledToFit()
//            Text("소비습관 목표를 어떻게 만들어 가고있는지 한눈에 살펴보세요!")
//                .modifier(TextViewModifier())
//                .font(.title2)
//                .padding()
//            Text("“ 나는 매일 어떻게 소비를 하며 원하는 소비습관 목표에 달성하고있는지,  함께 참여하는 사람들이 매일 얼마만큼 자신이 원하는 소비습관 목표를  달성하고 있는지 한눈에 살펴보세요!  “ ")
//                .modifier(TextViewModifier())
//        }
//        .padding()
    }
}

struct OnBoardView2_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardView2()
    }
}
