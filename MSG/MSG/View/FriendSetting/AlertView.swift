//
//  AlertView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct AlertView: View {
    
    @State private var testArray: [String] = ["닉네임여섯글","김기분굿","김뽀삐"]
    @EnvironmentObject var realtimeViewModel: RealtimeViewModel
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    
    var body: some View {
        
        GeometryReader { g in
        ZStack {
            Color("Color1")
                .ignoresSafeArea()
            VStack {
                if realtimeViewModel.user.isEmpty {
                    Text("알람을 모두 확인했습니다.")
                } else {
                    List(realtimeViewModel.user, id: \.self) { user in
                        HStack {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle().inset(by: 5))
                                .frame(width: g.size.width / 10, height: g.size.height / 18.5)
                                .padding(25)
                                .foregroundColor(Color("Color2"))
                                .background(
                                    Circle()
                                        .fill(
                                            .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                            .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                        )
                                        .foregroundColor(Color("Color1")))
                            Text(user.nickName)
                                .font(.title3)
                            if let userFriend = user.friend {
                                if userFriend.contains(realtimeViewModel.myInfo!.id) {
                                    Text("님의 대결 신청")
                                } else {
                                    Text("님의 친구 신청")
                                }
                            }
                            Spacer()
                            Button {
                                fireStoreViewModel.addUserInfo(user: user)
                                if let myInfo = realtimeViewModel.myInfo {
                                    fireStoreViewModel.addUserInfo2(user: user, myInfo: myInfo)
                                    realtimeViewModel.acceptAddFriend(friend: user)
                                }
                                
                            } label: {
                                Text("확인")
                                    .frame(width: g.size.width / 8, height: g.size.height / 34)
                                    .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                    .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                    .padding(20)
                                    .background(Color("Color1"))
                                    .cornerRadius(20)
                            }
                            .buttonStyle(.bordered)
                            .background(Color("Point2"))
                        }
                        .listRowBackground(Color("Background"))
                        .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                }
            }
            .foregroundColor(Color("Color2"))
        }
    }
        .onAppear {
            realtimeViewModel.fetchFriendRequest()
            print(realtimeViewModel.user)
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}
