//
//  AlertView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct AlertView: View {
    @State private var testArray: [String] = ["닉네임여섯글","김기분굿","김뽀삐"]
    @EnvironmentObject var realtimeViewModel: PostitStore
    var body: some View {
        VStack {
            if realtimeViewModel.user.isEmpty {
                Spacer()
                Text("도착한 알람이 없어요~")
                    .font(.title)
                Spacer()
            } else {
                List(realtimeViewModel.user, id:\.self) { user in
                    HStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle().inset(by: 5))
                            .frame(width:30, height: 30)
                        Text(user.userName)
                            .font(.title3)
                        if user.isFight {
                            Text("님의 대결 신청")
                        }
                        else {
                            Text("님의 친구 신청")
                        }
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
            }

        }
        .onAppear {
            realtimeViewModel.read()
            print(realtimeViewModel.user)
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
