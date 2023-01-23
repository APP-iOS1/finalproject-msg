//
//  FriendViewCell.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct FriendViewCell: View {
    
    @State var user: Msg
    @EnvironmentObject var realtimeViewModel: RealtimeViewModel
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            HStack(spacing: 0) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(height: 60)
                Text(user.nickName)
                Spacer()
                Button {
                    if let myInfo = realtimeViewModel.myInfo {
                        realtimeViewModel.sendFriendRequest(to: user, from: myInfo, isFriend: true)
                        print(myInfo)
                    }
                } label: {
                    Text("추가")
                        .foregroundColor(Color("Background"))
                }
                .background(Color("Point2"))
                .cornerRadius(5)
                .padding(.trailing)
                
                Button {
                    if user.game.isEmpty {
                        
                    }
                } label: {
                    user.game.isEmpty ? Text("대결 신청") : Text("대결 중")
                }
                .foregroundColor(Color("Background"))
                .background(user.game.isEmpty ? Color("Point2") : .gray)
                .cornerRadius(5)
                .padding(.trailing)
                .disabled(!user.game.isEmpty)
            }
            .foregroundColor(Color("Font"))
            .buttonStyle(.bordered)
            .frame(alignment: .leading)
        }
    }
}

struct FriendViewCell_Previews: PreviewProvider {
    static var previews: some View {
        FriendView()
    }
}

//var actionButtonTitle: String {
//    return friend.isCurrentUser ? "대결 신청" : "대결 중"
//}
