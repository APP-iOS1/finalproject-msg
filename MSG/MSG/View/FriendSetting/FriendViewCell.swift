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
    @ObservedObject var friendViewModel: FriendViewModel
    
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
                
                if !friendViewModel.myFrinedArray.contains(user) {
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
                }
            }
            .foregroundColor(Color("Font"))
            .buttonStyle(.bordered)
            .frame(alignment: .leading)
        }
    }
}

struct FriendViewCell_Previews: PreviewProvider {
    static var previews: some View {
        FriendView(findFriendToggle: .constant(true))
    }
}
