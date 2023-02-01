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
                            .modifier(TextTitleBold())
                    } else {
                        List(realtimeViewModel.user, id: \.self) { user in
                            HStack {
                                if user.profileImage.isEmpty{
                                    Image("logo")
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle().inset(by: 5))
                                        .frame(width:90)
                                }else{
                                    AsyncImage(url: URL(string: user.profileImage)) { Image in
                                        Image
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle().inset(by: 5))
                                            .frame(width:90)
                                    } placeholder: {
                                        
                                    }
                                }
                                Text(user.nickName)
                                    .modifier(TextViewModifier(color: "Color2"))
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
                                        .modifier(TextViewModifier(color: "Color2"))
                                        .frame(width: g.size.width / 8, height: g.size.height / 34)
                                        .shadow(color: Color("Shadow3"), radius: 8, x: -9, y: -9)
                                        .shadow(color: Color("Shadow"), radius: 8, x: 9, y: 9)
                                        .padding(20)
                                        .background(Color("Color1"))
                                        .cornerRadius(20)
                                }
                            }
                            .listRowBackground(Color("Color1"))
                            .listRowSeparator(.hidden)
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                    }
                }
                .modifier(TextViewModifier(color: "Color2"))
            }
            .onAppear {
                realtimeViewModel.fetchFriendRequest()
                print(realtimeViewModel.user)
            }
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}
