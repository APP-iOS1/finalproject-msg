//
//  DivideFriendViewModel.swift
//  MSG
//
//  Created by sehooon on 2023/02/02.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine


protocol DivideFriendViewModelInput {
    func makeProfile(_ userIdArray:[String]) async -> [Msg]?
    func fetchUserInfo(_ userId: String) async throws -> Msg?
    func findUser(text: String) async throws
    func uploadSendToFriend(_ userId: String, sendToFriendArray: [String])
    func subscribe()
}


final class DivideFriendViewModel: ObservableObject {
    //
    let divideFriendUseCase = DivideFriendUseCase(repo: DivideFriendRepositoryImpl(dataSource: FirebaseService()))
    let friendUseCase = FriendUseCase(repo: FriendRepositoryImpl(dataSource: FirebaseService()))
    let addFriendUseCase = AddFriendUseCase(repo: AddFriendRepositoryImpl(dataSourceRealTimeDB: Real(), dataSourceFireBase: FirebaseService()))
    @Published var baseUserArray: [Msg] = [] // 화면에 보여지는 실제 목록
    @Published var myFriendArray: [String] = [] // 현재 추가되어있는 친구목록
    @Published var searchUserArray: [String] = [] // 검색 결과로 나온 유저 목록
    @Published var sendToFriendArray:[String] = [] // 친구에게
//    @Published var inviteFriendArray: [Msg] = []
    @Published var text = ""
//    @Published var notGamePlayFriend: [Msg] = []
    @Published var friendIdArray: [String] = []
    @Published var listener: ListenerRegistration?
    @Published var displayFriendArray:[Msg] = []
    let database = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    //검색 -> 결과가 나오는데 -> 내친구가 게임중이면 친구가아님
    
    init() {
        doSomething()
    }
}

extension DivideFriendViewModel: DivideFriendViewModelInput {
    
    func doSomething() {
        $text
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .sink { _ in
            } receiveValue: { text in
                if !text.isEmpty{
                    Task{
                        try await self.findUser(text: text)
                        let profile = await self.makeProfile(self.searchUserArray) ?? []
                        DispatchQueue.main.async { self.baseUserArray = profile }
                        
                    }
                } else {
                    Task{
                        let profile = await self.makeProfile(self.myFriendArray) ?? []
                        DispatchQueue.main.async { self.baseUserArray = profile }
                    }
                }
            }.store(in: &cancellables)
    }
    
    func makeProfile(_ userIdArray: [String]) async -> [Msg]? {
        let data = await divideFriendUseCase.makeProfile(userIdArray)
        return data
    }
    
    func fetchUserInfo(_ userId: String) async throws -> Msg? {
        if let data = try? await divideFriendUseCase.fetchUserInfo(userId) {
            return data
        }
        return nil
    }
    
    func findUser(text: String) async throws {
        //searchUserArray
        if let data = try? await divideFriendUseCase.findUser(text: text) {
            await MainActor.run {
                self.searchUserArray = data
            }
        }
    }
    
    
    //분리실패
    func subscribe(){
        print(#function)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = database.collection("Waiting").document(uid)
        listener = ref.addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot  else { return }
            guard let docData = document.data() else { return }
            self.sendToFriendArray = docData["sendToFriend"] as? [String] ?? []
            Task { await self.getMyFriend() }
            print(self.sendToFriendArray)
            print("외안되")
        }
    }
    
    func uploadSendToFriend(_ userId: String, sendToFriendArray: [String]) {
        divideFriendUseCase.uploadSendToFriend(userId, sendToFriendArray: self.sendToFriendArray)
    }
    
    func getMyInfo() async -> Msg?{
        if let data = try? await addFriendUseCase.myInfo() {
            return data
        }
        return nil
    }
    func sendFriendRequest(to: Msg, from: Msg) {
        addFriendUseCase.sendFriendRequest(to: to, from: from)
    }
    
    func getMyFriend() async{
        await MainActor.run {
            self.myFriendArray.removeAll()
        }
        let data = await friendUseCase.fetchFriendList()
        await MainActor.run {
            self.myFriendArray = data.1
        }
    }
}
