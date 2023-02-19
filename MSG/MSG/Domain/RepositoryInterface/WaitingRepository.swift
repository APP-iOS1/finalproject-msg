//
//  WaitingRepository.swift
//  MSG
//
//  Created by 김민호 on 2023/02/19.
//

import Foundation

protocol WaitingRepository {
    func addMultiGameDeleteWaitUserFiveMinute(_ challenge: Challenge) async -> Challenge?
}
