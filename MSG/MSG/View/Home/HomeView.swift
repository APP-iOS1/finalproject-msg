//
//  HomeView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/17.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        
        ZStack {
            if let game = fireStoreViewModel.currentGame {
                if game.waitingFriend.isEmpty {
                    AfterChallengeView(challenge: game)
                } else {
                    WaitingView(game: game)
                }
            } else {
                BeforeChallengeView()
            }
        }
        .refreshable {
            await fireStoreViewModel.fetchGame()
        }
        .onAppear {
            Task {
                guard let user = try! await fireStoreViewModel.fetchUserInfo(Auth.auth().currentUser?.uid ?? "") else {return}
                if !(user.game.isEmpty) {
                    await fireStoreViewModel.fetchGame()
                }
            }
        }
        .onReceive(timer) { _ in
            guard let game = fireStoreViewModel.currentGame  else { return }
//            print("끝나는시간:",game.endDate)
            let now = Date().timeIntervalSinceNow
//            print("현재시간:", now)
//            if Date().timeIntervalSince1970 > Double(game.endDate)!{
            if Date().timeIntervalSince1970 > Double(game.endDate)! {
                self.timer.upstream.connect().cancel()
                print("멈췄습니다!")
                Task {
                    await fireStoreViewModel.addGameHistory()
                    fireStoreViewModel.currentGame = nil
                }
            }
        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Text("MSG")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .foregroundColor(Color("Font"))
//            }
//            ToolbarItem(placement: .navigationBarTrailing) {
//                NavigationLink(destination: SettingView(darkModeEnabled: $darkModeEnabled)) {
//                    Image(systemName: "person.circle")
//                        .font(.title2)
//                        .foregroundColor(Color("Font"))
//                }
//
//            }
//        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
