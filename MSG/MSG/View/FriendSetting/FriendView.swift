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
    var filterUser: [UserInfo] {
        if text.isEmpty {
            //검색을 하지 않았다면 친구목록을 보여주어야 함
            return fireStoreViewModel.myFrinedArray
        } else {
            return fireStoreViewModel.userArray.filter {$0.userName.localizedStandardContains(text)}
        }
    }
    var body: some View {
        NavigationView {
            List(filterUser,id:\.self) {value in
                FriendViewCell(user: value)
                    .frame(height: 50)
                    .listRowSeparator(.hidden)
            }
            .searchable(text: $text,
                         placement: .navigationBarDrawer,
                         prompt: "친구를 검색해보세요")
        }
        .onAppear {
            fireStoreViewModel.findUser()
            print(fireStoreViewModel.myFrinedArray)
            print(fireStoreViewModel.userArray)
        }
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendSettingView()
    }
}
