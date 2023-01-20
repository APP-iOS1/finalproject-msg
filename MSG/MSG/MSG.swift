//
//  MSG.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import Foundation

//MARK: - 나의 정보들
struct Msg: Codable, Identifiable, Hashable {
    // 나
    var id: String
    var nickName: String
    var profilImage: String
    //현재 진행중인 게임 id
    var game: String
    var gameHistory: [String]
    var friend: [String]
}

//MARK: - 친구의 정보들
struct Friend: Codable, Identifiable {
    var id: String
    var nickName: String
    var profilImage: String
    var game: String
}
//MARK: - 게임을 생성할 때 필요함
struct Challenge: Codable, Identifiable, Hashable {
    // Game의 ID
    var id: String
    var gameTitle: String
    var limitMoney: Int
    var startDate: String
    var endDate: String
    var inviteFriend: [String]
}

//MARK: - 게임에 들어와 유저들의 아이디와 지출내역을 확인
struct expenditure: Codable, Identifiable {
    //참석유저 아이디
    var id: String
    var expenditureHistory: [String:[String]]
}


//MARK: - RealtimeDB
//struct UserInfo: Codable, Identifiable, Hashable {
//    var id: String
//    // 어떤유저한테 초대를 받았는지
//    var userName: String
//    //유저의 프로필 사진
//    var userImage: String
//    // 친구초대일 때
//    var isFriend: Bool
//    // 대결신청일 때
//    var isFight: Bool
//    // 현재 날짜
////    var InvitedDateAt: Date
//}

extension Encodable {
    var toDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data,options: .allowFragments) as? [String: Any]
    }
}

/*
 MSG
    - 김민호
        - [[김철수,사진,친구초대True,대결False,2022-12-10,
            김철수,사진,친구초대True,대결False,2022-12-10]]
    - 전준수
        - [[김철수,사진,친구초대True,대결False,2022-12-10,
            김철수,사진,친구초대True,대결False,2022-12-10]]
 */
