//
//  CheckAddFriendViewModel.swift
//  MSG
//
//  Created by 김민호 on 2023/02/13.
//

import Foundation

protocol CheckAddFriendInput {
    func myInfo() async throws -> Msg?
    func addBothWithFriend(user: Msg, me: Msg)
    func deleteWaitingFriend(userId: String) async
    
    func acceptAddFriend(friend: Msg)
}

class CheckAddFriendViewModel: ObservableObject, CheckAddFriendInput {
    let addFriendUseCase = AddFriendUseCase(repo: AddFriendRepositoryImpl(dataSourceRealTimeDB: Real(), dataSourceFireBase: FirebaseService()))
    
    func myInfo() async throws -> Msg? {
        if let data = try await addFriendUseCase.myInfo() {
            return data
        }
        return nil
    }
    
    func addBothWithFriend(user: Msg, me: Msg) {
        addFriendUseCase.addBothWithFriend(user: user, me: me)
    }
    
    func deleteWaitingFriend(userId: String) async {
        await addFriendUseCase.deleteWaitingFriend(userId: userId)
    }
    
    func acceptAddFriend(friend: Msg) {
        addFriendUseCase.acceptAddFriend(friend: friend)
    }
}
