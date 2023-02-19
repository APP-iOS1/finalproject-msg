//
//  WatingCountingView.swift
//  MSG
//
//  Created by kimminho on 2023/02/08.
//

import SwiftUI

import SwiftUI

struct WaitingCountView: View {
    
//    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
//    @EnvironmentObject private var realtimeViewModel: RealtimeViewModel
    @ObservedObject var waitingViewModel: WaitingViewModel
    @State var timeRemaining = 3024000
    var endDate: Double = 0.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func timeString(time: Int) -> String {
        let days = Int(time) / 86400
        let hours = Int(time) / 3600 % 24
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:" 게임시작까지 %02i분 %02i초 남음",minutes, seconds)
    }
    
    var body: some View {
        
        VStack(alignment: .center) {
            Text("\(timeString(time: timeRemaining))")
//                .modifier(TextTitleBold())
        }
        .onReceive(timer){ _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }else{
                Task {
                    self.timer.upstream.connect().cancel()
                    await waitingViewModel.fetchGame()
                    guard let waitingArray = waitingViewModel.currentGame else { return }
                    for user in waitingArray.waitingFriend {
                        await waitingViewModel.afterFiveMinuteDeleteChallenge(friend: user)
                    }
                    let data = await waitingViewModel.addMultiGameDeleteWaitUserFiveMinute(waitingViewModel.currentGame!)
                    waitingViewModel.currentGame = data
//                    afterFiveMinuteDeleteChallenge
                }
            }
        }
        .onAppear {
            timeRemaining = Int(endDate - Date().timeIntervalSince1970)
        }
    }
}

//struct WaitingCountView_Previews: PreviewProvider {
//    static var previews: some View {
//        WaitingCountView()
//    }
//}
