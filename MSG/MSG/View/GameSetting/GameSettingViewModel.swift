//
//  gameSettingViewModel.swift
//  MSG
//
//  Created by sehooon on 2023/01/17.
//

import Foundation
import Combine

final class GameSettingViewModel:ObservableObject{
    let day:Double = 86400
    @Published var title = ""
    @Published var targetMoney = ""
    @Published var startDate:Double = Date().timeIntervalSince1970
    @Published var endDate:Double = Date().timeIntervalSince1970
    @Published var isGameSettingValid = false
    @Published var daySelection: Int = 0
    
    @Published var dayMultiArray:[Double] = [1,7,10,30,100]
    @Published var dayArray = ["1일", "7일", "10일", "30일", "100일"]
    private var publishers = Set<AnyCancellable>()
    
    
 
    
    init(){
        isGameSettingValidPublisher.receive(on: RunLoop.main)
            .assign(to: \.isGameSettingValid, on:self)
            .store(in: &publishers)
    }
}

extension GameSettingViewModel{
    
 
    
    func dateCalculate(){
        let oneDay = Date().timeIntervalSince1970 + 86400
        
    }
    
    
    func resetInputData (){
        DispatchQueue.main.async {
            self.title = ""
            self.targetMoney = ""
            self.startDate = Date().timeIntervalSince1970
            self.endDate  = self.startDate + 86400
            self.isGameSettingValid = false
        }
        
    }
    
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
