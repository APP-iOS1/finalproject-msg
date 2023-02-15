//
//  FriendCellView.swift
//  MSG
//
//  Created by sehooon on 2023/02/14.
//

import SwiftUI

struct ChallengeFriendCellView: View{
    @ObservedObject var gameSettingViewModel: GameSettingViewModel
    @State var friend: Msg
    @State var parentScreen: GeometryProxy
    var body: some View{
        HStack{
            VStack {
                if friend.profileImage.isEmpty{
                    Image(systemName: "person")
                        .font(.largeTitle)
                }else{
                    AsyncImage(url: URL(string: friend.profileImage)) { Image in
                        Image
                            .resizable()
                    } placeholder: {
                        Image(systemName: "person")
                            .font(.largeTitle)
                    }
                }
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: parentScreen.size.width / 4, height: parentScreen.size.height / 11)
            .clipShape(Circle())
            .foregroundColor(Color("Color2"))
            .background(
                Circle()
                    .fill(
                        .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                        .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                    )
                    .foregroundColor(Color("Color1")))
            Text(friend.nickName)
            Spacer()
            Button {
                gameSettingViewModel.checkFriend(friend)
            } label: {
                Image(systemName: gameSettingViewModel.isCheked(friend) ? "checkmark.square.fill" : "square")
            }
        }
        .frame(alignment: .leading)
    }
    
}
