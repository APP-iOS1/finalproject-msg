//
//  FriendViewCell.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct FriendViewCell: View {
    @State var user: Msg
    @StateObject var realtimeViewModel = PostitStore()
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .clipShape(Circle().inset(by: 5))
                .frame(width:50, height: 45)
            Text(user.nickName)
            Spacer()
            Button {
                //
                if let myInfo = fireStoreViewModel.myInfo {
                    realtimeViewModel.sendFriendRequest(to: user, from: myInfo, isFriend: true)
                }
            } label: {
                Text("추가")
                    .foregroundColor(Color("Font"))
            }
            .background(Color("Point2"))
            .cornerRadius(5)
//            .opacity(친구일때만 표시 아닐때는 미표시)
        }
        .buttonStyle(.bordered)
    }
}

struct FriendViewCell_Previews: PreviewProvider {
    static var previews: some View {
        FriendView(fireStoreViewModel: FireStoreViewModel())
    }
}
