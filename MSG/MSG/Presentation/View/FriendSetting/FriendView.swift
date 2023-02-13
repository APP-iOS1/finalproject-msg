//
//  FriendView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct FriendView: View {
    
    @StateObject var friendViewModel = FriendViewModel()
    @Binding var findFriendToggle: Bool
    @State var checked = false
    
}

extension FriendView {
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("Color1")
                    .ignoresSafeArea()
                
                VStack {
                            if friendViewModel.myFrinedArray.isEmpty {
                                VStack{
                                    Text("현재 추가되어있는 친구가 없습니다.")
                                        .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                                        .padding(.bottom, 1)
                                      
                                    Text("친구목록에서 친구를 추가해주세요!")
                                        .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                                       
                                } .frame(width: g.size.width / 1.04, height: g.size.height / 1)
                            } else if friendViewModel.notGamePlayFriend.isEmpty {
                                VStack{
                                    
                                    Text("현재 모든 친구가 도전중입니다.")
                                        .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                                        .frame(width: g.size.width / 1.04, height: g.size.height / 1)
                                }
                            } else {
                                
                                ForEach(friendViewModel.notGamePlayFriend) { user in
                                    FriendViewCell(user: user, friendViewModel: friendViewModel,findFriendToggle: $findFriendToggle,checked: $checked)
                                        .frame(height: 60)
                                        .listRowBackground(Color("Color1"))
                                        .listRowSeparator(.hidden)
                                }
                            }
                        
                    }
                }
            }
            .onAppear {
                Task {
                    await friendViewModel.getMyFriendArray()
                    try await friendViewModel.getMyFriendForNotGame()
                }
                print("== FriendVeiw onAppear ==")
                
            }
            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
        }
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView(findFriendToggle: .constant(false))
    }
}
