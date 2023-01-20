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
    @Published var userArray: [UserInfo] = []
    @Published var challengeHistoryArray : [Challenge] = []
    @Published var challengeHistoryUserList : [(userId: String, totalMoney: Int)] = []
    @Published var myFrinedArray: [UserInfo] = []
    let database = Firestore.firestore()

    
    init() {
        //        postits = []
    }
    
   
    // MARK: - 유저 정보를 불러오는 함수
    /// userId를 통해, 유저 정보를 가져온다.
    func fetchUserInfo(_ userId: String) async throws -> Msg? {
        let ref = database.collection("User").document(userId)
        let snapshot = try await ref.getDocument()
        guard let docData = snapshot.data() else { return nil }
        let nickName = docData["nickName"] as? String ?? ""
        let profileImage = docData["profileImage"] as? String ?? ""
        let userInfo = Msg(id: snapshot.documentID, nickName: nickName, profilImage: profileImage, game: "", gameHistory: [])
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
                      "profileImage": downloadUrl])

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
    func findUser() {
        database
            .collection("User")
            .getDocuments { (snapshot, error) in
                self.userArray.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        
                        let docData = document.data()
                        let userName: String = docData["userName"] as? String ?? ""
                        let userImage: String = docData["userImage"] as? String ?? ""
                        let isFriend: Bool = docData["isFriend"] as? Bool ?? false
                        let isFight: Bool = docData["isFight"] as? Bool ?? false
                        
                        let getUser: UserInfo = UserInfo(id: id, userName: userName, userImage: userImage, isFriend: isFriend, isFight: isFight)
                        self.userArray.append(getUser)
                    }
                }
            }
    }
    
    //친구찾기
    func findFriend() {
        database
            .collection("User")
            .document(Auth.auth().currentUser?.uid ?? "")
            .collection("frined")
            .getDocuments { (snapshot, error) in
                self.userArray.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        
                        let docData = document.data()
                        let userName: String = docData["userName"] as? String ?? ""
                        let userImage: String = docData["userImage"] as? String ?? ""
                        let isFriend: Bool = docData["isFriend"] as? Bool ?? false
                        let isFight: Bool = docData["isFight"] as? Bool ?? false
                        
                        let getUser: UserInfo = UserInfo(id: id, userName: userName, userImage: userImage, isFriend: isFriend, isFight: isFight)
                        self.myFrinedArray.append(getUser)
                    }
                }
            }
    }
    //친구추가
        func addUserInfo(user: UserInfo) {
            database.collection("User")
                .document(Auth.auth().currentUser?.uid ?? "")
                .collection("friend")
                .document(user.id)
                .setData(["id": user.id,
                          "nickName": user.userName,
                          "userImage": user.userImage,
                          "isFriend": user.isFriend,
                          "isFight": user.isFight,
//                          "profilImage": downloadUrl
                         ])
            myFrinedArray.append(user)
//            fireStoreViewModel.userArray
            //        fetchPostits()
        }
    //게임히스토리 가져오기 //g0UxdNp6jHhavijbSJSZ //Auth.auth().currentUser?.uid ?? ""
    
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
            challengeHistoryArray.append(challenge)
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
}
//



//    func removePostit(_ postit: Postit) {
//        database.collection("Postits")
//            .document(postit.id).delete()
//        fetchPostits()
//    }

