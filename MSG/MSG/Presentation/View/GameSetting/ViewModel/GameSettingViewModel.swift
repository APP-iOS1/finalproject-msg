//
//  gameSettingViewModel.swift
//  MSG
//
//  Created by sehooon on 2023/01/17.
//

import SwiftUI
import Combine
import FirebaseFirestore
import Firebase
import FirebaseStorage

// View Button Click 또는 액션
protocol GameSettingViewModelInput{
    func resetInputData() // 백버튼 클릭 및 챌린지 시작 버튼 클릭
    func createSingleChallenge() async // 싱글 챌린지 생성
    func createMultiChallenge() async // 멀티 챌린지 생성
    func selectChallengeDay(_ index: Int) // 날짜 설정 버튼 클릭 ex) [1일, 7일, 10일, 30일, 100일]
    func checkFriend(_ friend: Msg) // 챌린지를 함께할 친구 추가하기
}

// View에 바인딩 되는 요소 및 프로퍼티
protocol GameSettingViewModelOutput{
    var day:Double{ get }
    var title: String{ get }
    var targetMoney:String{ get }
    var startDate:Double{ get }
    var endDate:Double{ get }
    var isGameSettingValid:Bool{ get }
    var daySelection: Int{ get }
    var dayMultiArray:[Double]{ get }
    var dayArray:[String]{ get }
    var invitingFriendList:[Msg] { get }
    var waitingFriendList:[Msg] { get }
}

final class GameSettingViewModel:ObservableObject, GameSettingViewModelInput, GameSettingViewModelOutput{

    func selectChallengeDay(_ index: Int) {
            daySelection = index
            startDate = Date().timeIntervalSince1970
            endDate = startDate + Double(86400) * dayMultiArray[index]
    }
    

    //[property]
    let day:Double = 86400
    private var publishers = Set<AnyCancellable>()
    private let challengeUseCase: ChallengeUseCase?
    private let friendUseCase: FriendUseCase?
    
    @Published var title = ""
    @Published var daySelection: Int = 5
    @Published var isGameSettingValid = false
    @Published var waitingFriendList: [Msg] = []
    @Published var invitingFriendList: [Msg] = []
    @Published var displayFriend: [Msg] = []
    @Published var dayMultiArray:[Double] = [1,7,10,30,100]
    @Published var dayArray = ["1일", "7일", "10일", "30일", "100일"]
    @Published var startDate:Double = Date().timeIntervalSince1970
    @Published var endDate:Double = Date().timeIntervalSince1970
    
    @Published var backBtnAlert: Bool = false   // 네비게이션 백 버튼 클릭 시, alert
    @Published var isShowingAlert: Bool = false // 초대장 보내기 버튼 클릭 시, alert
    @Published var showingDaySelection: Bool = false // 챌린지 기간 설정 시트
    @Published var findFriendToggle: Bool = false // 함께할 친구 추가 시트
    @Published var friendAlert:Bool = false // 추가한 친구가 3명 초과한 경우, alert
    
    @Published var targetMoney = ""{
        didSet{
            if self.targetMoney.count > 7{
                targetMoney = String(targetMoney.prefix(7))
            }
        }
    }
    
    
    //[init]
    init(challegeUsecase: ChallengeUseCase? = nil){
        self.challengeUseCase = DefaultChallengeUseCase(repository: ChallengeRepository(firestoreService: FirebaseService()))
        self.friendUseCase = FriendUseCase(repo: FriendRepositoryImpl(dataSource: FirebaseService()))
        isGameSettingValidPublisher.receive(on: RunLoop.main)
            .assign(to: \.isGameSettingValid, on:self)
            .store(in: &publishers)
    }
    
    //[method]
    func isCheked(_ friend: Msg) -> Bool { return invitingFriendList.contains(friend) }
    
    // 
    func checkFriend(_ friend: Msg){
        if invitingFriendList.contains(friend){
            invitingFriendList.remove(at: invitingFriendList.firstIndex(of: friend)!)
        }else{
            if invitingFriendList.count > 3{
                friendAlert = true
            }else{
                invitingFriendList.append(friend)
            }
        }
    }
    
    // 친구목록 가져오기
    func fetchMyFriendList() async {
        do{
            guard let friendInfo =  await friendUseCase?.fetchFriendList() else {
                print("NONOFriend")
                return }
            //MARK: - 여기서 데이터를 못받아옴
            guard let myFriend = try await friendUseCase?.caseNotGameMyFriend(text: friendInfo.0) else {
                print("NO Friend")
                return
            }
            print(myFriend)
            DispatchQueue.main.async {
                print("왜 못받아:",self.displayFriend)
                self.displayFriend = friendInfo.0.filter {$0.game.isEmpty} //MARK: - 그래서 이렇게 수정했는데 확인좀
            }
        }catch{
            print("Error FETCH MTFRIENDLIST")
        }
    }
    
    // 싱글 챌린지 생성
    func createSingleChallenge() async {
        let challenge = Challenge(id: UUID().uuidString, gameTitle: title, limitMoney: Int(targetMoney)!,
                                  startDate: String(startDate), endDate: String(endDate), inviteFriend: [], waitingFriend: [])
        await challengeUseCase?.excuteMakeSingleChallenge(challenge)
        resetInputData()
    }
    
    // 멀티 챌린지 생성
    func createMultiChallenge() async {
        let challenge = Challenge(id: UUID().uuidString, gameTitle: title, limitMoney: Int(targetMoney)!,
                                  startDate: String(startDate), endDate: String(endDate), inviteFriend: [], waitingFriend: [])
        await challengeUseCase?.excuteMakeMultiChallenge(challenge)
        resetInputData()
    }
    
}

extension GameSettingViewModel{
    func resetInputData (){
        DispatchQueue.main.async {
            self.title = ""
            self.targetMoney = ""
            self.startDate = Date().timeIntervalSince1970
            self.endDate  = self.startDate + 86400
            self.isGameSettingValid = false
            self.daySelection = 5
        }
        
    }
    
    var isTitleValidPublisher: AnyPublisher<Bool,Never>{
        $title
            .map{ name in
                return name.trimSpacingCount >= 1
            }
            .eraseToAnyPublisher()
    }
    
    var isTargetMoneyValidPublisher: AnyPublisher<Bool,Never>{
        $targetMoney
            .map{ money in
                return money.trimSpacingCount >= 1 && Int(money) != nil
            }
            .eraseToAnyPublisher()
        
    }
    
    var isDaySelectionValidPublisher: AnyPublisher<Bool,Never>{
        $daySelection
            .map{ day in
                return day != 5
            }
            .eraseToAnyPublisher()
        
    }
    
    var isGameSettingValidPublisher: AnyPublisher<Bool,Never>{
        Publishers.CombineLatest3(isTitleValidPublisher, isTargetMoneyValidPublisher, isDaySelectionValidPublisher).map{ title, targetMoney, day in
            return title && targetMoney && day
        }
        .eraseToAnyPublisher()
    }
}
