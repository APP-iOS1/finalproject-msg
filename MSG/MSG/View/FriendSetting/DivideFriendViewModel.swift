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

final class DivideFriendViewModel: ObservableObject {
    //
    @Published var baseUserArray: [Msg] = [] // 화면에 보여지는 실제 목록
    @Published var myFrinedArray: [String] = [] // 현재 추가되어있는 친구목록
    @Published var searchUserArray: [String] = [] // 검색 결과로 나온 유저 목록
    @Published var sendToFriendArray:[String] = [] // 친구에게
    @Published var inviteFriendArray: [Msg] = []
    @Published var text = ""
    @Published var notGamePlayFriend: [Msg] = []
    @Published var friendIdArray: [String] = []
    @Published var listener: ListenerRegistration?
    @Published var displayFriendArray:[Msg] = []
    let database = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    //검색 -> 결과가 나오는데 -> 내친구가 게임중이면 친구가아님
    init() {
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
                        let profile = await self.makeProfile(self.myFrinedArray) ?? []
                        DispatchQueue.main.async { self.baseUserArray = profile }
                    }
                }
            }.store(in: &cancellables)
    }
    
    
    
    
    // MARK: - 입력받은 친구목록 아이디들로 실제 프로필 받아오는 메서드.
    func makeProfile(_ userIdArray:[String]) async -> [Msg]? {
        var friendArray:[Msg] = []
        for friend in userIdArray{
            do{
                let user = try await fetchUserInfo(friend)
                if user != nil { friendArray.append(user!) }
            }catch{
                return nil
            }
        }
        return friendArray
    }
    
    // MARK: -
    func fetchUserInfo(_ userId: String) async throws -> Msg? {
        print(#function)
        guard (Auth.auth().currentUser != nil) else { return nil}
        let ref = database.collection("User").document(userId)
        let snapshot = try await ref.getDocument()
        guard let docData = snapshot.data() else { return nil }
        let nickName = docData["nickName"] as? String ?? ""
        let profileImage = docData["profileImage"] as? String ?? ""
        let game = docData["game"] as? String ?? ""
        let gameHistory = docData["gameHistory"] as? [String] ?? []
//        let friend = docData["friend"] as? [String] ?? []
        let userInfo = Msg(id: snapshot.documentID, nickName: nickName, profileImage: profileImage, game: game, gameHistory: gameHistory)
        return userInfo
    }


    
    // MARK: - 모든 유저에서, 내가 입력한 닉네임의 유저찾기
    /// 검색할 유저 닉네임 입력 시, 해당 닉네임이 포함된 유저 목록 가져오는 메서드.
    @MainActor
    func findUser(text: String) async throws {
        print(#function)
        self.searchUserArray.removeAll()
        let snapShots = try await database.collection("User").getDocuments()
        for document in snapShots.documents{
            let id: String = document.documentID
            let docData = document.data()
            let nickName: String = docData["nickName"] as? String ?? ""
//            nickName.lowercased()
            if nickName.lowercased().contains(text.lowercased()) && id != Auth.auth().currentUser?.uid {
                self.searchUserArray.append(id)
            }
        }
    }
    
    
    func findUser1(text: [Msg]){
        print(#function)
        notGamePlayFriend.removeAll()
        database
            .collection("User")
            .getDocuments { (snapshot, error) in
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        let nickName: String = docData["nickName"] as? String ?? ""
                        let profileImage: String = docData["profileImage"] as? String ?? ""
                        let game: String = docData["game"] as? String ?? ""
                        let gameHistory: [String] = docData["gameHistory"] as? [String] ?? []
                        let getUser: Msg = Msg(id: id, nickName: nickName, profileImage: profileImage, game: game, gameHistory: gameHistory)
                        for i in text {
                            if i.id == id && game.isEmpty {
                                self.notGamePlayFriend.append(getUser)
                            }
                        }
                    }
                    self.notGamePlayFriend = Array(Set(self.notGamePlayFriend))
                    
                }
            }
    }

    
    
    // MARK: - 친구 요청을 보낸 경우, 수락했는지 확인하는 리스너
    func subscribe(){
        print(#function)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = database.collection("Waiting").document(uid)
        listener = ref.addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot  else { return }
            guard let docData = document.data() else { return }
            self.sendToFriendArray = docData["sendToFriend"] as? [String] ?? []
            Task { try await self.findFriend() }
            print(self.sendToFriendArray)
            print("외안되")
        }
    }
    
    
    // MARK: -  친구에게 친구초대 보낼 경우, sendToFriendArray에 해당 유저 넣기
    /// 친구가 친구수락을 받을때까지, sendToFriendArray에 친구 아이디 저장
    func uploadSendToFriend(_ userId: String){
        print(#function)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        database.collection("Waiting").document(uid).setData([ "sendToFriend": self.sendToFriendArray + [userId] ])
    }
    
    // MARK: - 친구 목록 가져오기
    @MainActor
    func findFriend() async throws {
        print(#function)
        self.myFrinedArray.removeAll()
        self.friendIdArray.removeAll()
        guard let userId = Auth.auth().currentUser?.uid else{ return  }
        let snapshot = try await database.collection("User").document(userId).collection("friend").getDocuments()
        for document in snapshot.documents{
            let id: String = document.documentID
            if !self.myFrinedArray.contains(id){ self.myFrinedArray.append(id) }
        }
    }
}
