import Foundation
import FirebaseDatabase
import FirebaseAuth

class PostitStore: ObservableObject {
    @Published var msg: [Msg] = []
    @Published var user: [UserInfo] = []

    private lazy var databaseReference: DatabaseReference? = {
            let ref = Database.database()
            .reference()
            .child(Auth.auth().currentUser?.uid ?? "")
        
            return ref
        }()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    
    func read() {
        user.removeAll()
        Database.database()
        .reference()
        .child("msg")
        .child(Auth.auth().currentUser?.uid ?? "")
        .observeSingleEvent(of: .value, with: { snapshot in
                guard let dict = snapshot.value as? [String:[String:Any]] else {
                    print("Error")
                    return
                }
            print(dict)
                Array(dict.values).forEach {
                   let id = $0["id"] as? String ?? ""
                   let userImage = $0["userImage"] as? String ?? ""
                   let isFight = $0["isFight"] as? Bool ?? false
                   let isFriend = $0["isFriend"] as? Bool ?? false
                   let userName = $0["userName"] as? String ?? ""
                   let userInfo = UserInfo(id: id, userName: userName, userImage: userImage, isFriend: isFriend, isFight: isFight)
                
                    self.user.append(userInfo)
                }
            print(self.user)
        })
    }
    
    
    
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
    
    //내정보를 저장할 어딘가가 필요하다....
    func sendFriendRequest(to: Msg, from: Msg, isFriend: Bool) {
            Database.database()
            .reference()
                .child(to.id).child(Auth.auth().currentUser?.uid ?? "").setValue([
                "id": from.id,
                "userName": from.nickName,
                "userImage": from.profilImage,
                "isFriend": isFriend,
                "isFight": false,
            ])
        }
    
    func sendFightRequest(to: Msg, from: Msg, isFight: Bool) {
        databaseReference?
            .child(to.id).child(Auth.auth().currentUser?.uid ?? "").setValue([
            "id": from.id,
            "userName": from.nickName,
            "userImage": from.profilImage,
            "isFriend": false,
            "isFight": isFight,
        ])
    }
    
//    func sendFriendRequest

    func deletePostit(postit: Msg) {
        print("delete id: \(postit.id)")
        databaseReference?.child(postit.id).removeValue()
    }
    
    func stopFetching() {
        databaseReference?.removeAllObservers()
    }
}
