//
//  FriendRepositoryImpl.swift
//  MSG
//
//  Created by kimminho on 2023/02/12.
//
import Combine
import Foundation

//MARK: - Repository
struct FriendRepositoryImpl: FriendRepository{
    var dataSource: FriendDataSource
    
    func getFriend(friend: [Msg]) async throws -> ([Msg], [String]) {
        print(#function)
        do {
            let data = try await dataSource.findFriend(friend: friend)
            return data
        }catch {
            print("error")
            return ([],[])
        }
    }
    
    func notGameMyFriend(text: [Msg]) async -> [Msg] {
        print(#function)
        let data = await dataSource.findUser1(text: text)
        return data
    }
    
    func findSearchUser(text: String) -> [Msg] {
        let data = dataSource.findSearchUser(text: text)
        return data
    }
    
    func searchUserInText(text: String) -> [Msg] {
        let data = dataSource.searchUser(text: text)
        return data
    }
}
