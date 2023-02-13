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
