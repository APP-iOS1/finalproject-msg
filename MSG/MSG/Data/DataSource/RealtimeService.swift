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
    @Published var requestCount: Int = 0
    @Published var name: String = ""
    @Published var requsetGameArr:[Msg] = []
    private var cancellable = Set<AnyCancellable>()
    let db: DatabaseReference
    
    init() {
        db = Database.database().reference()
    }
    
    private var gameRequestReference: DatabaseReference? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil}
        let ref = Database.database()
            .reference()
            .child("Game")
            .child(uid)
        return ref
    }
    
    
    func startObserve() {
        observeAdd()
        observeDelete()
        observeChanged()
    }
    
    func fetchRequest() {
        print(#function)
        observeGameRequestAdd()
        observeGameRequestChange()
        observeGameRequestDelete()
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
    
    //MARK: - 구분선 -
    
    func gameRequestAddPublish() -> AnyPublisher<Msg?, Never> {
//        guard let gameRequestReference else {}
        let subject = CurrentValueSubject<Msg?, Never>(nil)
        let handle = gameRequestReference!.observe(.childAdded, with: {snapshot in
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
    func observeGameRequestAdd() {
        print(#function)
        self.user.removeAll()
        gameRequestAddPublish()
            .sink { [weak self] (user: Msg?) in
                if let user, let self {
                    if !self.requsetGameArr.contains(user) {
                        self.requsetGameArr.insert(user, at: 0)
                        self.requestCount = self.requsetGameArr.count
                    }
                }
            }.store(in: &cancellable)
    }
    //MARK: - Change Observe
    func gameRequestChangePublish() -> AnyPublisher<Msg?, Never> {
//        guard let gameRequestReference else {}
        let subject = CurrentValueSubject<Msg?, Never>(nil)
        let handle = gameRequestReference!.observe(.childChanged, with: {snapshot in
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
    func observeGameRequestChange() {
        print(#function)
        var index = 0
        self.user.removeAll()
        gameRequestChangePublish()
            .sink { [weak self] (user: Msg?) in
                if let user, let self {
                    for postitItem in self.requsetGameArr {
                        if (user.id == postitItem.id) {
                            print(postitItem.id)
                            self.requsetGameArr.remove(at: index)
                        }
                        index += 1
                    }
                    self.requsetGameArr.insert(user, at: 0)
                    self.requestCount = self.requsetGameArr.count
                }
            }.store(in: &cancellable)
    }
    //MARK: - Delete Observe
    func gameRequestDeletePublish() -> AnyPublisher<Msg?, Never> {
//        guard let gameRequestReference else {return}
        let subject = CurrentValueSubject<Msg?, Never>(nil)
        let handle = gameRequestReference!.observe(.childRemoved, with: {snapshot in
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
    func observeGameRequestDelete() {
        print(#function)
        var index = 0
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.user.removeAll()
        gameRequestDeletePublish()
            .sink { [weak self] (user: Msg?) in
                if let user, let self {
                    for postitItem in self.requsetGameArr {
                        if (user.id == postitItem.id) {
                            self.requsetGameArr.remove(at: index)
                        }
                        index += 1
                    }
                    self.requsetGameArr = Array(Set(self.requsetGameArr))
                    self.requestCount = self.requsetGameArr.count
                }
            }.store(in: &cancellable)
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
    
    func sendFightRequest(to: [Msg], from: Msg, isFight: Bool) {
        for friend in to {
            let dict: [String: Any] = [
                "id": from.id,// ㅇ
                "nickName": from.nickName, //ㅇ
                "profileImage": from.profileImage, //ㅇ
                "game": from.game, //ㅇ
                "gameHistory": from.gameHistory ?? []
//                "friend": from.friend ?? []
            ]

            Database.database()
            .reference()
            .child("Game")
            .child(friend.id).child(Auth.auth().currentUser?.uid ?? "").setValue(dict)
        }
    }
    
    
}
