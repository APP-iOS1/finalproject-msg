//
//  SpendingWriteViewModel.swift
//  MSG
//
//  Created by kimminho on 2023/01/27.
//

import Foundation
import Combine

class SpendingWriteViewModel: ObservableObject {
    @Published var consumeTitle = ""
    @Published var consumeMoney = ""
    
    init() {
    }
    var isTitleValidPublisher: AnyPublisher<Bool,Never>{
        $consumeTitle
            .map{ name in
                return name.count >= 2
            }
            .eraseToAnyPublisher()
    }
    
    var isTargetMoneyValidPublisher: AnyPublisher<Bool,Never>{
        $consumeMoney
            .map{ money in
                return Int(money) != nil
            }
            .eraseToAnyPublisher()
    }
    
    var isGameSettingValidPublisher: AnyPublisher<Bool,Never>{
        Publishers.CombineLatest(isTitleValidPublisher, isTargetMoneyValidPublisher).map{ title, targetMoney in
            return title && targetMoney
        }
        .eraseToAnyPublisher()
    }
}
