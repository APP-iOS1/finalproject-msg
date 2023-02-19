//
//  AddExpenditureUseCase.swift
//  MSG
//
//  Created by 김민호 on 2023/02/20.
//

import Foundation

protocol AddExpenditure {
    func addExpenditure(user: Msg, tagName: String, convert: String, addMoney: Int) async
}

struct AddExpenditureUseCase: AddExpenditure {
    let repo: AddExpenditureRepository
    
    func addExpenditure(user: Msg, tagName: String, convert: String, addMoney: Int) async {
        print("== UseCase ==")
        await repo.addExpenditure(user: user, tagName: tagName, convert: convert, addMoney: addMoney)
    }
    
}


