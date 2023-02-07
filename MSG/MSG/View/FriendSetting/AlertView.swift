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
                    }
                    else {
                   
                            List(realtimeViewModel.user, id: \.self) { user in
                                HStack {
                                    VStack {
                                        if user.profileImage.isEmpty{
                                            Image(systemName: "person")
                                                .font(.largeTitle)
                                        }else{
                                            AsyncImage(url: URL(string: user.profileImage)) { Image in
                                                Image
                                                    .resizable()
                                            } placeholder: {
                                                Image(systemName: "person")
                                                    .font(.largeTitle)
                                            }
                                        }
                                    }
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: g.size.width / 9.375, height: g.size.height / 14.5575)
                                    .clipShape(Circle())
                                    .padding(4)
                                    .foregroundColor(Color("Color2"))
                                    .background(
                                        Circle()
                                            .fill(
                                                .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                                .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                            )
                                            .foregroundColor(Color("Color1")))
                                    
                                    Text(user.nickName)
                                        .padding(.leading)
                                    
                                    Spacer()
                                    Button {
                                        fireStoreViewModel.addUserInfo(user: user)
                                        if let myInfo = realtimeViewModel.myInfo {
                                            fireStoreViewModel.addUserInfo2(user: user, myInfo: myInfo)
                                            realtimeViewModel.acceptAddFriend(friend: user)
                                            Task{ await fireStoreViewModel.deleteWaitingFriend(user.id)}
                                        }
                                        
                                    } label: {
                                        Text("확인")
                                    }
                                    .buttonStyle(.borderless)
                                    .frame(width: g.size.width / 9, height: g.size.height / 20)
                                    .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                                    .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                                    .padding(5)
                                    .background(Color("Color1"))
                                    .cornerRadius(10)
                                    .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                                    .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                                    .padding(.trailing)
                                }
                                .frame(height: g.size.height / 9)
                                .padding(.leading, g.size.width / 39)
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
