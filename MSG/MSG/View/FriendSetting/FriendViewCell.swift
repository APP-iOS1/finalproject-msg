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
    @Binding var findFriendToggle: Bool
    @Binding var checked: Bool
    @State var listsToggle: Bool = false // 친구 체크박스 토글
    
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
                
                if findFriendToggle {
                    Image(systemName: listsToggle ? "checkmark.square.fill" : "square")
                        .onTapGesture {
                            
                            self.listsToggle.toggle()
                            
                            if listsToggle {
                                realtimeViewModel.inviteFriendIdArray.append(user.id)
                                realtimeViewModel.inviteFriendArray.append(user)
                                print(realtimeViewModel.inviteFriendArray)
                                print(realtimeViewModel.inviteFriendArray.firstIndex(of: user))
                                self.checked = true
                            } else {
                                //                                friendViewModel
                                realtimeViewModel.inviteFriendArray.remove(at: realtimeViewModel.inviteFriendArray.firstIndex(of: user)!)
                                print(realtimeViewModel.inviteFriendArray)
                                if realtimeViewModel.inviteFriendArray.isEmpty {
                                    self.checked = false
                                }
                            }
                            
                        }
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

//var actionButtonTitle: String {
//    return friend.isCurrentUser ? "대결 신청" : "대결 중"
//}
