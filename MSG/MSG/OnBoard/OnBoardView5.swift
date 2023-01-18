//
//  OnBoardView2.swift
//  MSG
//
//  Created by kimminho on 2023/01/18.
//

import SwiftUI

struct OnBoardView5: View {
    @Binding var isFirstLaunching: Bool
    var body: some View {
        VStack(spacing: 48.0) {
            
            Spacer()
            Text("매일 매일 나를 이기는 도전!")
                .modifier(TextViewModifier())
                .font(.title2)
            Text("MSG에서 시작해보세요!")
                .modifier(TextViewModifier())
                .font(.title2)
            Spacer()

            Button {
                isFirstLaunching = false
            } label: {
                Text("로그인 하러가기")
                    .modifier(TextViewModifier())
                    .font(.headline)
                    .frame(maxWidth: .infinity, maxHeight: 55.0, alignment: .center)
            }
            .background(Color("Point2"))
            .buttonStyle(.bordered)
            .padding(.bottom, 10)

        }
        .padding(16.0 * 2.0)
    }
}

struct OnBoardView2_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardView5(isFirstLaunching: .constant(true))
    }
}
