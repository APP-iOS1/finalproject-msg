//
//  AlertView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct AlertView: View {
    @State private var testArray: [String] = ["닉네임여섯글","김기분굿","김뽀삐"]
    var body: some View {
        List(testArray, id:\.self) {value in
            HStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle().inset(by: 5))
                    .frame(width:30, height: 30)
                Text(value)
                    .font(.title3)
                Text("님의 친구 신청")
                Spacer()
                Button {
                    //
                } label: {
                    Text("확인")
                        .foregroundColor(Color("Font"))
                }
                .buttonStyle(.bordered)
                .background(Color("Point2"))

            }
//            .listRowSeparator(.hidden)
        }
        .listStyle(.inset)
        .padding(20)
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        FriendSettingView()
    }
}
