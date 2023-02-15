//
//  FriendUseCase.swift
//  MSG
//
//  Created by kimminho on 2023/02/12.
//
import Combine
import Foundation

//MARK: - Usecase protocol
protocol GetTodos {
    func findSearchUser(text: String) -> [Msg] // 유저검색(1)
    func fetchFriendList() async throws -> ([Msg],[String]) // 친구 목록 가져오기
    func caseNotGameMyFriend(text: [Msg]) async throws -> [Msg] // 게임을 안하고있는 친구목록 가져오기
}

//파일정리가 되면 네이밍 바꿀 예정
protocol DivideGetTodos {
    func makeProfile(_ userIdArray:[String]) async -> [Msg]?
    func fetchUserInfo(_ userId: String) async throws -> Msg?
    func findUser(text: String) async throws -> [String]
    func uploadSendToFriend(_ userId: String, sendToFriendArray: [String])
}

//MARK: - UseCase
struct FriendUseCase: GetTodos {
    
    
    var repo: FriendRepository
    
    func fetchFriendList() async -> ([Msg],[String]){
        print(#function)
        do {
            let friend = try await repo.getFriend()
            return friend
        }catch {
            return ([],[])
        }
    }
    func caseNotGameMyFriend(text: [Msg]) async throws -> [Msg] {
        print(#function)
        let notGameFriend = try await repo.notGameMyFriend(text: text)
        return notGameFriend
    }
    
    func findSearchUser(text: String) -> [Msg] {
        let searchUser = repo.findSearchUser(text: text)
        return searchUser
    }
    
}

struct DivideFriendUseCase: DivideGetTodos {
    var repo: DivideFriendRepository
    
    func makeProfile(_ userIdArray: [String]) async -> [Msg]? {
        let data = await repo.makeProfile(userIdArray)
        return data
    }
    
    func fetchUserInfo(_ userId: String) async throws -> Msg? {
        if let data = try? await repo.fetchUserInfo(userId) {
            return data
        }
        return nil
    }
    
    func findUser(text: String) async throws -> [String] {
        if let data = try? await repo.findUser(text: text) {
            return data
        }
        return []
    }
    
    func uploadSendToFriend(_ userId: String, sendToFriendArray: [String]) {
        repo.uploadSendToFriend(userId, sendToFriendArray: sendToFriendArray)
    }

}
