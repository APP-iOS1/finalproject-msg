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
    
    let database = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
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
                        let profilImage: String = docData["profilImage"] as? String ?? ""
                        let game: String = docData["game"] as? String ?? ""
                        let gameHistory: [String] = docData["gameHistory"] as? [String] ?? []
                        let friend: [String] = docData["friend"] as? [String] ?? []
                        
                        let getUser: Msg = Msg(id: id, nickName: nickName, profilImage: profilImage, game: game, gameHistory: gameHistory, friend: friend)
                        if nickName.contains(text) && (id != Auth.auth().currentUser?.uid) {
                            self.searchUserArray.append(getUser)
                        }
                        print("findUser:",self.searchUserArray)
                    }
                    
                }
            }
    }
    
    
    // MARK: - 친구 목록 가져오기
    func findFriend() {
        print(#function)
        guard let userId = Auth.auth().currentUser?.uid else{ return  }
        database
            .collection("User")
            .document(userId)
            .collection("friend")
            .getDocuments { (snapshot, error) in
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        print("id:\(id)")
                        let docData = document.data()
                        let nickName: String = docData["nickName"] as? String ?? ""
                        let profilImage: String = docData["profilImage"] as? String ?? ""
                        let game: String = docData["game"] as? String ?? ""
                        let gameHistory: [String] = docData["gameHistory"] as? [String] ?? []
                        let friend: [String] = docData["friend"] as? [String] ?? []

                        let getUser: Msg = Msg(id: id, nickName: nickName, profilImage: profilImage, game: game, gameHistory: gameHistory, friend: friend)
                        print("findFriend:",self.myFrinedArray)
                        self.myFrinedArray.append(getUser)
                    }
                    self.myFrinedArray = Array(Set(self.myFrinedArray))
                }
            }
    }
}
