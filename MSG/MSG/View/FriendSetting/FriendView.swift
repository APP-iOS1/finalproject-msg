//
//  FriendView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct FriendView: View {
    @StateObject var fireStoreViewModel: FireStoreViewModel
    @State private var text: String = ""
    @State private var testArray: [String] = ["김민호","김철수","김뽀삐"]

    var filterUser: [Msg] {
        if text.isEmpty {
            //검색을 하지 않았다면 친구목록을 보여주어야 함
            return fireStoreViewModel.myFrinedArray
        } else {
            return fireStoreViewModel.userArray.filter {$0.nickName.localizedStandardContains(text)}
        }
    }
    
    var body: some View {
        
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("친구 찾기", text: $text)
                }
                .padding(.vertical)
                .padding(.horizontal)
                
                ScrollView {
                    ForEach(filterUser) { user in
                        FriendViewCell(user: user)
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
            fireStoreViewModel.findUser()
            print(fireStoreViewModel.myFrinedArray)
            print(fireStoreViewModel.userArray)
        }
        .foregroundColor(Color("Font"))
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView(fireStoreViewModel: FireStoreViewModel())
    }
}
