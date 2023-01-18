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


class FireStoreViewModel: ObservableObject {
    @Published var userArray: [Msg] = []
    
    let database = Firestore.firestore()
    
    init() {
        //        postits = []
    }
    
    
    //    func fetchPostits() {
    //        database.collection("Postits")
    //            .getDocuments { (snapshot, error) in
    //                self.postits.removeAll()
    //
    //                if let snapshot {
    //                    for document in snapshot.documents {
    //                        let id: String = document.documentID
    //
    //                        let docData = document.data()
    //                        let user: String = docData["user"] as? String ?? ""
    //                        let memo: String = docData["memo"] as? String ?? ""
    //                        let colorIndex: Int = docData["colorIndex"] as? Int ?? 0
    //                        let createdAt: Double = docData["createdAt"] as? Double ?? 0
    //
    //                        let postit: Postit = Postit(id: id, user: user, memo: memo, colorIndex: colorIndex, createdAt: createdAt)
    //
    //                        self.postits.append(postit)
    //                    }
    //                }
    //            }
    //    }
    
    
    //프로필설정을 마치고 완료버튼을 눌렀을 때 발동
    func addUserInfo(user: Msg, downloadUrl: String) {
        database.collection("User")
            .document(Auth.auth().currentUser?.uid ?? "")
            .setData(["id": Auth.auth().currentUser?.uid ?? "",
                      "nickName": user.nickName,
                      "game": user.game,
                      "gameHistory": user.gameHistory,
                      "profilImage": downloadUrl])
        
        //        fetchPostits()
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
    
    //친구찾기
    func findFriend() {
        database
            .collection("User")
            .getDocuments { (snapshot, error) in
                self.userArray.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        
                        let docData = document.data()
                        let nickName: String = docData["nickName"] as? String ?? ""
                        let game: String = docData["game"] as? String ?? ""
                        let profilImage: String = docData["profilImage"] as? String ?? ""
                        
                        let getUser: Msg = Msg(id: id, nickName: nickName, profilImage: profilImage, game: game, gameHistory: [])
                        self.userArray.append(getUser)
                    }
                }
            }
    }
    
    //친구추가
//    func addUserInfo(user: Msg, myInfo: ??) {
//        database.collection("User")
//            .document(user.id)
//            .collection("friend")
//            .document(Auth.auth().currentUser?.uid ?? "")
//            .setData(["id": Auth.auth().currentUser?.uid ?? "",
//                      "nickName": user.nickName,
//                      "game": user.game,
//                      "gameHistory": user.gameHistory,
//                      "profilImage": downloadUrl])
//        
//        //        fetchPostits()
//    }
    
    //게임히스토리 가져오기
    func getGameHistory() async{
        let ref = database.collection("User").document(Auth.auth().currentUser?.uid ?? "")
        
        database
            .collection("User")
            .document(Auth.auth().currentUser?.uid ?? "")
            .getDocument { (snapshot, error) in
                self.userArray.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        
                        let docData = document.data()
                        let nickName: String = docData["nickName"] as? String ?? ""
                        let game: String = docData["game"] as? String ?? ""
                        let profilImage: String = docData["profilImage"] as? String ?? ""
                        
                        let getUser: Msg = Msg(id: id, nickName: nickName, profilImage: profilImage, game: game, gameHistory: [])
                        self.userArray.append(getUser)
                    }
                }
            }
    }
    
    //
    
    
    
    //    func removePostit(_ postit: Postit) {
    //        database.collection("Postits")
    //            .document(postit.id).delete()
    //        fetchPostits()
    //    }
}
