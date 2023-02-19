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
//        print(#function)
//        print("input Value:",text)
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
                        print("getUser:",getUser)
                    }
                }
                notGamePlayFriend = Array(Set(notGamePlayFriend))
            }
            print("스토어에서 데이터:",notGamePlayFriend)
            return notGamePlayFriend
        } catch {
            print("error!")
            return []
        }
    }
    @MainActor
    func findFriend() async throws -> ([Msg],[String]){
//        print("Impl",#function)
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
//        print(#function)
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

extension FirebaseService: ChallengeViewDataSource {
    func parsingExpenditure(expenditure: [String : [String]]) {
        var totalMoney = 0
        for (_ , key) in expenditure {
            for moneyHistory in key {
                for i in moneyHistory.components(separatedBy: "_") {
                    if let money = Int(i) {
                        totalMoney += money
                        print(money)
                    }
                }
            }
        }
    }
    
    func findUser(inviteId: [String], waitingId: [String]) async -> ([Msg],[Msg]) {
        print(#function)
        var invitedArray: [Msg] = []
        var waitingArray: [Msg] = []
        
        invitedArray.removeAll()
        waitingArray.removeAll()
        do{
            let snapshot = try await database.collection("User").getDocuments()
            for document in snapshot.documents{
                let id: String = document.documentID
                let docData = document.data()
                let nickName: String = docData["nickName"] as? String ?? ""
                let profileImage: String = docData["profileImage"] as? String ?? ""
                let game: String = docData["game"] as? String ?? ""
                let gameHistory: [String] = docData["gameHistory"] as? [String] ?? []
//                let friend: [String] = docData["friend"] as? [String] ?? []
                let getUser: Msg = Msg(id: id, nickName: nickName, profileImage: profileImage, game: game, gameHistory: gameHistory)
                for i in inviteId {
                    if getUser.id == i {
                        invitedArray.append(getUser)
                    }
                }
                for i in waitingId {
                    if getUser.id == i {
                        waitingArray.append(getUser)
                    }
                }
            }
            return (invitedArray,waitingArray)
        } catch{
            print("Faile Find User")
            return ([],[])
        }
        
    }
    
    func findFriend() {
        print(#function)
        guard let userId = Auth.auth().currentUser?.uid else{ return }
        var myFriendArray: [Msg] = []
        var userArray: [Msg] = []
        database
            .collection("User")
            .document(userId)
            .collection("friend")
            .getDocuments { (snapshot, error) in
                userArray.removeAll()
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        print("id:\(id)")
                        let docData = document.data()
                        let nickName: String = docData["nickName"] as? String ?? ""
                        let profileImage: String = docData["profileImage"] as? String ?? ""
                        let game: String = docData["game"] as? String ?? ""
                        let gameHistory: [String] = docData["gameHistory"] as? [String] ?? []
//                        let friend: [String] = docData["friend"] as? [String] ?? []
                        
                        let getUser: Msg = Msg(id: id, nickName: nickName, profileImage: profileImage, game: game, gameHistory: gameHistory)
                        print("findFriend:", myFriendArray)
                        myFriendArray.append(getUser)
                    }
                    myFriendArray = Array(Set(myFriendArray))
                }
            }
    }
    
    // MARK: - Challenge Collection에서 진행중인 게임 정보 가져오기
    func fetchGame() async {
        print(#function)
        
//        var currentGame: Challenge?
        
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
            let currentGame = challenge
//            print(self.invitedArray)
//            print(self.waitingArray)
        } catch {
            print("catched")
        }
    }
    
    func fetchGameReturn() async -> Challenge? {
        print(#function)
        
//        var currentGame: Challenge?
        
        guard let gameId = await fetchGameId() else { return nil }
        // == Document Empty 예상 발생지 ==
        let ref = database.collection("Challenge").document(gameId)
        do {
            print("do 문에 들어왔습니다")
            let snapShot = try await ref.getDocument()
            print("정상적이라면 여기까지 출력이 됩니다")
            guard let docData = snapShot.data() else { return nil }
            let id = docData["id"] as? String ?? ""
            let gameTitle = docData["gameTitle"] as? String ?? ""
            let limitMoney = docData["limitMoney"] as? Int ?? 0
            let startDate = docData["startDate"] as? String ?? ""
            let endDate = docData["endDate"] as? String ?? ""
            let inviteFriend = docData["inviteFriend"] as? [String] ?? []
            let waitingFriend = docData["waitingFriend"] as? [String] ?? []
            let challenge = Challenge(id: id, gameTitle: gameTitle, limitMoney: limitMoney, startDate: startDate, endDate: endDate, inviteFriend: inviteFriend, waitingFriend: waitingFriend)
            let currentGame = challenge
            return currentGame
//            print(self.invitedArray)
//            print(self.waitingArray)
        } catch {
            print("catched")
        }
        return nil
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
    
    // MARK: - 유저 정보를 불러오는 함수
    /// userId를 통해, 유저 정보를 가져온다.
    func challengefetchUserInfo(_ userId: String) async throws -> Msg? {
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
    
    //MARK: - 진행이 끝난 게임을 gameHistory에 담아주는 함수
    func addGameHistory() async {
        // 히스토리의 배열을 불러와야하고
        guard let myInfo = try! await challengefetchUserInfo(Auth.auth().currentUser?.uid ?? "") else {return}
        let endGame = myInfo.game
        guard let myHistory = myInfo.gameHistory else{ return }
        var history = myHistory
        if !endGame.isEmpty{ history.append(endGame) }
//        myHistory.append(myGame)
        // 불러온 배열에 내 게임id를 append해줘야 함
        try! await database.collection("User").document(myInfo.id).setData([
            "id": myInfo.id,
            "game": "",
            "gameHistory": history,
            "nickName": myInfo.nickName,
            "profileImage": myInfo.profileImage
        ])
    }
    
    // MARK: - MultiGame 중도포기(개인)
    func giveUpMultiGame() async {
        print(#function)
        await deleteGameExpenditure()
        // 1. 게임 아이디에 맞는 지출 내역불러와서 삭제
        // 2. 멀티게임에 접근해서 친구목록에 내 아이디 삭제
        // 3. 유저의 게임에 아이디 삭제
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let gameId = await fetchGameId() else { return }
        let ref = database.collection("Challenge").document(gameId)
        
        do {
            try await ref.updateData(["inviteFriend" : FieldValue.arrayRemove([userId])])
            print("멀티 게임 중도 포기 완료")
        } catch {
            print("멀티 게임 중도 포기 실패")
        }
        await deleteGameId()
    }
    
    // MARK: - Game 지출 내역 전체 삭제
    func deleteGameExpenditure() async {
        print(#function)
        guard let gameId = await fetchGameId() else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        do {
            try await database.collection("Challenge").document(gameId).collection("expenditure").document(userId).delete()
            print("지출 내역 삭제")
        } catch {
            print("지출 내역 삭제 실패")
        }
    }
    
    
    // MARK: - GameId 삭제
    func deleteGameId() async {
        print(#function)
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await database.collection("User").document(userId).updateData([ "game": "" ])
            let myInfo = try await fetchUserInfo(userId)
            print("게임아이디 삭제 완료")
        } catch {
            print("게임아이디 삭제 실패")
        }
    }
    
    // MARK: - SingleGame 중도포기(삭제)
    func deleteSingleGame() async {
        print(#function)
        await deleteGameExpenditure()
        guard let gameId = await fetchGameId() else { return }
        do {
            try await database.collection("Challenge").document(gameId).delete()
            print("삭제 완료")
        } catch {
            print("삭제 실패")
        }
        await deleteGameId()
    }
    
    // MARK: - 지출 기록 가져오기
    /// 현재 유저의 지출기록을 가져온다.
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
            let totalMoney = docData["totalMoney"] as? Int ?? 0
            let expenditure = Expenditure(id: id, totalMoney: totalMoney, expenditureHistory: expenditureHistory)
            let expenditureList = expenditure.expenditureHistory
//            self.expenditure = expenditure
            print(expenditureList)
            print(expenditure)
        } catch {
            print("catched")
        }
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
    
    func makeMultiGame(_ multiGame:Challenge) async{
        print(#function)
        guard let hostId = Auth.auth().currentUser?.uid else { return }
        do{
            try await database.collection("Challenge").document(multiGame.id).setData([
                "id": multiGame.id,
                "gameTitle": multiGame.gameTitle,
                "limitMoney": multiGame.limitMoney,
                "startDate": multiGame.startDate,
                "endDate": multiGame.endDate,
                "inviteFriend": [hostId],
                "waitingFriend" : multiGame.waitingFriend
            ])
            await updateUserGame(gameId: multiGame.id)
        }catch{
            print("Error #MAKE MULTI Game")
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

extension FirebaseService: DivideFriendDataSource {
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
    func findUser(text: String) async throws -> [String] {
//        print(#function)
//        self.searchUserArray.removeAll()
        var searchUserArray: [String] = []
        let snapShots = try await database.collection("User").getDocuments()
        for document in snapShots.documents{
            let id: String = document.documentID
            let docData = document.data()
            let nickName: String = docData["nickName"] as? String ?? ""
//            nickName.lowercased()
            if nickName.lowercased().contains(text.lowercased()) && id != Auth.auth().currentUser?.uid {
                searchUserArray.append(id)
            }
        }
        return searchUserArray
    }
    


    
    
    // MARK: - 친구 요청을 보낸 경우, 수락했는지 확인하는 리스너
//    func subscribe() -> [String]{
//        print(#function)
//        var listener: ListenerRegistration?
//        var sendToFriendArray: [String] = []
//        guard let uid = Auth.auth().currentUser?.uid else { return []}
//        let ref = database.collection("Waiting").document(uid)
//        listener = ref.addSnapshotListener { querySnapshot, error in
//            guard let document = querySnapshot  else { return }
//            guard let docData = document.data() else { return }
//            sendToFriendArray = docData["sendToFriend"] as? [String] ?? []
////            Task { try await self.findFriend() }
//            print("== check subscribe == :",sendToFriendArray)
////            print("외안되")
//        }
//        return sendToFriendArray
//    }
    
    
    // MARK: -  친구에게 친구초대 보낼 경우, sendToFriendArray에 해당 유저 넣기
    /// 친구가 친구수락을 받을때까지, sendToFriendArray에 친구 아이디 저장
    func uploadSendToFriend(_ userId: String, sendToFriendArray: [String]){
        print(#function)
//        var sendToFriendArray: [String] = []
        guard let uid = Auth.auth().currentUser?.uid else { return }
        database.collection("Waiting").document(uid).setData([ "sendToFriend": sendToFriendArray + [userId] ])
    }
}
//protocol AddFriendDataSource {
//    func myInfo() //f
//    func addUser() // f
//    func deleteWaitingFriend() // f
//}


//
// MARK: - ChallengeRecord API(실제 데이터 받는 위치)
extension FirebaseService: ChallengeRecordDataSource {
    // MARK: - 유저 정보를 불러오는 함수
    func challengeRecordfetchUserInfo(_ userId: String) async throws -> Msg? {
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

extension FirebaseService: GameRequestDataSourceWithFirebase {
    
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
    
    func waitingLogic(data: Challenge?) async {
        print(#function)
        //패치해서 따끈한걸 받아와서 올려주기
        guard let data else {return}
        //새로 받는함수 추가
        guard let inviteGame = await fetchChallengeInformation(data.id) else { return }
        await doSomeThing(data: inviteGame)

    }
    
    func doSomeThing(data: Challenge) async -> Challenge? {
        let ref = database.collection("Challenge").document(data.id)
        do{
            try await ref.setData([
                "id": data.id,
                "gameTitle": data.gameTitle,
                "limitMoney": data.limitMoney,
                "startDate": data.startDate,
                "endDate": data.endDate,
                "inviteFriend": data.inviteFriend + [(Auth.auth().currentUser?.uid ?? "")],
                "waitingFriend": data.waitingFriend
            ])
//            self.currentGame = data
            return data
        }catch{
            print("게임 추가 에러..")
            return nil
        }
    }
    
    func notAllowChallegeStep1(data: [Msg]?) async {
        print(#function)
        print("data 체크중입니다:",data)
        //패치해서 따끈한걸 받아와서 올려주기
        guard let data else {
            print("리턴문에 들어옴")
            return
            
        }
        //새로 받는함수 추가
        for eachGame in data {
            print("for문에 들어옴:",eachGame.nickName)
            guard let inviteGame = await fetchChallengeInformation(eachGame.game) else { return }
            notAllowChallegeStep2(data: inviteGame)
        }

    }
    
    func notAllowChallegeStep2(data: Challenge) {
        print(#function)
        let ref = database.collection("Challenge").document(data.id)
        
        let firstIndex = data.waitingFriend.firstIndex { value in
            value == Auth.auth().currentUser?.uid
        }
        var array = data.waitingFriend
        print(array[firstIndex!])
        array.remove(at: firstIndex!)
        do{
            try ref.setData([
                "id": data.id,
                "gameTitle": data.gameTitle,
                "limitMoney": data.limitMoney,
                "startDate": data.startDate,
                "endDate": data.endDate,
                "inviteFriend": data.inviteFriend,
                "waitingFriend": array
            ])
            print("배열값:",array)
        }catch{
            print("게임 거절 에러..")
        }
    }
    
    
}

extension FirebaseService: WaitingDataSource {
    func addMultiGameDeleteWaitUserFiveMinute(_ challenge: Challenge) async -> Challenge? {
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
                "inviteFriend": challenge.inviteFriend,
                "waitingFriend": []
            ])
            let data = challenge
            return data
        }catch{
            print("게임 추가 에러..")
            return nil
        }
    }
}
