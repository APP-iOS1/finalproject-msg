//
//  OnBoardView5.swift
//  MSG
//
//  Created by kimminho on 2023/01/18.
//

import SwiftUI

struct OnBoardView2: View {
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
            Text("소비습관 목표를 어떻게 만들어 가고있는지 한눈에 살펴보세요!")
                .modifier(TextViewModifier())
                .font(.title2)
                .padding()
            Text("“ 나는 매일 어떻게 소비를 하며 원하는 소비습관 목표에 달성하고있는지,  함께 참여하는 사람들이 매일 얼마만큼 자신이 원하는 소비습관 목표를  달성하고 있는지 한눈에 살펴보세요!  “ ")
                .modifier(TextViewModifier())
        }
        .padding()
    }
}

struct OnBoardView5_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardView2()
    }
}
