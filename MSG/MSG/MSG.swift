//
//  MSG.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import Foundation

struct Msg: Codable, Identifiable {
    // 나
    var id: String
}

struct UserInfo: Codable, Identifiable {
    var id: String
    // 어떤유저한테 초대를 받았는지
    var userName: String
    //유저의 프로필 사진
    var userImage: String
    // 친구초대일 때
    var isFriend: Bool
    // 대결신청일 때
    var isFight: Bool
    // 현재 날짜
//    var InvitedDateAt: Date
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
