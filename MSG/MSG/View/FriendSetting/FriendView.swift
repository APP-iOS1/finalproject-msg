//
//  FriendView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct FriendView: View {
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @StateObject var friendViewModel = FriendViewModel()
    
}

extension FriendView {
    var body: some View {
        
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("친구 찾기", text: $friendViewModel.text)
                }
                .padding(.vertical)
                .padding(.horizontal)
                
                ScrollView {
                    ForEach(friendViewModel.searchUserArray) { user in
                        FriendViewCell(user: user, friendViewModel: friendViewModel)
                            .frame(height: 60)
                            .listRowBackground(Color("Background"))
                            .listRowSeparator(.hidden)
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
            friendViewModel.findFriend()
        }
        .foregroundColor(Color("Font"))
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView()
    }
}
