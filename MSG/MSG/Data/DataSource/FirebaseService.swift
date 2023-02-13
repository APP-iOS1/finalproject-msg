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
    func findFriend(friend: [Msg]) async throws -> ([Msg],[String]){
        print("Impl",#function)
        var friendIdArray: [String] = []
        var friendArray: [Msg] = []
        //            self.myFrinedArray.removeAll()
        //            self.friendIdArray.removeAll()
        guard let userId = Auth.auth().currentUser?.uid else{ return ([],[])  }
        let snapshot = try await database.collection("User").document(userId).collection("friend").getDocuments()
        for document in snapshot.documents{
            let id: String = document.documentID
            let docData = document.data()
            let nickName: String = docData["nickName"] as? String ?? ""
            let profileImage: String = docData["profileImage"] as? String ?? ""
            let game: String = docData["game"] as? String ?? ""
            let gameHistory: [String] = docData["gameHistory"] as? [String] ?? []
            let getUser: Msg = Msg(id: id, nickName: nickName, profileImage: profileImage, game: game, gameHistory: gameHistory)
            if !friend.contains(getUser){
                friendArray.append(getUser)
            }
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


//

extension FirebaseService: ChallengeRecordDataSource {
    // MARK: - 유저 정보를 불러오는 함수
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
    
    // MARK: - 총 사용금액 가져오기
    func fetchTotalMoney(_ challengeId: String, _ userId: String) async -> Int {
        print(#function)
        let ref = database.collection("Challenge").document(challengeId).collection("expenditure").document(userId)
        do {
            let document = try await ref.getDocument()
            guard let docData = document.data() else { return 0 }
            let totalMoney = docData["totalMoney"] as? Int ?? 0
            return totalMoney
        } catch {
            print("총 사용금액이 0")
            return 0
        }
    }
    
    // MARK: - 게임 히스토리 ID 목록 가져오기
    func fetchGameHistoryList() async -> [String]? {
        print(#function)
        guard let userId = Auth.auth().currentUser?.uid else { return nil }
        let ref = database.collection("User").document(userId)
        do{
            let snapShot = try await ref.getDocument()
            guard let docData = snapShot.data() else { return []}
            let array = docData["gameHistory"] as? [String] ?? []
            return array
        }catch{
            print("catched")
            return []
        }
    }
    
    // MARK: - 이전 챌린지기록을 모두 가져오는 함수
    @MainActor
    func fetchPreviousGameHistory() async throws -> [Challenge] {
        print(#function)
        var challengeHistoryArray : [Challenge] = []
        let ref = database.collection("Challenge")
        guard let challengesId = await fetchGameHistoryList() else { return [] }
        challengeHistoryArray.removeAll()
        for challengeId in challengesId{
            let document = try await ref.document(challengeId).getDocument()
            guard let docData = document.data() else { return [] }
            let id = docData["id"] as? String ?? ""
            let gameTitle = docData["gameTitle"] as? String ?? ""
            let limitMoney = docData["limitMoney"] as? Int ?? 0
            let startDate = docData["startDate"] as? String ?? ""
            let endDate = docData["endDate"] as? String ?? ""
            let inviteFriend = docData["inviteFriend"] as? [String] ?? []
            let waitingFriend = docData["waitingFriend"] as? [String] ?? []
            let challenge = Challenge(id: id, gameTitle: gameTitle, limitMoney: limitMoney, startDate: startDate, endDate: endDate, inviteFriend: inviteFriend, waitingFriend: waitingFriend)
            challengeHistoryArray.append(challenge)
        }
        return challengeHistoryArray
    }
    
    // MARK: - 챌린지 참가자 (유저 정보, 지출) 가져오기
    func fetchChallengeUsersData(_ users: [String], _ challengeId: String) async -> ChallengeUserData? {
        print(#function)
        var userArray:ChallengeUserData = []
        for user in users{
            do {
                guard let userData = try await fetchUserInfo(user) else { continue } // nickname profile
                let totalMoney = await fetchTotalMoney(challengeId, userData.id) // expenditure
                let userInfo = (user: (userName: userData.nickName ,userProfile: userData.profileImage),totalMoney: totalMoney)
                userArray.append(userInfo)
            } catch {
                print("userData 누락!!")
                return nil
            }
        }
        return userArray
    }
    
    // MARK: - 챌린지 참가자 (유저 정보, 지출) 가져오기
    func fetchChallengeUsers(_ users: [String], _ challengeId: String) async  -> ChallengeUserData {
        print(#function)
        var challengeUsers: ChallengeUserData = []
        challengeUsers.removeAll()
        for user in users{
            do {
                guard let userData = try await fetchUserInfo(user) else { continue } // nickname profile
                let totalMoney = await fetchTotalMoney(challengeId, userData.id) // expenditure
                let userInfo = (user: (userName: userData.nickName ,userProfile: userData.profileImage),totalMoney: totalMoney)
                challengeUsers.append(userInfo)
            } catch {
                print("userData 누락!!")
            }
        }
        return challengeUsers
    }
    
    // MARK: - 챌린지 이력의 리스트 셀을 선택했을 시, 각 유저별 토탈 금액 가져오는 함수
    func fetchChallengeTotalMoney(_ challengeId: String) async throws {
        print(#function)
        var challengeHistoryUserList : [(userId: String, totalMoney: Int)] = []
        let ref = database.collection("Challenge").document(challengeId).collection("expenditure")
        challengeHistoryUserList.removeAll()
        let snapShots = try await ref.getDocuments()
        for document in snapShots.documents{
            let docData = document.data()
            let userId = document.documentID
            let totalMoney = docData["totalMoney"] as? Int ?? 0
            challengeHistoryUserList.append((userId: userId, totalMoney: totalMoney))
        }
    }
    
    //MARK: - 해당 유저의 특정 과거 게임 지출 기록 가져오기
    func fetchHistoryExpenditure(_ gameId: String) async -> Expenditure? {
        print(#function)
        guard let userId = Auth.auth().currentUser?.uid else { return nil }
        let ref = database.collection("Challenge").document(gameId).collection("expenditure").document(userId)
        do {
            let snapShot = try await ref.getDocument()
            guard let docData = snapShot.data() else { return nil}
            let id = docData["id"] as? String ?? ""
            let expenditureHistory = docData["expenditureHistory"] as? [String: [String]] ?? [:]
            let totalMoney = docData["totalMoney"] as? Int ?? 0
            let expenditure = Expenditure(id: id, totalMoney: totalMoney, expenditureHistory: expenditureHistory)
            return expenditure
        } catch {
            print("Error! fetchExpenditure")
            return nil
        }
    }
}
