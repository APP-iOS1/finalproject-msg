//
//  OnBoardView4.swift
//  MSG
//
//  Created by kimminho on 2023/01/18.
//

import SwiftUI

struct OnBoardView4: View {
    var body: some View {
        VStack {
            Text("내가 도전했던 챌린지 이력을 볼 수 있어요!")
                .font(.title)
                .modifier(TextViewModifier())
                .padding(20)
            Text("“ 꾸준한 챌린지 성공을 통해 나를 움직여보세요!“")
                .modifier(TextViewModifier())
        }
        .padding()
    }
}

struct OnBoardView4_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardView4()
    }
}
