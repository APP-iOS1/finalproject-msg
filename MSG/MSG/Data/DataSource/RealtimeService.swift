//
//  RealtimeService.swift
//  MSG
//
//  Created by 김민호 on 2023/02/13.
//

import Combine
import Foundation
import FirebaseDatabase
import FirebaseAuth

class RealtimeService: ObservableObject {
    @Published var user: [Msg] = []
    @Published var friendCount: Int = 0
    @Published var name: String = ""
    private var cancellable = Set<AnyCancellable>()
    let db: DatabaseReference
    
    init() {
        db = Database.database().reference()
    }
    
    func startObserve() {
        observeAdd()
        observeDelete()
        observeChanged()
    }
    
    //MARK: - Add Observe
    func addObserve() -> AnyPublisher<Msg?, Never> {
        let uid = Auth.auth().currentUser!.uid
        let subject = CurrentValueSubject<Msg?, Never>(nil)
        let handle = db.child("Friend").child(uid).observe(.childAdded, with: {snapshot in
            if let json = snapshot.value as? [String:Any] {
                print("json:",json)
                if let postitData = try? JSONSerialization.data(withJSONObject: json) {
                    print("postitData:",postitData)
                    if let postit = try? JSONDecoder().decode(Msg.self, from: postitData) {
                        subject.send(postit)
                    }
                }
            }
        })
        
        return subject.handleEvents (receiveCancel: {[ weak  self ] in
            self?.db.removeObserver(withHandle: handle)
        }).eraseToAnyPublisher()
    }
    func observeAdd() {
        print(#function)
        self.user.removeAll()
        addObserve()
            .sink { [weak self] (user: Msg?) in
                if let user, let self {
                    self.user.insert(user, at: 0)
                    self.user = Array(Set(self.user))
                    self.friendCount = self.user.count
                }
            }.store(in: &cancellable)
    }
    //MARK: - Change Observe
    func changeObserve() -> AnyPublisher<Msg?, Never> {
        let uid = Auth.auth().currentUser!.uid
        let subject = CurrentValueSubject<Msg?, Never>(nil)
        let handle = db.child("Friend").child(uid).observe(.childChanged, with: {snapshot in
            if let json = snapshot.value as? [String:Any] {
                print("json:",json)
                if let postitData = try? JSONSerialization.data(withJSONObject: json) {
                    print("postitData:",postitData)
                    if let postit = try? JSONDecoder().decode(Msg.self, from: postitData) {
                        subject.send(postit)
                    }
                }
            }
        })
        return subject.handleEvents (receiveCancel: {[ weak  self ] in
            self?.db.removeObserver(withHandle: handle)
        }).eraseToAnyPublisher()
    }
    func observeChanged() {
        print(#function)
        var index = 0
        self.user.removeAll()
        changeObserve()
            .sink { [weak self] (user: Msg?) in
                if let user, let self {
                    for postitItem in self.user {
                        if (user.id == postitItem.id) {
                            print(postitItem.id)
                            self.user.remove(at: index)
                        }
                        index += 1
                    }
                    self.user.insert(user, at: 0)
                    self.friendCount = self.user.count
                }
            }.store(in: &cancellable)
    }
    //MARK: - Delete Observe
    func deleteObserve() -> AnyPublisher<Msg?, Never> {
        let uid = Auth.auth().currentUser!.uid
        let subject = CurrentValueSubject<Msg?, Never>(nil)
        let handle = db.child("Friend").child(uid).observe(.childRemoved, with: {snapshot in
            if let json = snapshot.value as? [String:Any] {
                print("json:",json)
                if let postitData = try? JSONSerialization.data(withJSONObject: json) {
                    print("postitData:",postitData)
                    if let postit = try? JSONDecoder().decode(Msg.self, from: postitData) {
                        subject.send(postit)
                    }
                }
            }
        })
        return subject.handleEvents (receiveCancel: {[ weak  self ] in
            self?.db.removeObserver(withHandle: handle)
        }).eraseToAnyPublisher()
    }
    func observeDelete() {
        print(#function)
        var index = 0
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.user.removeAll()
        deleteObserve()
            .sink { [weak self] (user: Msg?) in
                if let user, let self {
                    for postitItem in self.user {
                        if (user.id == postitItem.id) {
                            self.user.remove(at: index)
                        }
                        index += 1
                    }
                    self.user = Array(Set(self.user))
                    self.friendCount = self.user.count
                }
            }.store(in: &cancellable)
    }
    
    func fetchGameRequest() async{
        print(#function)
        guard let gameRequestReference else {
            print("guard문으로 리턴됨")
            return
        }
        gameRequestReference
            .observe(.childAdded) { [weak self] snapshot in
                guard
                    let self = self,
                    var json = snapshot.value as? [String:Any]
                else {
                    print("나가짐")
                    return
                }
                
                print("Add Observe:",json)
                json["id"] = snapshot.key
                do {
                    let userData = try JSONSerialization.data(withJSONObject: json)
                    print("add postitData:",userData)
                    let user = try self.decoder.decode(Msg.self, from: userData)
                    print("받음:",user)
                    if !self.requsetGameArr.contains(user){
                        self.requsetGameArr.insert(user, at: 0)
                        self.requsetCount = self.requsetGameArr.count
                    }
                } catch {
                    print("AddError")
                    print("an error occurred", error)
                }
        }
        
        gameRequestReference
            .observe(.childChanged) { [weak self] snapshot in
                guard
                    let self = self,
                    var json = snapshot.value as? [String:Any]
                else {
                    return
                }
                print("Changed Observe:",json)
                json["id"] = snapshot.key
                
                do {
                    let postitData = try JSONSerialization.data(withJSONObject: json)
                    print("change의 do문:",postitData)
                    let postit = try self.decoder.decode(Msg.self, from: postitData)
                    print(postit)

                    var index = 0
                    for postitItem in self.requsetGameArr {
                        if (postit.id == postitItem.id) {
                            print(postitItem.id)
                            self.requsetGameArr.remove(at: index)
                        }
                        index += 1
                    }
                    self.requsetGameArr.insert(postit, at: 0)
                    self.requsetCount = self.requsetGameArr.count
                } catch {
                    print("ChangeError")
                    print("an error occurred", error)
                }
        }
        
        gameRequestReference
            .observe(.childRemoved) {  [weak self] snapshot in
                guard
                    let self = self,
                    var json = snapshot.value as? [String: Any]
                else {
                    return
                }
                print("Delete Observe:",json)
                json["id"] = snapshot.key
                
                do {
                    let postitData = try JSONSerialization.data(withJSONObject: json)
                    print("remove의 do문:",postitData)
                    let postit = try self.decoder.decode(Msg.self, from: postitData)
                    print(postit)
                    
                    var index = 0
                    for postitItem in self.requsetGameArr {
                        if (postit.id == postitItem.id) {
                            print(postitItem.id)
                            self.requsetGameArr.remove(at: index)
                        }
                        index += 1
                    }
                    self.requsetCount = self.requsetGameArr.count
                } catch {
                    print("removeError")
                    print("an error occurred", error)
                }
            }
    }
}



// 나중에 빼야함
extension DatabaseReference {
    func toAnyPublisher<T:Decodable>() -> AnyPublisher < T?, Never > {
        print(#function)
        let subject =  CurrentValueSubject < T?, Never >( nil )

        let handle = observe(.value, with: {snapshot in
            var json = snapshot.value as? [String:Any]
            let postitData = try! JSONSerialization.data(withJSONObject: json)
            let postit = try! JSONDecoder().decode(T.self, from: postitData)
            subject.send(postit as? T)
            print("snapshot.value:",snapshot.value)
        })
        
        return subject.handleEvents(receiveCancel: {[weak self] in
            self?.removeObserver(withHandle: handle)
        }).eraseToAnyPublisher()
    }
}

struct Real: AddFriendDataSourceWithRealTimeDB {
    func acceptAddFriend(friend: Msg) {
        print("add Friend id: \(friend.id)")
        Database.database()
            .reference()
            .child("Friend")
            .child(Auth.auth().currentUser?.uid ?? "")
            .child(friend.id)
            .removeValue()
    }
    //초대보내기
    func sendFriendRequest(to: Msg, from: Msg) {
        print(#function)
        let dict: [String: Any] = [
            "id": from.id,
            "nickName": from.nickName,
            "profileImage": from.profileImage,
            "game": from.game,
            "gameHistory": from.gameHistory ?? []
        ]
        Database.database()
        .reference()
        .child("Friend")
        .child(to.id).child(Auth.auth().currentUser?.uid ?? "").setValue(dict)
    }
}

extension Real: GameRequestDataSourceWithRealtimeDB {
    
    func acceptGameRequest(friend: Msg) async{
        print("add Friend id: \(friend.id)")
        try! await Database.database()
            .reference()
            .child("Game")
            .child(Auth.auth().currentUser?.uid ?? "")
//            .child(friend.id)
            .removeValue()
    }
    
    func afterFiveMinuteDeleteChallenge(friend: Msg) async{
        print("add Friend id: \(friend.id)")
        try! await Database.database()
            .reference()
            .child("Game")
            .child(Auth.auth().currentUser?.uid ?? "")
            .child(friend.id)
            .removeValue()
    }
    
    func afterFiveMinuteDeleteChallenge(friend: String) async{
        print("add Friend id: \(friend)")
        try! await Database.database()
            .reference()
            .child("Game")
            .child(friend)
            .child(Auth.auth().currentUser?.uid ?? "")
            .removeValue()
    }
    
    
}
