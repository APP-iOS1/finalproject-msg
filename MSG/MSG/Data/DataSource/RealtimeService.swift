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
    @Published var name: String = ""
    private var cancellable = Set<AnyCancellable>()
    let db: DatabaseReference
    
    init() {
        db = Database.database().reference()
        observeAdd()
    }
    func observeAdd() {
        print(#function)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.user.removeAll()
        db.child("Friend").child(uid)
            .toAnyPublisher()
            .sink { [weak self] (user: Msg?) in
                if let user, let self {
                    self.user.append(user)
                    print("유저에유:",user)
                }
            }.store(in: &cancellable)
    }
    
    
    
    func addObserve() -> AnyPublisher<Msg?, Never> {
        let uid = Auth.auth().currentUser!.uid
        let subject = CurrentValueSubject<Msg?, Never>(nil)
        let handle = db.child("Friend").child(uid).observe(.value, with: {snapshot in
            var json = snapshot.value as? [String:Any]
            let postitData = try! JSONSerialization.data(withJSONObject: json)
            let postit = try! JSONDecoder().decode(Msg.self, from: postitData)
            subject.send(postit as? Msg)
        })
        
        return subject.handleEvents (receiveCancel: {[ weak  self ] in
            self?.db.removeObserver(withHandle: handle)
        }).eraseToAnyPublisher()
    }
    
}

extension DatabaseReference {
    func toAnyPublisher<T>() -> AnyPublisher < T?, Never > {
        let subject =  CurrentValueSubject < T?, Never >( nil )

        let handle = observe(.value, with: {snapshot in
            subject.send(snapshot.value as? T)
        })
        
        return subject.handleEvents(receiveCancel: {[weak self] in
            self?.removeObserver(withHandle: handle)
        }).eraseToAnyPublisher()
    }
}

//    .observe(.childChanged) { [weak self] snapshot in
//        guard
//            let self = self,
//            var json = snapshot.value as? [String:Any]
//        else {
//            return
//        }
//        print("Changed Observe:",json)
//        json["id"] = snapshot.key
//
//        do {
//            let postitData = try JSONSerialization.data(withJSONObject: json)
//            print("change의 do문:",postitData)
//            let postit = try self.decoder.decode(Msg.self, from: postitData)
//            print(postit)
//
//            var index = 0
//            for postitItem in self.user {
//                if (postit.id == postitItem.id) {
//                    print(postitItem.id)
//                    self.user.remove(at: index)
//                }
//                index += 1
//            }
//            self.user.insert(postit, at: 0)
//            self.friendCount = self.user.count
//        } catch {
//            print("ChangeError")
//            print("an error occurred", error)
//        }
//}
