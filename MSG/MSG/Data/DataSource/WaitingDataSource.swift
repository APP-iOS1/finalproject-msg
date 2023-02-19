//
//  WaitingDataSource.swift
//  MSG
//
//  Created by 김민호 on 2023/02/19.
//

import Foundation

protocol WaitingDataSource {
    func addMultiGameDeleteWaitUserFiveMinute(_ challenge: Challenge) async -> Challenge?
}
