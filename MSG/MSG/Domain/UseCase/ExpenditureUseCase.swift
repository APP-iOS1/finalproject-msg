//
//  AddExpenditureUseCase.swift
//  MSG
//
//  Created by 김민호 on 2023/02/20.
//

import Foundation

protocol AllExpenditure {
    func addExpenditure(user: Msg, tagName: String, convert: String, addMoney: Int) async
    func fetchExpenditure(uid: String) async -> Expenditure?
}

struct ExpenditureUseCase: AllExpenditure {
    let repo: ExpenditureRepository
    
    func addExpenditure(user: Msg, tagName: String, convert: String, addMoney: Int) async {
        print("== UseCase ==")
        await repo.addExpenditure(user: user, tagName: tagName, convert: convert, addMoney: addMoney)
    }
    func fetchExpenditure(uid: String) async -> Expenditure? {
        let data = await repo.fetchExpenditure(uid: uid)
        return data
    }
    
}


