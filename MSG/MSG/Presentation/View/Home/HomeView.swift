//
//  HomeView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/17.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @ObservedObject var challengeViewModel: ChallengeViewModel
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            if let game = challengeViewModel.currentGame {
                if game.waitingFriend.isEmpty {
                    AfterChallengeView(challengeViewModel: AppDI.shared.challengeViewModel)
                } else {
                    WaitingView(game: challengeViewModel.currentGame!)
                        .refreshable {
                            await challengeViewModel.findUser(inviteId: challengeViewModel.currentGame!.inviteFriend,waitingId: challengeViewModel.currentGame!.waitingFriend)
                            await challengeViewModel.fetchGame()
                        }
                }
                
            } else {
                BeforeChallengeView()
            }
        }
        .onAppear {
            Task {
                guard let user = try! await challengeViewModel.challengefetchUserInfo(Auth.auth().currentUser?.uid ?? "")  else {return}
                if !(user.game.isEmpty) {
                    await challengeViewModel.fetchGameReturn()
                }
                
                print(user.game)
                print("홈뷰 온어피어 : \(challengeViewModel.currentGame)")
            }
      
        }
        .onReceive(timer) { _ in
            guard let game = challengeViewModel.currentGame  else { return }
//            print("끝나는시간:",game.endDate)
//            let now = Date().timeIntervalSinceNow
//            print("현재시간:", now)
            if Date().timeIntervalSince1970 > Double(game.endDate)! {
                self.timer.upstream.connect().cancel()
                print("멈췄습니다!")
                Task {
                    await challengeViewModel.addGameHistory()
                    challengeViewModel.currentGame = nil
                }
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
