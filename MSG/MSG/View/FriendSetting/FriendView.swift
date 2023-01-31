//
//  FriendView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct FriendView: View {
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @EnvironmentObject var realtimeViewModel: RealtimeViewModel
    @StateObject var friendViewModel = FriendViewModel()
    @Binding var findFriendToggle: Bool
    @State var checked = false
    
}

extension FriendView {
    var body: some View {
        
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                if !findFriendToggle {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("친구 찾기", text: $friendViewModel.text)
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                }
                
                ScrollView {
                    if !findFriendToggle {
                        ForEach(friendViewModel.myFrinedArray) { user in
                                FriendViewCell(user: user, friendViewModel: friendViewModel,findFriendToggle: $findFriendToggle,checked: $checked)
                                    .frame(height: 60)
                                    .listRowBackground(Color("Background"))
                                    .listRowSeparator(.hidden)
                        }
                    }
                    else {
                        ForEach(friendViewModel.notGamePlayFriend) { user in
                                FriendViewCell(user: user, friendViewModel: friendViewModel,findFriendToggle: $findFriendToggle,checked: $checked)
                                    .frame(height: 60)
                                    .listRowBackground(Color("Background"))
                                    .listRowSeparator(.hidden)
                        }
                    }
                }
                if findFriendToggle {
                    
                    VStack {
                        Button {
                            findFriendToggle = false
                        } label: {
                            Text("초대하기")
                            .foregroundColor(Color("Background"))
                        }
                        .background(checked ? Color("Point2") : Color("Point1"))
                        .cornerRadius(5)
                        .padding(.trailing)
                        .disabled(!checked)

                    }
                }
//                List(filterUser,id:\.self) {value in
//                    FriendViewCell(user: value)
//                        .frame(height: 50)
//                        .listRowBackground(Color("Background"))
//                        .listRowSeparator(.hidden)
//                }
//                .scrollContentBackground(.hidden)
//                .listStyle(.plain)
            }
        }
        .onAppear {
            Task {
             await friendViewModel.findFriend()
                friendViewModel.findUser1(text: fireStoreViewModel.myFrinedArray)
            }
            
        }
        .modifier(TextViewModifier(color: "Font"))
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView(findFriendToggle: .constant(false))
    }
}
