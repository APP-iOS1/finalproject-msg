//
//  FriendViewModel.swift
//  MSG
//
//  Created by kimminho on 2023/01/22.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

//MARK: - ViewModel Input
protocol FriendInput {
    func getMyFriendArray() async
    func getMyFriendForNotGame() async throws
    func getSearchUser()
    func getUserInText(text: String)
}
//MARK: - ViewModel Output
protocol FriendOutput {
    var searchUserArray: [Msg] { get }
    var myFrinedArray: [Msg] { get }
    var inviteFriendArray: [Msg] { get }
    var notGamePlayFriend: [Msg] { get }
    var friendIdArray: [String] { get }
}

class FriendViewModel: ObservableObject, FriendInput, FriendOutput {

    @Published var myFrinedArray: [Msg] = []
    @Published var text: String = ""
    @Published var notGamePlayFriend: [Msg] = []
    let friendUseCase = FriendUseCase(repo: FriendRepositoryImpl(dataSource: FirebaseService()))
    var searchUserArray: [Msg] = []
    var inviteFriendArray: [Msg] = []
    var friendIdArray: [String] = []
    let database = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    
    func getUserInText(text: String) {
        $text
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .sink { _ in
            } receiveValue: { text in
                if !text.isEmpty{
                    self.searchUserArray = self.friendUseCase.findSearchUser(text: text)
                } else {
                    self.searchUserArray = self.myFrinedArray
                }
            }.store(in: &cancellables)
    }
    
    // MARK: - 친구 목록 가져오기
    @MainActor
    func getMyFriendArray() async {
        print(#function)
        let data = await friendUseCase.fetchFriendList(friend: myFrinedArray)
        myFrinedArray = data.0
        friendIdArray = data.1
    }
    
    @MainActor
    func getMyFriendForNotGame() async throws{
        print(#function)
        notGamePlayFriend = try await friendUseCase.caseNotGameMyFriend(text: myFrinedArray)
    }
    
    func getSearchUser() {
        friendUseCase.findSearchUser(text: text)
    }
}
