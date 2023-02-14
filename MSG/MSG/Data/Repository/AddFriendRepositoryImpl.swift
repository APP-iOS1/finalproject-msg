//
//  AddFriendRepositoryImpl.swift
//  MSG
//
//  Created by 김민호 on 2023/02/13.
//

import Foundation

struct AddFriendRepositoryImpl: AddFriendRepository {
    let dataSourceRealTimeDB: AddFriendDataSourceWithRealTimeDB
    let dataSourceFireBase: AddFriendDataSource
    
    func myInfo() async throws -> Msg? {
        if let data = try? await dataSourceFireBase.myInfo() {
            return data
        }
        return nil
    }
    
    func addBothWithFriend(user: Msg, me: Msg) {
        dataSourceFireBase.addBothWithFriend(user: user, me: me)
    }
    
    func deleteWaitingFriend(userId: String) async {
        await dataSourceFireBase.deleteWaitingFriend(userId: userId)
    }
    
    //MARK: RealTime
    func acceptAddFriend(friend: Msg) {
        dataSourceRealTimeDB.acceptAddFriend(friend: friend)
    }
    func sendFriendRequest(to: Msg, from: Msg) {
        dataSourceRealTimeDB.sendFriendRequest(to: to, from: from)
    }
    
    
}
