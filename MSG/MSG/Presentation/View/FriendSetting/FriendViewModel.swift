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

class FriendViewModel: ObservableObject {
    @Published var searchUserArray: [Msg] = []
    @Published var myFrinedArray: [Msg] = []

    @Published var inviteFriendArray: [Msg] = []
    @Published var text = ""
    @Published var notGamePlayFriend: [Msg] = []
    @Published var friendIdArray: [String] = []
    
    let database = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    //검색 -> 결과가 나오는데 -> 내친구가 게임중이면 친구가아님
    init() {
        $text
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .sink { _ in
            } receiveValue: { text in
                if !text.isEmpty{
                    self.findUser(text: text)
                } else {
                    self.searchUserArray = self.myFrinedArray
                }
            }.store(in: &cancellables)
    }
    
    func findUser(text: String) {
        print(#function)
        self.searchUserArray.removeAll()
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
                        if (nickName.contains(text.lowercased()) || nickName.contains( text.uppercased())) && (id != Auth.auth().currentUser?.uid) {
                            
                            self.searchUserArray.append(getUser)
                        }
                        //                        print("findUser:",self.searchUserArray)
                    }
                    
                }
            }
    }
    
    //1. 내 친구목록에서 친구들의 아이디를 찾아온다
    // findFriend() -> myFrinedArray에 담겨있음
    //2. 찾아온 아이디로 내친구가 게임중인지 체크한다
    //3. 게임중이 아닌 친구들의 목록만 보여준다 -> notGamePlayFriend에 append
    
    
    
    func findUser1(text: [Msg]){
        print(#function)
        //        print(text)
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
                        //                        let friend: [String] = docData["friend"] as? [String] ?? []
                        //                        print(id)
                        //                        print(text)
                        let getUser: Msg = Msg(id: id, nickName: nickName, profileImage: profileImage, game: game, gameHistory: gameHistory)
                        for i in text {
                            if i.id == id && game.isEmpty {
                                //                                print(getUser.nickName)
                                self.notGamePlayFriend.append(getUser)
                                //                                print("notGame:",self.notGamePlayFriend)
                            }
                        }
                    }
                    self.notGamePlayFriend = Array(Set(self.notGamePlayFriend))
                    
                }
            }
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
            let docData = document.data()
            let nickName: String = docData["nickName"] as? String ?? ""
            let profileImage: String = docData["profileImage"] as? String ?? ""
            let game: String = docData["game"] as? String ?? ""
            let gameHistory: [String] = docData["gameHistory"] as? [String] ?? []
            let getUser: Msg = Msg(id: id, nickName: nickName, profileImage: profileImage, game: game, gameHistory: gameHistory)
            if !self.myFrinedArray.contains(getUser){ self.myFrinedArray.append(getUser) }
            self.friendIdArray.append(id)
            
            //            print("findFriend:",self.myFrinedArray)
            //            print("받는중이지롱:",self.myFrinedArray)
        }
    }
}