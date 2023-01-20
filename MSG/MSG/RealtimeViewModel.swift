import Foundation
import FirebaseDatabase
import FirebaseAuth

class PostitStore: ObservableObject {
    @Published var msg: [Msg] = []
    @Published var user: [UserInfo] = []
    @Published var myInfo: Msg?

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
                    let postit = try self.decoder.decode(UserInfo.self, from: postitData)
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
                    print("removeError")
                    print("an error occurred", error)
                }
            }
    }
    
    //내정보를 저장할 어딘가가 필요하다....
    func sendFriendRequest(to: UserInfo, from: Msg, isFriend: Bool) {
        print(#function)
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
        Database.database()
        .reference()
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
