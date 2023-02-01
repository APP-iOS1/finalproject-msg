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
        
        GeometryReader { g in
            ZStack {
                Color("Color1")
                    .ignoresSafeArea()
                
                VStack {
                    if !findFriendToggle {
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
                    }
                    
                    ScrollView {
                        if !findFriendToggle {
                            ForEach(friendViewModel.searchUserArray) { user in
                                FriendViewCell(user: user, friendViewModel: friendViewModel,findFriendToggle: $findFriendToggle,checked: $checked)
                                    .frame(height: 60)
                                    .listRowBackground(Color("Color1"))
                                    .listRowSeparator(.hidden)
                            }
                        }
                        else {
                            ForEach(friendViewModel.notGamePlayFriend) { user in
                                FriendViewCell(user: user, friendViewModel: friendViewModel,findFriendToggle: $findFriendToggle,checked: $checked)
                                    .frame(height: 60)
                                    .listRowBackground(Color("Color1"))
                                    .listRowSeparator(.hidden)
                            }
                        }
                    }
                    if findFriendToggle {
                        
                        VStack {
                            Button {
                                findFriendToggle = false
                            } label: {
                                Text("추가하기")
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
            .modifier(TextViewModifier(color: "Color2"))
        }
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView(findFriendToggle: .constant(false))
    }
}
