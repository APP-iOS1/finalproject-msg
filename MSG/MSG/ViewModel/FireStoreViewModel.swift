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
    @Published var myInfo: Msg?
    @Published var userArray: [Msg] = []
    @Published var invitedArray: [Msg] = []
    @Published var waitingArray: [Msg] = []
    @Published var challengeHistoryArray : [Challenge] = []
    @Published var challengeHistoryUserList : [(userId: String, totalMoney: Int)] = []
    //내친구
    @Published var myFrinedArray: [Msg] = []
    let database = Firestore.firestore()
    // 챌린지
    var newSingleGameId: String = ""
    @Published var singleGameList: [Challenge] = []
    @Published var currentGame: Challenge?
    @Published var expenditureList: [String: [String]] = [:]
    @Published var expenditure: Expenditure?
    @Published var totalMoney = 0
    @Published var nickNameCheck = false
    @Published var checkFightFriend: Challenge?
    
    init() {
        //        postits = []
        
    }
    
    
    
    // MARK: - 초대받은 챌린지 정보 가져오기
    /// 초대받은 챌린지의 정보를 가져오는 함수
    func fetchChallengeInformation(_ challengeId: String) async -> Challenge? {
        print(#function)
        let ref = database.collection("Challenge").document(challengeId)
        do{
            let document =  try await ref.getDocument()
            guard let docData = document.data() else { return nil}
            let id = docData["id"] as? String ?? ""
            let gameTitle = docData["gameTitle"] as? String ?? ""
            let limitMoney = docData["limitMoney"] as? Int ?? 0
            let startDate = docData["startDate"] as? String ?? ""
            let endDate = docData["endDate"] as? String ?? ""
            let inviteFriend = docData["inviteFriend"] as? [String] ?? []
            let waitingFriend = docData["waitingFriend"] as? [String] ?? []
            let challenge = Challenge(id: id, gameTitle:gameTitle , limitMoney: limitMoney, startDate: startDate, endDate: endDate, inviteFriend: inviteFriend, waitingFriend: waitingFriend)
            return challenge
        } catch{
            print("Error")
            return nil
        }
        
    }
    
    // MARK: - 멀티 게임 생성
    func addMultiGame(_ challenge: Challenge) async {
        print(#function)
        await updateUserGame(gameId: challenge.id)
        let ref = database.collection("Challenge").document(challenge.id)
        do{
            try await ref.setData([
                "id": challenge.id,
                "gameTitle": challenge.gameTitle,
                "limitMoney": challenge.limitMoney,
                "startDate": challenge.startDate,
                "endDate": challenge.endDate,
                "inviteFriend": [Auth.auth().currentUser?.uid],
                "waitingFriend": challenge.waitingFriend
            ])
            self.currentGame = challenge
        }catch{
            print("게임 추가 에러..")
        }
        
    }
    
    // MARK: - 게임 수락 시, invite목록에 추가하기 (1) Challenge
    func acceptGame(_ gameId: String) async {
        print(#function)
        guard let userId = Auth.auth().currentUser?.uid else{ return  }
        let ref = database.collection("User").document(userId)
        do{
            try await ref.updateData([
                "game" : gameId
            ])
            print("game에 참여하였습니다!")
        }catch{
            print("에러")
            
        }
    }
    // MARK: - 유저 정보를 불러오는 함수
    /// userId를 통해, 유저 정보를 가져온다.
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
        let friend = docData["friend"] as? [String] ?? []
        let userInfo = Msg(id: snapshot.documentID, nickName: nickName, profilImage: profileImage, game: game, gameHistory: gameHistory, friend: friend)
        return userInfo
    }
    
    // 프로필 닉네임 중복 체크
    func nickNameCheck(nickName: String) -> Bool {
        
        let ref = database.collection("User")
        
        let query = ref.whereField("nickName", isEqualTo: nickName)
        query.getDocuments() { (querySnapshot, err) in
            
            if querySnapshot!.documents.isEmpty {
                self.nickNameCheck = true
            } else {
                self.nickNameCheck = false
            }
        }
        
        return nickNameCheck
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
    
    func findUser(inviteId: [String], waitingId: [String]) {
        print(#function)
        self.invitedArray.removeAll()
        self.waitingArray.removeAll()
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
                        for i in inviteId {
                            if getUser.id == i {
                                self.invitedArray.append(getUser)
                            }
                        }
                        for i in waitingId {
                            if getUser.id == i {
                                self.waitingArray.append(getUser)
                            }
                        }
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
    func addExpenditure(user: Msg, tagName: String, convert: String) {
        print(#function)
        if let _ = expenditureList[tagName]{
            expenditureList[tagName]!.append(convert)
            print(expenditureList)
        }else{
            expenditureList[tagName] = [convert]
        }
        database.collection("Challenge")
            .document(user.game) //게임의 아이디값
            .collection("expenditure")
            .document(user.id) // 나의 아이디값
            .setData(["id": user.id,
                      "addDay": Date(),
                      "expenditureHistory": expenditureList
                     ])
        print(expenditureList)
    }
    
    //    currentUserProfile
    //    struct Expenditure: Codable, Identifiable {
    //        //참석유저 아이디
    //        var id: String
    //        var totalMoney: Int
    //        var addDay: Date
    //        var expenditureHistory: [String:[String]]
    //    }
    
    // MARK: - 지출 기록 가져오기
    func fetchExpenditure() async {
        print(#function)
        guard let gameId = await fetchGameId() else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = database.collection("Challenge").document(gameId).collection("expenditure").document(userId)
        do {
            let snapShot = try await ref.getDocument()
            guard let docData = snapShot.data() else { return print("실패해쒀")}
            let id = docData["id"] as? String ?? ""
            let expenditureHistory = docData["expenditureHistory"] as? [String: [String]] ?? [:]
            let expenditure = Expenditure(id: id, expenditureHistory: expenditureHistory)
            self.expenditureList = expenditure.expenditureHistory
            self.expenditure = expenditure
            print(expenditureList)
        } catch {
            print("catched")
        }
    }
    
    // MARK: - 게임 히스토리 ID 목록 가져오기
    /// 현재 유저가 진행했던 챌린지 ID리스트 가저오기
    func fetchGameHistoryList() async -> [String]? {
        print(#function)
        guard let userId = Auth.auth().currentUser?.uid else { return nil }
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
            let waitingFriend = docData["waitingFriend"] as? [String] ?? []
            let challenge = Challenge(id: id, gameTitle: gameTitle, limitMoney: limitMoney, startDate: startDate, endDate: endDate, inviteFriend: inviteFriend, waitingFriend: waitingFriend)
            //            print("challenge출력확인:", challenge)
            challengeHistoryArray.append(challenge)
            //            print("array출력확인:",challengeHistoryArray)
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
    func updateUserGame(gameId: String) async {
        print(#function)
        guard let userId = Auth.auth().currentUser?.uid else{ return }
        do{
            try await database.collection("User").document(userId).updateData([ "game": gameId ])
            self.myInfo = try await fetchUserInfo(userId)
            print("Game등록완료")
        }catch{
            print("미등록")
        }
    }
    
    // MARK: - SingleGame + User game에 String 추가하는 함수
    func makeSingleGame(_ singleGame: Challenge) async {
        addSingleGame(singleGame)
        await updateUserGame(gameId: singleGame.id)
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
            let waitingFriend = docData["waitingFriend"] as? [String] ?? []
            let challenge = Challenge(id: id, gameTitle: gameTitle, limitMoney: limitMoney, startDate: startDate, endDate: endDate, inviteFriend: inviteFriend, waitingFriend: waitingFriend)
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
    func addChallengeHistory(endGameData: Challenge?) async{
        
        guard let endGameData else { return }
        try! await database.collection("ChallengeHistory")
            .document(endGameData.id) //게임id
            .setData([
                "id": endGameData.id,
                "gameTitle": endGameData.gameTitle,
                "startDate": endGameData.startDate,
                "endDate": endGameData.endDate,
                "limitMoney": endGameData.limitMoney,
                "inviteFriend": endGameData.inviteFriend
            ])
    }
    
    //    @State private var challengeInfo: Challenge?
    func waitingLogic(data: Challenge?) async {
        print(#function)
        //패치해서 따끈한걸 받아와서 올려주기
        guard let data else {return}
        //새로 받는함수 추가
        guard let inviteGame = await fetchChallengeInformation(data.id) else { return }
        await doSomeThing(data: inviteGame)

    }
    
    
    func doSomeThing(data: Challenge) async {
        let ref = database.collection("Challenge").document(data.id)
        
        var firstIndex = data.waitingFriend.firstIndex { value in
            value == Auth.auth().currentUser?.uid
        }
        var array = data.waitingFriend
        array.remove(at: firstIndex!)
        do{
            try await ref.setData([
                "id": data.id,
                "gameTitle": data.gameTitle,
                "limitMoney": data.limitMoney,
                "startDate": data.startDate,
                "endDate": data.endDate,
                "inviteFriend": data.inviteFriend + [(Auth.auth().currentUser?.uid ?? "")],
                "waitingFriend": array
            ])
            self.currentGame = data
        }catch{
            print("게임 추가 에러..")
        }
    }
}
