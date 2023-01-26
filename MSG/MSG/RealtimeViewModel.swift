import Foundation
import FirebaseDatabase
import FirebaseAuth

class RealtimeViewModel: ObservableObject {
    @Published var user: [Msg] = []
//    @Published var user: [UserInfo] = []
    @Published var myInfo: Msg?
    // 초대메세지를 보낼 친구들의 배열
    @Published var inviteFriendArray: [Msg] = []
    @Published var requsetGameArr:[Msg] = []
    
    @Published var inviteFriendIdArray:[String] = []
        
    //친구 요청 수락
    private var friendRequestReference: DatabaseReference? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil}
        let ref = Database.database()
            .reference()
            .child("Friend")
            .child(uid)
        return ref
    }
    
    // 도전장 요청
    private var gameRequestReference: DatabaseReference? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil}
        let ref = Database.database()
            .reference()
            .child("Game")
            .child(uid)
        return ref
    }
    
    private lazy var databaseReference: DatabaseReference? = {
        guard let uid = Auth.auth().currentUser?.uid else { return nil}
            let ref = Database.database()
            .reference()
            .child(uid)
            return ref
        }()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    //친구 -> 친구목록
  
    //받아오기
    func startFetching() {
        print(#function)
        guard let databaseReference else {
            print("guard문으로 리턴됨")
            return
        }
        databaseReference
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
                    let postitData = try JSONSerialization.data(withJSONObject: json)
                    print("add postitData:",postitData)
                    let postit = try self.decoder.decode(Msg.self, from: postitData)
                    print("받음:",postit)
                    self.user.insert(postit, at: 0)
                    self.user = Array(Set(self.user))
                } catch {
                    print("AddError")
                    print("an error occurred", error)
                }
        }
        
        databaseReference
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
                    for postitItem in self.user {
                        if (postit.id == postitItem.id) {
                            print(postitItem.id)
                            self.user.remove(at: index)
                        }
                        index += 1
                    }
                    self.user.insert(postit, at: 0)
                } catch {
                    print("ChangeError")
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
                print("Delete Observe:",json)
                json["id"] = snapshot.key
                
                do {
                    let postitData = try JSONSerialization.data(withJSONObject: json)
                    print("remove의 do문:",postitData)
                    let postit = try self.decoder.decode(Msg.self, from: postitData)
                    print(postit)
                    
                    var index = 0
                    for postitItem in self.user {
                        if (postit.id == postitItem.id) {
                            print(postitItem.id)
                            self.user.remove(at: index)
                        }
                        index += 1
                    }
                } catch {
                    print("removeError")
                    print("an error occurred", error)
                }
            }
    }
    
    
    
    // MARK: - 친구 요청 리스너
    func fetchFriendRequest(){
        print(#function)
        guard let friendRequestReference else {
            print("guard문으로 리턴됨")
            return
        }
        friendRequestReference
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
                    let postitData = try JSONSerialization.data(withJSONObject: json)
                    print("add postitData:",postitData)
                    let postit = try self.decoder.decode(Msg.self, from: postitData)
                    print("받음:",postit)
                    self.user.insert(postit, at: 0)
                    self.user = Array(Set(self.user))
                } catch {
                    print("AddError")
                    print("an error occurred", error)
                }
        }
        
        friendRequestReference
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
                    for postitItem in self.user {
                        if (postit.id == postitItem.id) {
                            print(postitItem.id)
                            self.user.remove(at: index)
                        }
                        index += 1
                    }
                    self.user.insert(postit, at: 0)
                } catch {
                    print("ChangeError")
                    print("an error occurred", error)
                }
        }
        
        friendRequestReference
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
                    for postitItem in self.user {
                        if (postit.id == postitItem.id) {
                            print(postitItem.id)
                            self.user.remove(at: index)
                        }
                        index += 1
                    }
                } catch {
                    print("removeError")
                    print("an error occurred", error)
                }
            }
    }
    
    // MARK: - 게임 요청 리스너
    func fetchGameRequest(){
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
                } catch {
                    print("removeError")
                    print("an error occurred", error)
                }
            }
    }
    //내정보를 저장할 어딘가가 필요하다....
    func sendFriendRequest(to: Msg, from: Msg, isFriend: Bool) {
        print(#function)
        let dict: [String: Any] = [
            "id": from.id,// ㅇ
            "nickName": from.nickName, //ㅇ
            "profilImage": from.profilImage, //ㅇ
            "game": from.game, //ㅇ
            "gameHistory": from.gameHistory,
            "friend": from.friend,
        ]
        Database.database()
        .reference()
        .child("Friend")
        .child(to.id).child(Auth.auth().currentUser?.uid ?? "").setValue(dict)
    }
    
    func sendFightRequest(to: [Msg], from: Msg, isFight: Bool) {
        for friend in to {
            let dict: [String: Any] = [
                "id": from.id,// ㅇ
                "nickName": from.nickName, //ㅇ
                "profilImage": from.profilImage, //ㅇ
                "game": from.game, //ㅇ
                "gameHistory": from.gameHistory,
                "friend": from.friend,
            ]

            Database.database()
            .reference()
            .child("Game")
            .child(friend.id).child(Auth.auth().currentUser?.uid ?? "").setValue(dict)
        }
    }
    
    //    func sendFriendRequest
    func acceptAddFriend(friend: Msg) {
        print("add Friend id: \(friend.id)")
        Database.database()
            .reference()
            .child("Friend")
            .child(Auth.auth().currentUser?.uid ?? "")
            .child(friend.id)
            .removeValue()
    }
    
    func acceptGameRequest(friend: Msg) {
        print("add Friend id: \(friend.id)")
        Database.database()
            .reference()
            .child("Game")
            .child(Auth.auth().currentUser?.uid ?? "")
            .child(friend.id)
            .removeValue()
    }
    
    func stopFetching() {
        databaseReference?.removeAllObservers()
    }
}
