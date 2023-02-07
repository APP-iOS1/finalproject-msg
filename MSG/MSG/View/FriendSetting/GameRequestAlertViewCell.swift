//
//  GameRequestAlertViewCell.swift
//  MSG
//
//  Created by kimminho on 2023/02/02.
//

import SwiftUI

struct GameRequestAlertViewCell: View {
    @Binding var selectedTabBar: SelectedTab
    @State var sendUser: Msg
    @State private var isPresent = false
    @State private var challengeInfo: Challenge?
    @State var g: GeometryProxy
    @EnvironmentObject private var firestoreViewModel: FireStoreViewModel
    @EnvironmentObject private var realtimeViewModel: RealtimeViewModel
    
    var body: some View {
        //        GeometryReader { g in
        HStack{
            VStack {
                if sendUser.profileImage.isEmpty{
                    Image(systemName: "person")
                        .font(.largeTitle)
                }else{
                    AsyncImage(url: URL(string: sendUser.profileImage)) { Image in
                        Image
                            .resizable()
                    } placeholder: {
                        Image(systemName: "person")
                            .font(.largeTitle)
                    }
                }
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: g.size.width / 7, height: g.size.height / 12)
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
            
            Text("\(sendUser.nickName)")
                .padding(.leading)
            
            Spacer()
            
            Button {
                Task{
                    await MainActor.run {
                        self.sendUser = sendUser
                    }
                    challengeInfo = await firestoreViewModel.fetchChallengeInformation(self.sendUser.game)
                    isPresent = true
                }
            } label: {
                Text("확인")
            }
            .buttonStyle(.borderless)
            .frame(width: g.size.width / 9, height: g.size.height / 20)
            .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
            .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
            .padding(5)
            .background(Color("Color1"))
            .cornerRadius(10)
            .shadow(color: Color("Shadow3"), radius: 6, x: -7, y: -7)
            .shadow(color: Color("Shadow"), radius: 6, x: 7, y: 7)
            .padding(.trailing)
        }
        .padding()
        .alert(isPresented: $isPresent) {
            CustomAlertView {
                ZStack {
                    Color("Color1").ignoresSafeArea()
                    VStack(spacing: 10){
                        if let challengeInfo {
                            if challengeInfo.gameTitle.isEmpty {
                                ProgressView()
                            }
                        }
                        Text("\(self.sendUser.nickName)님의 도전장👊" )
                            .padding()
                            .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.largeTitle, color: FontCustomColor.color2))
                        Divider()
                        Spacer()
                        Text("\(challengeInfo?.gameTitle ?? "제목없음")")
                            .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.title2, color: FontCustomColor.color2))
                        VStack(spacing: 10){
                            Text("목표금액💶")
                            Text("\(challengeInfo?.limitMoney ?? 0)")
                        }.padding()
                        VStack(spacing: 10){
                            Text("챌린지 기간🗓")
                            Text("\(challengeInfo?.startDate.createdDate ?? "제목없음")")
                            Text("\(challengeInfo?.endDate.createdDate ?? "제목없음")")
                        }.padding()
                        VStack {
                            Text("경고")
                                .modifier(TextModifier(fontWeight: FontCustomWeight.bold, fontType: FontCustomType.title3, color: FontCustomColor.color2))
                            Text("수락하시면 모든 도전장이 사라집니다.")
                                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.caption, color: FontCustomColor.color2))
                        }
                        Spacer()
                    }
                }
                .modifier(TextModifier(fontWeight: FontCustomWeight.normal, fontType: FontCustomType.body, color: FontCustomColor.color2))
                .frame(width: 300, height: 400)
            } primaryButton: {
                    CustomAlertButton(title: Text("거절"), color: Color("Color1")) {
                        isPresent = false
                        Task {
                            await firestoreViewModel.notAllowChallegeStep1(data: realtimeViewModel.requsetGameArr)
                            //리얼타임에 삭제하는 함수임
                            await realtimeViewModel.acceptGameRequest(friend: self.sendUser)
                        }
                        print("도전")
                    }
            } secondButton: {
                CustomAlertButton(title: Text("수락"), color: Color("Color1")) {
                    
                    //수락을 눌렀을 때
                    //1.수락한사람의 id를 찾아내기
                    //2.Auth.auth()…asdas를 통해서 해당 배열에 있다면 invitedFriend로 append해주고
                    //3.waitingFriend에는 그 아이디가 없어져야 함…
                    Task {
                        challengeInfo = await firestoreViewModel.fetchChallengeInformation(self.sendUser.game)
                        await firestoreViewModel.acceptGame(self.sendUser.game)

                        //1. 내가포함된 모든게임에서 나를 waiting배열에서 지운다
                        await firestoreViewModel.notAllowChallegeStep1(data: realtimeViewModel.requsetGameArr)
                        //리얼타임에 삭제하는 함수임
                        await realtimeViewModel.acceptGameRequest(friend: self.sendUser)
                        // 나를 해당 챌린지에 invite append하는 함수
                        await firestoreViewModel.waitingLogic(data: challengeInfo)
                        
                        selectedTabBar = .first
                    }
                    isPresent = false
                    print("도망")
                    
                }
            }
        }
        .onAppear{
            Task{
                challengeInfo = await firestoreViewModel.fetchChallengeInformation(self.sendUser.game)
                realtimeViewModel.fetchFriendRequest()
                if let challengeInfo {
                    // 도전장을 보낸지 5분이 지났다면
                    if Double(challengeInfo.startDate)! + 300.0 < Double(Date().timeIntervalSince1970) {
                        //챌린지 삭제
                        await realtimeViewModel.afterFiveMinuteDeleteChallenge(friend: self.sendUser)
                        //내 waiting 배열에서도 삭제
                        firestoreViewModel.notAllowChallegeStep2(data: challengeInfo)
                        
                    }
                }
            }
        }
    }
}


//struct GameRequestAlertViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        GameRequestAlertViewCell()
//    }
//}
