//
//  DivideFriendView.swift
//  MSG
//
//  Created by sehooon on 2023/02/02.
//

import SwiftUI

struct DivideFriendView: View {
    @StateObject var friendViewModel = DivideFriendViewModel()
    @Binding var findFriendToggle: Bool
    @State var checked = false
}

extension DivideFriendView {
    
    // 1. baseUserArray
    // 2. SearchUserArray
    // 3. MyFriendArray
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("Color1")
                    .ignoresSafeArea()
                VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("Color1"),
                                        lineWidth: 4)
                                .shadow(color: Color("Shadow"),
                                        radius: 3, x: 5, y: 5)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color("Shadow3"), radius: 2, x: -2, y: -2)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 15))
                                .background(Color("Color1"))
                                .cornerRadius(20)
                                .frame(width: g.size.width / 1.04, height: g.size.height / 12)
                            HStack {
                                Image(systemName: "magnifyingglass")
                                TextField("친구 찾기", text: $friendViewModel.text)
                            }
                            .padding(.vertical)
                            .padding(.horizontal)
                        }
                    
                    ScrollView {
                            ForEach(friendViewModel.baseUserArray) { user in
                                DivideFriendCell(user: user, friendViewModel: friendViewModel,findFriendToggle: $findFriendToggle, checked: $checked)
                                    .frame(height: 60)
                                    .listRowBackground(Color("Color1"))
                                    .listRowSeparator(.hidden)
                            }
                    }
                }
            }
            .onAppear {
                Task {
                    friendViewModel.subscribe()
                    print("View: 현재 send입니다:",friendViewModel.sendToFriendArray)
                    try await friendViewModel.getMyFriend()
                    friendViewModel.baseUserArray = await friendViewModel.makeProfile(friendViewModel.myFriendArray) ?? []
//                    await friendViewModel.findUser1(text: fireStoreViewModel.myFrinedArray)
                }
                print("== FriendVeiw onAppear ==")
                
            }
            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
        }
        .onTapGesture {
            self.endTextEditing()
        }
    }
}

struct DivideFriendView_Previews: PreviewProvider {
    static var previews: some View {
        DivideFriendView(findFriendToggle: .constant(false))
    }
}
