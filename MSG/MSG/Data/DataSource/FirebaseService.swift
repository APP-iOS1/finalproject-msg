//
//  FirestoreDataSource.swift
//  MSG
//
//  Created by sehooon on 2023/02/13.
//

import Combine
import Foundation
import FirebaseFirestore
import FirebaseAuth

//MARK: - API
// 실제 데이터를 받아오는 위치
struct FirebaseService {
    
    var database: Firestore = Firestore.firestore()
    
    func findSearchUser(text: String) -> [Msg] {
        print(#function)
        var searchUserArray: [Msg] = []
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
                            
                            searchUserArray.append(getUser)
                        }
                    }
                    
                }
            }
        return searchUserArray
    }
    func findUser1(text: [Msg]) async -> [Msg]{
        print(#function)
        print("input Value:",text)
        //        notGamePlayFriend.removeAll()
        var notGamePlayFriend: [Msg] = []
        do {
            let data = try await database.collection("User").getDocuments()
            for document in data.documents {
                let id: String = document.documentID
                let docData = document.data()
                let nickName: String = docData["nickName"] as? String ?? ""
                let profileImage: String = docData["profileImage"] as? String ?? ""
                let game: String = docData["game"] as? String ?? ""
                let gameHistory: [String] = docData["gameHistory"] as? [String] ?? []
                let getUser: Msg = Msg(id: id, nickName: nickName, profileImage: profileImage, game: game, gameHistory: gameHistory)
                for i in text {
                    if i.id == id && game.isEmpty {
                        notGamePlayFriend.append(getUser)
                    }
                }
                notGamePlayFriend = Array(Set(notGamePlayFriend))
            }
            //            print("스토어에서 데이터:",notGamePlayFriend)
            return notGamePlayFriend
        } catch {
            print("error!")
            return []
        }
    }
    @MainActor
    func findFriend() async throws -> ([Msg],[String]){
        print("Impl",#function)
        var friendIdArray: [String] = []
        var friendArray: [Msg] = []
        //            self.myFrinedArray.removeAll()
        //            self.friendIdArray.removeAll()
        guard let userId = Auth.auth().currentUser?.uid else{ return ([],[])  }
        // 유저 컬렉션 -> 프렌드컬렉션 ->  친구들 최신화가 안된 친구들, 즉 게임중인지 모름.
        let snapshot = try await database.collection("User").document(userId).collection("friend").getDocuments()
        for document in snapshot.documents{
            //func fetchUserInfo()
            
            let id: String = document.documentID
            let docData = document.data()
            let nickName: String = docData["nickName"] as? String ?? ""
            let profileImage: String = docData["profileImage"] as? String ?? ""
            let game: String = docData["game"] as? String ?? ""
            let gameHistory: [String] = docData["gameHistory"] as? [String] ?? []
            let getUser: Msg = Msg(id: id, nickName: nickName, profileImage: profileImage, game: game, gameHistory: gameHistory)
//            if !friend.contains(getUser){friendArray.append(getUser) }
            friendArray.append(getUser)
            friendIdArray.append(id)
        }
        return (friendArray,friendIdArray)
    }
    
    func searchUser(text: String) -> [Msg]{
        print(#function)
        var searchUserArray: [Msg] = []
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
                            
                            searchUserArray.append(getUser)
                        }
                    }
                    
                }
            }
        return searchUserArray
    }
    
    
}

//

extension FirebaseService: FriendDataSource {

}

extension FirebaseService: ChallengeDataSource{
    

    // MARK: - User game에 gameId를 업데이트 하는 메서드
    func updateUserGame(gameId: String) async {
        print(#function)
        guard let userId = Auth.auth().currentUser?.uid else{ return }
        do{
            try await database.collection("User").document(userId).updateData([ "game": gameId ])
        }catch{
            print("Error #UPDATE USER GAME")
        }
    }
    
    // MARK: - SingleGame + User game에 String 추가하는 함수
    func makeSingleGame(_ singleGame: Challenge) async {
        print(#function)
        do{
            try await database.collection("Challenge").document(singleGame.id).setData([
                "id": singleGame.id,
                "gameTitle": singleGame.gameTitle,
                "limitMoney": singleGame.limitMoney,
                "startDate": singleGame.startDate,
                "endDate": singleGame.endDate,
                "inviteFriend": singleGame.inviteFriend
            ])
            await updateUserGame(gameId: singleGame.id)
        }catch{ print("Error #MAKE SINGLE GAME") }
    }
    
    // MARK: - 현재 진행중인 User의 Challenge ID를 가져오는 함수
    func fetchChallengeId() async -> String? {
        print(#function)
        guard let userId = Auth.auth().currentUser?.uid else{ return nil }
        let ref = database.collection("User").document(userId)
        do {
            let snapShot = try await ref.getDocument()
            guard let docData = snapShot.data() else { return nil }
            let gameId = docData["game"] as? String ?? ""
            return gameId
        } catch {
            print("catched")
            return nil
        }
    }
}

//MARK: - AddFriendDataSource
extension FirebaseService: AddFriendDataSource {
    func myInfo() async throws -> Msg? {
        guard let myId = Auth.auth().currentUser?.uid else { return nil }
        let ref = Firestore.firestore().collection("User").document(myId)
        let snapshot = try await ref.getDocument()
        guard let docData = snapshot.data() else { return nil }
        let nickName = docData["nickName"] as? String ?? ""
        let profileImage = docData["profileImage"] as? String ?? ""
        let game = docData["game"] as? String ?? ""
        let gameHistory = docData["gameHistory"] as? [String] ?? []
        let userInfo = Msg(id: snapshot.documentID, nickName: nickName, profileImage: profileImage, game: game, gameHistory: gameHistory)
        return userInfo
    }
    
    // MARK: 친구추가
    /// 둘다 친구를 추가합니다.
    func addBothWithFriend(user: Msg, me: Msg) {
        print(#function)
        
        //나에게 친구를 추가합니다.
        database.collection("User")
            .document(Auth.auth().currentUser?.uid ?? "")
            .collection("friend")
            .document(user.id)
            .setData(["id": user.id,
                      "nickName": user.nickName,
                      "profileImage": user.profileImage,
                      "game": user.game,
                      "gameHistory": user.gameHistory ?? []
                     ])
        
        //친구에게 나를 추가합니다.
        database.collection("User")
            .document(user.id)
            .collection("friend")
            .document(Auth.auth().currentUser?.uid ?? "")
            .setData(["id": me.id,
                      "nickName": me.nickName,
                      "profileImage": me.profileImage,
                      "game": me.game,
                      "gameHistory": me.gameHistory ?? []
                     ])
    }
    
    // MARK:  친구 초대 수락 시, WaitingCollection에서 해당 유저 제거
    func deleteWaitingFriend(userId: String) async {
        print(#function)
        guard let myId = Auth.auth().currentUser?.uid else { return }
        guard var waitingFriend = await fetchWaitingFriend(userId) else { return }
        guard let index = waitingFriend.firstIndex(of: myId) else { return }
        waitingFriend.remove(at: index)
        do{
            try await database.collection("Waiting").document(userId).updateData([ "sendToFriend" : waitingFriend ])
        }catch{
                print("Error")
        }
    }
    // MARK:  waitingFriend가져오기
    func fetchWaitingFriend(_ userId: String) async -> [String]? {
        print(#function)
        do{
            let document = try await database.collection("Waiting").document(userId).getDocument()
            guard let docData = document.data() else{ return nil }
            let waitingArr = docData["sendToFriend"] as? [String] ?? []
            return waitingArr
        }catch{
            print("Error!")
            return nil
        }
    }
    
}

//protocol AddFriendDataSource {
//    func myInfo() //f
//    func addUser() // f
//    func deleteWaitingFriend() // f
//}


