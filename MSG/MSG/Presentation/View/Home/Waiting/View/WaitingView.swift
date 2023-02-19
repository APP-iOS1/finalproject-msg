//
//  WaitingView.swift
//  MSG
//
//  Created by kimminho on 2023/01/30.
//

import SwiftUI

struct WaitingView: View {
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
//    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
//    @EnvironmentObject private var realtimeViewModel: RealtimeViewModel
    @StateObject var waitingViewModel = WaitingViewModel()
    @ObservedObject var challengeViewModel: ChallengeViewModel
    // Button Animation
    @State var buttonCount: Int = 0
    @State var timeRunning: Bool = false
    @State var buttonRunning: Bool = true
    @State var animationRunning: Bool = true
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Color("Color1")
                    .ignoresSafeArea()
                if waitingViewModel.currentGame == nil {
                    ProgressView()
                } else {
                    VStack(alignment: .center) {
                        

                        
                        VStack {
                            
                            VStack {
                                // MARK: 게임 대기 & [ 준비 완료 인원 / 전체 인원 ]
                                HStack {
                                    Text("게임 대기")
                                        .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                                    Spacer()
                                    Text("[ \(waitingViewModel.currentGame!.inviteFriend.count) / \(waitingViewModel.currentGame!.inviteFriend.count + waitingViewModel.currentGame!.waitingFriend.count) ]")
                                }
                                .frame(width: g.size.width / 1.3, height: g.size.height / 12)
                                
                                // MARK: 대기 진행 상황 ProgressView
                                    ZStack {
                                        ProgressView(value: Double(waitingViewModel.currentGame!.inviteFriend.count), total: Double(waitingViewModel.currentGame!.inviteFriend.count + waitingViewModel.currentGame!.waitingFriend.count))
                                            .progressViewStyle(RoundedRectProgressViewStyle())
                                            .frame(width: g.size.width / 1.3, height: g.size.height / 14)
                                        Text("\(String(format: "%.0f%%", (Double(waitingViewModel.currentGame!.inviteFriend.count) * 100) / Double(waitingViewModel.currentGame!.inviteFriend.count + waitingViewModel.currentGame!.waitingFriend.count)))")
                                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color1))
                                    }
                                }
                                .frame(width: g.size.width / 1.3, height: g.size.height / 12)
                            }
                            .frame(width: g.size.width / 1.3, height: g.size.height / 6)


                        
                            Divider()
                            .frame(width: g.size.width / 1.3, height: g.size.height / 15)
                        WaitingCountView(waitingViewModel: waitingViewModel, endDate: Double(waitingViewModel.currentGame!.startDate)! + 300.0)
                        
                            // MARK: 참여 인원 & refreshable 버튼
                            HStack {
                                Text("참여 인원")
                                    .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                                Spacer()
                                
                                // MARK: Custom Refresh Button
                                VStack {
                                    // 버튼이 실행중인 경우
                                    if buttonRunning {
                                        Button {
                                            buttonRunning = false
                                            if buttonCount < 1 {
                                                buttonCount = 0
                                                timeRunning = true
                                                animationRunning = true
                                            }
                                            Task {
                                                await challengeViewModel.fetchGameReturn()
//                                                await waitingViewModel.fetchGame()
                                                await challengeViewModel.findUser(inviteId: challengeViewModel.currentGame!.inviteFriend,waitingId: challengeViewModel.currentGame!.waitingFriend)
//                                                await waitingViewModel.findUser()
                                            }
                                        } label: {
                                            Image(systemName: "arrow.clockwise.circle.fill")
                                                .resizable()
                                                .frame(width: g.size.width / 15.6, height: g.size.height / 27.468)
                                        }
                                    // 버튼이 실행중이지 않은 경우
                                    } else {
                                        Image(systemName: "arrow.clockwise.circle.fill")
                                            .resizable()
                                            .frame(width: g.size.width / 15.6, height: g.size.height / 27.468)
                                            .rotationEffect(.degrees(animationRunning ? 0 : 360))
                                            .opacity(0.6)
                                            .onAppear {
                                                withAnimation(Animation.linear(duration: 5)
                                                    .repeatForever(autoreverses: false)) {
                                                        animationRunning = false
                                                    }
                                            }
                                    }
                                }
                                .onReceive(timer, perform: { _ in
                                    if timeRunning  {
                                        if buttonCount == 5 {
                                            buttonCount = 0
                                            buttonRunning = true
                                            timeRunning = false
                                        } else {
                                            buttonCount += 1
                                        }
                                    } else {
                                        buttonCount = 0
                                    }
                                    
                                })
                            }
                            .frame(width: g.size.width / 1.3, height: g.size.height / 12)
                            
                       
                            VStack {
                                ScrollView {
                                    // MARK: 초대장 수락 인원(inviteFriend)
                                    ForEach(waitingViewModel.invitedFriend, id: \.self) { user in
                                        HStack {
                                            VStack {
                                                if user.profileImage.isEmpty{
                                                    Image(systemName: "person")
                                                        .font(.largeTitle)
                                                }else{
                                                    AsyncImage(url: URL(string: user.profileImage)) { Image in
                                                        Image
                                                            .resizable()
                                                    } placeholder: {
                                                        Image(systemName: "person")
                                                            .font(.largeTitle)
                                                    }
                                                }
                                            }
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: g.size.width / 9.375, height: g.size.height / 14.5575)
                                            .clipShape(Circle())
                                            .padding(4)
                                            .foregroundColor(Color("Color2"))
                                            .background(
                                                Circle()
                                                    .fill(
                                                        .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                                        .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                                    )
                                                    .foregroundColor(Color("Color1")))
                                            
                                            Spacer()
                                            
                                            Text(user.nickName)
                                                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.title3, color: FontCustomColor.color2))
                                            
                                            Spacer()
                                        
                                            Text("Ready")
                                         
                                            
                                        }
                                        .frame(width: g.size.width / 1.3, height: g.size.height / 10)
                                    } // ForEach(fireStoreViewModel.invitedArray, id: \.self)
                                    
                                    // MARK: 초대장 미수락 인원(waitingFriend)
                                    ForEach(waitingViewModel.waitingFriend, id: \.self) { user in
                                        HStack {
                                            VStack {
                                                if user.profileImage.isEmpty{
                                                    Image(systemName: "person")
                                                        .font(.largeTitle)
                                                }else{
                                                    AsyncImage(url: URL(string: user.profileImage)) { Image in
                                                        Image
                                                            .resizable()
                                                    } placeholder: {
                                                        Image(systemName: "person")
                                                            .font(.largeTitle)
                                                    }
                                                }
                                            }
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: g.size.width / 9.375, height: g.size.height / 14.5575)
                                            .clipShape(Circle())
                                            .padding(4)
                                            .foregroundColor(Color("Color2"))
                                            .background(
                                                Circle()
                                                    .fill(
                                                        .shadow(.inner(color: Color("Shadow2"),radius: 5, x:3, y: 3))
                                                        .shadow(.inner(color: Color("Shadow3"), radius:5, x: -3, y: -3))
                                                    )
                                                    .foregroundColor(Color("Color1")))
                                            
                                            Spacer()
                                            
                                            Text(user.nickName)
                                                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.title3, color: FontCustomColor.color2))
                                            
                                            Spacer()
                                            
                                            Text("Ready")
                                                .foregroundColor(.clear)
                                        }
                                        .frame(width: g.size.width / 1.3, height: g.size.height / 8)
                                    } // ForEach(fireStoreViewModel.waitingArray, id: \.self)
                                } // ScollView
                                
                            }
                            .frame(width: g.size.width / 1.2, height: g.size.height / 2.1)
                         

                    }
                    .frame(width: g.size.width / 1.1, height: g.size.height / 1.1)
                }
                
            }
            .onAppear {
                Task {
                    await waitingViewModel.fetchGame()
                    print("패치완료")
                    await waitingViewModel.findUser()
                }
            }
//            .onReceive(timer) { _ in
//                guard let game = fireStoreViewModel.currentGame  else { return }
//    //            print("끝나는시간:",game.endDate)
//    //            let now = Date().timeIntervalSinceNow
//    //            print("현재시간:", now)
//                if Date().timeIntervalSince1970 > Double(game.startDate)! + 300 {
//                    self.timer.upstream.connect().cancel()
//                    print("멈췄습니다!")
//                    Task {
//                        await fireStoreViewModel.addGameHistory()
//                        fireStoreViewModel.currentGame = nil
//                    }
//                }
//            }
            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.body, color: FontCustomColor.color2))
        }
        
    }
}

struct RoundedRectProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { g in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: g.size.width, height: g.size.height)
                    .foregroundColor(Color("Color3"))
                
                
                
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * g.size.width, height: g.size.height)
                    .foregroundColor(Color("Color2"))
            }
            
        }
    }
}



//struct WaitingView_Previews: PreviewProvider {
//    static var previews: some View {
//        WaitingView(game: Challenge(id: "", gameTitle: "", limitMoney: 0, startDate: "", endDate: "", inviteFriend: ["애플케로로","구글김민호"], waitingFriend: ["카카오케로로","카카오김민호"]))
//            .environmentObject(FireStoreViewModel())
//
//    }
//}
