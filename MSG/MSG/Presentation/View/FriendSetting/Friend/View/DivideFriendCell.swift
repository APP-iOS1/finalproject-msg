//
//  DivideFriendCell.swift
//  MSG
//
//  Created by sehooon on 2023/02/02.
//

import SwiftUI

struct DivideFriendCell: View {
    
    @State var user: Msg
    @EnvironmentObject var realtimeViewModel: RealtimeViewModel
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @ObservedObject var friendViewModel: DivideFriendViewModel
    @Binding var findFriendToggle: Bool
    @Binding var checked: Bool
    @State var listsToggle: Bool = false // 친구 체크박스 토글
    @State var friendAlert: Bool = false
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                Color("Color1")
                    .ignoresSafeArea()
                
                HStack(spacing: 0) {
                    
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
                    .aspectRatio(contentMode: .fit)
                    .frame(width: g.size.width * 0.3, height: g.size.height * 0.9)
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
                    
                    Spacer()
                    //언제 추가를 해야할까?
                    //1. 친구가 아니면 추가가 떠야함
                    if !friendViewModel.myFriendArray.contains(user.id) {
                        Button {
                            Task {
                                if let myInfo = await friendViewModel.getMyInfo() {
                                    friendViewModel.sendFriendRequest(to: user, from: myInfo)
                                    friendViewModel.uploadSendToFriend(user.id, sendToFriendArray: [])
                                }
                            }
                        } label: {
                            Text( friendViewModel.sendToFriendArray.contains(user.id) ? "대기중" : "추가" )
                                .minimumScaleFactor(0.8)
                                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                                
                        }
                        .disabled(friendViewModel.sendToFriendArray.contains(user.id))
                        .buttonStyle(.borderless)
                        .frame(width: g.size.width / 9, height: g.size.height / 13)
                        .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                        .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                        .padding(16)
                        .background(Color("Color1"))
                        .cornerRadius(10)
                        .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                        .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                        .padding(.trailing)
                    }else {
                        if !user.game.isEmpty {

                                Text("도전중")
                                .minimumScaleFactor(0.8)
                            .frame(width: g.size.width / 9, height: g.size.height / 13)
                            .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                            .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                            .padding(16)
                            .background(Color("Color1"))
                            .cornerRadius(10)
                            .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
                            .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
                            .padding(.trailing)
                        }
                    }
                }
                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                .buttonStyle(.bordered)
                .frame(alignment: .leading)
            }
        }
    }
}

//struct DivideFriendCell: PreviewProvider {
//    static var previews: some View {
//        FriendView(findFriendToggle: .constant(true))
//    }
//}

//var actionButtonTitle: String {
//    return friend.isCurrentUser ? "대결 신청" : "대결 중"
//}
