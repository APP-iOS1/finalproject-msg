//
//  OnBoardView1.swift
//  MSG
//
//  Created by kimminho on 2023/01/18.
//

import SwiftUI

struct OnBoardView1: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person")
                    .frame(width:130, height: 130)
                    .background(.red)
                Divider()
                    .padding(20)
                Image(systemName: "person")
                    .frame(width:130, height: 130)
                    .background(.red)
            }.frame(height:150)
            Text("함께 도전하는 가계부 챌린지!")
                .modifier(TextViewModifier())
                .padding(15)
            Text("“ 나를 위한 챌린지 또는  여러 사람들과 함께 챌린지에  목표를 설정하여,  소비습관을 재미있게  만들어가요!  “ ")
                .modifier(TextViewModifier())
        }
    }
}

struct OnBoardView1_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardView1()
    }
}
