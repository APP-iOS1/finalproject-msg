//
//  PostitStore.swift
//  HelloDemo
//
//  Created by Jongwook Park on 2022/12/08.
//

import Foundation
import FirebaseDatabase

class PostitStore: ObservableObject {
    @Published var msg: [Msg] = []
    @Published var user: [UserInfo] = []

    private lazy var databaseReference: DatabaseReference? = {
            let ref = Database.database()
            .reference()
            .child("msg")
            .child("-NLxpNi8nQaiTyzooS-N")
        
            return ref
        }()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    
    //받아오기
    func startFetching() {
        guard let databaseReference else {
            return
        }
        
        databaseReference
            .observe(.childAdded) { [weak self] snapshot in
                guard
                    let self = self,
                    var json = snapshot.value as? [String: Any]
                else {
                    return
                }
                
                json["id"] = snapshot.key
                
                do {
                    let postitData = try JSONSerialization.data(withJSONObject: json)
                    let postit = try self.decoder.decode(UserInfo.self, from: postitData)
                    print("받음:",postit)
                    self.user.insert(postit, at: 0)
                } catch {
                    print("an error occurred", error)
                }
        }
        
        databaseReference
            .observe(.childChanged) { [weak self] snapshot in
                guard
                    let self = self,
                    var json = snapshot.value as? [String: Any]
                else {
                    return
                }
                
                json["id"] = snapshot.key
                
                do {
                    let postitData = try JSONSerialization.data(withJSONObject: json)
                    let postit = try self.decoder.decode(UserInfo.self, from: postitData)
                    print(postit)
                    
                    var index = 0
                    for postitItem in self.user {
                        if (postit.id == postitItem.id) {
                            print(postitItem.id)
                            self.user.remove(at: index)
                        }
                        index += 1
                    }
                    
                    self.user.insert(postit, at: 0)
                } catch {
                    print("an error occurred", error)
                }
        }
        
        databaseReference
            .observe(.childRemoved) {  [weak self] snapshot in
                guard
                    let self = self,
                    var json = snapshot.value as? [String: Any]
                else {
                    return
                }
                
                json["id"] = snapshot.key
                
                do {
                    let postitData = try JSONSerialization.data(withJSONObject: json)
                    let postit = try self.decoder.decode(UserInfo.self, from: postitData)
                    print(postit)
                    
                    var index = 0
                    for postitItem in self.msg {
                        if (postit.id == postitItem.id) {
                            print(postitItem.id)
                            self.msg.remove(at: index)
                        }
                        index += 1
                    }
                } catch {
                    print("an error occurred", error)
                }
            }
    }
    
    func addPostit(postit: Msg) {
        databaseReference?.childByAutoId().setValue([
            "id": postit.id,
        ])
    }
    
    func addPostit2(postit: Msg, userInfo: UserInfo) {
        databaseReference?
            .child("-NLxpNi8nQaiTyzooS-N").childByAutoId().setValue([
            "id": userInfo.id,
            "userName": userInfo.userName,
            "userImage": userInfo.userImage,
            "isFriend": userInfo.isFriend,
            "isFight": userInfo.isFight,
        ])
    }
    
    
    func deletePostit(postit: Msg) {
        print("delete id: \(postit.id)")
        databaseReference?.child(postit.id).removeValue()
    }
    
    func stopFetching() {
        databaseReference?.removeAllObservers()
    }
}
