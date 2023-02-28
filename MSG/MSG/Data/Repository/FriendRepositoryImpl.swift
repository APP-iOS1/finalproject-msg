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
    
    func getFriend() async throws -> ([Msg], [String]) {
        print(#function)
        do {
            let data = try await dataSource.findFriend()
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

struct DivideFriendRepositoryImpl: DivideFriendRepository {
    var dataSource: DivideFriendDataSource
    
    func makeProfile(_ userIdArray: [String]) async -> [Msg]? {
        let data = await dataSource.makeProfile(userIdArray)
        return data
    }
    
    func fetchUserInfo(_ userId: String) async throws -> Msg? {
        if let data = try? await dataSource.fetchUserInfo(userId) {
            return data
        }
        return nil
    }
    
    func findUser(text: String) async throws -> [String] {
        if let data = try? await dataSource.findUser(text: text) {
            return data
        }
        return []
    }
    
    func uploadSendToFriend(_ userId: String, sendToFriendArray: [String]) {
        dataSource.uploadSendToFriend(userId, sendToFriendArray: sendToFriendArray)
    }

}
