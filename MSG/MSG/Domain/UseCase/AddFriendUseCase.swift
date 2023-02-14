//
//  AddFriendUseCase.swift
//  MSG
//
//  Created by 김민호 on 2023/02/13.
//

import Foundation

protocol AddFriend {
    func myInfo() async throws -> Msg?
    func addBothWithFriend(user: Msg, me: Msg)
    func deleteWaitingFriend(userId: String) async
    
    func acceptAddFriend(friend: Msg)
    func sendFriendRequest(to: Msg, from: Msg)
}

struct AddFriendUseCase: AddFriend {
    let repo: AddFriendRepository
    func myInfo() async throws -> Msg? {
        if let data = try? await repo.myInfo() {
            return data
        }
        return nil
    }
    
    func addBothWithFriend(user: Msg, me: Msg) {
        repo.addBothWithFriend(user: user, me: me)
    }

    func deleteWaitingFriend(userId: String) async {
        await repo.deleteWaitingFriend(userId: userId)
    }
    
    
    func acceptAddFriend(friend: Msg){
        repo.acceptAddFriend(friend: friend)
    }
    func sendFriendRequest(to: Msg, from: Msg) {
        repo.sendFriendRequest(to: to, from: from)
    }
    
    
}
