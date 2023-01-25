//
//  UserInfoViewModel.swift
//  MSG
//
//  Created by kimminho on 2023/01/18.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import Firebase
import FirebaseCore
import FirebaseStorageCombineSwift
import FirebaseAuth
import SwiftUI

@MainActor
class FireStoreViewModel: ObservableObject {
    //전체유저
    @Published var userArray: [Msg] = []
    @Published var challengeHistoryArray : [Challenge] = []
    @Published var challengeHistoryUserList : [(userId: String, totalMoney: Int)] = []
    //내친구
    @Published var myFrinedArray: [Msg] = []
    let database = Firestore.firestore()
    // 챌린지
    var newSingleGameId: String = ""
    @Published var singleGameList: [Challenge] = []
    @Published var currentGame: Challenge?
    
    
    init() {
        //        postits = []
    }
    
    
    // MARK: - 유저 정보를 불러오는 함수
    /// userId를 통해, 유저 정보를 가져온다.
    func fetchUserInfo(_ userId: String) async throws -> Msg? {
        guard (Auth.auth().currentUser != nil) else { return nil}
        let ref = database.collection("User").document(userId)
        let snapshot = try await ref.getDocument()
        guard let docData = snapshot.data() else { return nil }
        let nickName = docData["nickName"] as? String ?? ""
        let profileImage = docData["profileImage"] as? String ?? ""
        let game = docData["game"] as? String ?? ""
        let gameHistory = docData["gameHistory"] as? [String] ?? []
        let friend = docData["friend"] as? [String] ?? []
        let userInfo = Msg(id: snapshot.documentID, nickName: nickName, profilImage: profileImage, game: game, gameHistory: gameHistory, friend: friend)
        return userInfo
    }
    
    //프로필설정을 마치고 완료버튼을 눌렀을 때 발동
    func addUserInfo(user: Msg, downloadUrl: String) {
        print(#function)
        database.collection("User")
            .document(Auth.auth().currentUser?.uid ?? "")
            .setData(["id": Auth.auth().currentUser?.uid ?? "",
                      "nickName": user.nickName,
                      "game": user.game,
                      "gameHistory": user.gameHistory,
                      "friend": user.friend,
                      "profileImage": downloadUrl,
                     ])
        
    }
    
    func uploadImageToStorage(userImage: UIImage, user: Msg) {
        let ref = Storage.storage().reference(withPath: Auth.auth().currentUser?.uid ?? "")
        guard let imageData = userImage.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err { return }
            ref.downloadURL { url, err in
                if let err = err { return }
                print(url?.absoluteString)
                self.addUserInfo(user: user, downloadUrl: url?.absoluteString ?? "")
            }
        }
    }
    
    //모든유저 찾기
    @MainActor
    func findUser() {
        print(#function)
        self.userArray.removeAll()
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
                        self.userArray.append(getUser)
                        print("findUser:",self.userArray)
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
                self.userArray.removeAll()
                
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
    
    func fetchFriend() {
        
    }
    
    // MARK: - 친구추가
    /// 내 친구목록에 추가합니다.
    func addUserInfo(user: Msg) {
        print(#function)
        database.collection("User")
            .document(Auth.auth().currentUser?.uid ?? "")
            .collection("friend")
            .document(user.id)
            .setData(["id": user.id,
                      "nickName": user.nickName,
                      "profilImage": user.profilImage,
                      "game": user.game,
                      "gameHistory": user.gameHistory,
                      "friend": user.friend,
                     ])
        print("user:\(user.id)")
        print(Auth.auth().currentUser?.uid ?? "")
        //            fireStoreViewModel.userArray
        //        fetchPostits()
    }
    // MARK: - 친구추가
    /// 친구의 목록에도 나를추가
    func addUserInfo2(user: Msg, myInfo: Msg) {
        print(#function)
        database.collection("User")
            .document(user.id)
            .collection("friend")
            .document(Auth.auth().currentUser?.uid ?? "")
            .setData(["id": myInfo.id,
                      "nickName": myInfo.nickName,
                      "profilImage": myInfo.profilImage,
                      "game": myInfo.game,
                      "gameHistory": myInfo.gameHistory,
                      "friend": myInfo.friend,
                     ])
        print("user:\(user.id)")
        print(Auth.auth().currentUser?.uid ?? "")
        //            fireStoreViewModel.userArray
        //        fetchPostits()
    }
    //게임히스토리 가져오기 //g0UxdNp6jHhavijbSJSZ //Auth.auth().currentUser?.uid ?? ""
    
    // MARK: - 지출 추가
    // user에 currentUserProfile 대입 => 내정보
    func addExpenditure(user: Msg,categoryAndExpenditure: String) {
        print(#function)
        database.collection("Challenge")
            .document(user.game) //게임의 아이디값
            .collection("expenditure")
            .document(user.id) // 나의 아이디값
            .setData(["id": user.id,
                      "addDay": Date(),
                      "expenditureHistory": categoryAndExpenditure,
                     ])
    }
//    currentUserProfile
//    struct expenditure: Codable, Identifiable {
//        //참석유저 아이디
//        var id: String
//        var totalMoney: Int
//        var addDay: Date
//        var expenditureHistory: [String:[String]]
//    }
    
    
    // MARK: - 게임 히스토리 ID 목록 가져오기
    /// 현재 유저가 진행했던 챌린지 ID리스트 가저오기
    func fetchGameHistoryList() async -> [String]? {
        print(#function)
        guard let userId = Auth.auth().currentUser?.uid else{ return nil }
        let ref = database.collection("User").document(userId)
        do{
            let snapShot = try await ref.getDocument()
            guard let docData = snapShot.data() else { return []}
            let array = docData["gameHistory"] as? [String] ?? []
            return array
            print(array)
        }catch{
            print("catched")
            return []
        }
    }
    
    
    // MARK: - 이전 챌린지기록을 모두 가져오는 함수
    /// 챌린지 이력보관함 데이터 불러오기
    func fetchPreviousGameHistory() async throws{
        print(#function)
        let ref = database.collection("ChallengeHistory")
        guard let challengesId = await fetchGameHistoryList() else { return }
        challengeHistoryArray.removeAll()
        for challengeId in challengesId{
            let document = try await ref.document(challengeId).getDocument()
            guard let docData = document.data() else { return }
            let id = docData["id"] as? String ?? ""
            let gameTitle = docData["gameTitle"] as? String ?? ""
            let limitMoney = docData["limitMoney"] as? Int ?? 0
            let startDate = docData["startDate"] as? String ?? ""
            let endDate = docData["endDate"] as? String ?? ""
            let inviteFriend = docData["inviteFriend"] as? [String] ?? []
            let challenge = Challenge(id: id, gameTitle: gameTitle, limitMoney: limitMoney, startDate: startDate, endDate: endDate, inviteFriend: inviteFriend)
            print("challenge출력확인:", challenge)
            challengeHistoryArray.append(challenge)
            print("array출력확인:",challengeHistoryArray)
        }
    }
    
    
    // MARK: - 챌린지 이력의 리스트 셀을 선택했을 시, 각 유저별 토탈 금액 가져오는 함수
    /// 챌린지 이력 리스트 셀 선택 시, 각 유저별 최종 금액 가져오는 함수
    func fetchChallengeTotalMoney(_ challengeId: String) async throws {
        print(#function)
        let ref = database.collection("ChallengeHistory").document(challengeId).collection("유저")
        challengeHistoryUserList.removeAll()
        let snapShots = try await ref.getDocuments()
        for document in snapShots.documents{
            let docData = document.data()
            let userId = document.documentID
            let totalMoney = docData["totalMoney"] as? Int ?? 0
            challengeHistoryUserList.append((userId: userId, totalMoney: totalMoney))
        }
    }
    
    
    // MARK: - 선택된 챌린지 소비 상세 이력을 불러오는 함수
    /// 해당 챌린지의 상세 소비 내역 불러오기
    func getGameHistory(_ challengeId: String) async throws {
        print(#function)
        guard let userId = Auth.auth().currentUser?.uid else{ return }
        let ref = database.collection("ChallengeHistory")
        let snapShot = try await ref.document(challengeId).collection("유저").document(userId).getDocument()
        if let docData = snapShot.data() {
            print("docData:",docData)
            let nickName: [String:[String]] = docData["지출"] as? [String:[String]] ?? [:]
            print(nickName)
        }
    }
    
    // MARK: - 싱글게임 추가 함수
    func addSingleGame(_ singleGame: Challenge) {
        print(#function)
        database.collection("Challenge").document(singleGame.id).setData([
            "id": singleGame.id,
            "gameTitle": singleGame.gameTitle,
            "limitMoney": singleGame.limitMoney,
            "startDate": singleGame.startDate,
            "endDate": singleGame.endDate,
            "inviteFriend": singleGame.inviteFriend
        ])
        self.newSingleGameId = singleGame.id
        singleGameList.append(singleGame)
    }
    
    // MARK: - User game에 String 추가하는 함수
    func updateUserGame(gameId: String) {
        print(#function)
        guard let userId = Auth.auth().currentUser?.uid else{ return }
        database.collection("User").document(userId).updateData([
            "game": gameId
        ])
    }
    
    // MARK: - SingleGame + User game에 String 추가하는 함수
    func makeSingleGame(_ singleGame: Challenge) {
        addSingleGame(singleGame)
        updateUserGame(gameId: singleGame.id)
        currentGame = singleGame
    }
    
    // MARK: - User game에 String 가져오는 함수
    func fetchGameId() async -> String? {
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
    
    // MARK: - Challenge Collection에서 진행중인 게임 정보 가져오기
    func fetchGame() async {
        print(#function)
        guard let gameId = await fetchGameId() else { return }
        // == Document Empty 예상 발생지 ==
        let ref = database.collection("Challenge").document(gameId)
        do {
            print("do 문에 들어왔습니다")
            let snapShot = try await ref.getDocument()
            print("정상적이라면 여기까지 출력이 됩니다")
            guard let docData = snapShot.data() else { return }
            let id = docData["id"] as? String ?? ""
            let gameTitle = docData["gameTitle"] as? String ?? ""
            let limitMoney = docData["limitMoney"] as? Int ?? 0
            let startDate = docData["startDate"] as? String ?? ""
            let endDate = docData["endDate"] as? String ?? ""
            let inviteFriend = docData["inviteFriend"] as? [String] ?? []
            let challenge = Challenge(id: id, gameTitle: gameTitle, limitMoney: limitMoney, startDate: startDate, endDate: endDate, inviteFriend: inviteFriend)
            self.currentGame = challenge
        } catch {
            print("catched")
        }
    }
    
    //MARK: - 진행이 끝난 게임을 gameHistory에 담아주는 함수
    func addGameHistory() async {
        // 히스토리의 배열을 불러와야하고
        guard let myInfo = try! await fetchUserInfo(Auth.auth().currentUser?.uid ?? "") else {return}
        let endGame = myInfo.game
        guard let myHistory = myInfo.gameHistory else{ return }
        var history = myHistory
        if !endGame.isEmpty{
            history.append(endGame)
        }
        
//        myHistory.append(myGame)
        // 불러온 배열에 내 게임id를 append해줘야 함
        try! await database.collection("User").document(myInfo.id).setData([
            "id": myInfo.id,
            "game": "",
            "gameHistory": history,
            "nickName": myInfo.nickName,
            "profileImage": myInfo.profilImage
        ])
    }
}
