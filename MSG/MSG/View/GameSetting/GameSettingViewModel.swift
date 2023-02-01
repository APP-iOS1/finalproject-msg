//
//  gameSettingViewModel.swift
//  MSG
//
//  Created by sehooon on 2023/01/17.
//

import Foundation
import Combine

class GameSettingViewModel:ObservableObject{
    @Published var title = ""
    @Published var targetMoney = ""
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var isGameSettingValid = false
    
    private var publishers = Set<AnyCancellable>()
    
    
    func resetInputData (){
        DispatchQueue.main.async {
            self.title = ""
            self.targetMoney = ""
            self.startDate = Date()
            self.endDate  = Date()
            self.isGameSettingValid = false
        }
        
    }
    
    init(){
        isGameSettingValidPublisher.receive(on: RunLoop.main)
            .assign(to: \.isGameSettingValid, on:self)
            .store(in: &publishers)
    }
}

extension GameSettingViewModel{
    var isTitleValidPublisher: AnyPublisher<Bool,Never>{
        $title
            .map{ name in
                return name.count >= 1
            }
            .eraseToAnyPublisher()
    }
    
    var isTargetMoneyValidPublisher: AnyPublisher<Bool,Never>{
        $targetMoney
            .map{ money in
                return money.count >= 1 && Int(money) != nil
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
