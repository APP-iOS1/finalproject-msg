//
//  OnBoardView3.swift
//  MSG
//
//  Created by kimminho on 2023/01/18.
//

import SwiftUI

struct OnBoardView3: View {
    var body: some View {
        VStack {
            Text(" 깔끔한 차트로 나만의  지출 분석을 확인해 볼 수 있어요!")
                .modifier(TextViewModifier())
                .font(.title)
                .padding(20)
            Text("“ 현재 도전하고있는 챌린지의 소비습관과 소비패턴을  확인해보고 더 합리적인 소비를 계획해보세요!“")
                .modifier(TextViewModifier())
        }
        .padding()
    }
}

struct OnBoardView3_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardView3()
    }
}
