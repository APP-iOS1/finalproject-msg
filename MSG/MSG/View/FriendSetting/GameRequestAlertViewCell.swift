//
//  GameRequestAlertViewCell.swift
//  MSG
//
//  Created by kimminho on 2023/02/02.
//

import SwiftUI

struct GameRequestAlertViewCell: View {
    @State var sendUser: Msg
    @State private var isPresent = false
    @State private var challengeInfo: Challenge?
    @EnvironmentObject private var firestoreViewModel: FireStoreViewModel
    @EnvironmentObject private var realtimeViewModel: RealtimeViewModel
    
    var body: some View {
        GeometryReader { g in
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
                .frame(width: g.size.width / 7)
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
                    VStack(spacing: 10){
                        if let challengeInfo {
                            if challengeInfo.gameTitle.isEmpty {
                                ProgressView()
                            }
                        }
                        Text("\(self.sendUser.nickName)님의 도전장👊" )
                            .padding()
                            .modifier(TextTitleBold())
                        Divider()
                        Spacer()
                        Text("\(challengeInfo?.gameTitle ?? "제목없음")")
                            .modifier(TextViewModifier(color: "Font"))
                        VStack(spacing: 10){
                            Text("목표금액💶")
                                .modifier(TextViewModifier(color: "Font"))
                            Text("\(challengeInfo?.limitMoney ?? 0)")
                                .modifier(TextViewModifier(color: "Font"))
                        }.padding()
                        VStack(spacing: 10){
                            Text("챌린지 기간🗓")
                                .modifier(TextViewModifier(color: "Font"))
                            Text("\(challengeInfo?.startDate.createdDate ?? "제목없음")")
                                .modifier(TextTitleBold())
                            Text("\(challengeInfo?.endDate.createdDate ?? "제목없음")")
                                .modifier(TextViewModifier(color: "Font"))
                        }.padding()
                        
                        
                        Spacer()
                    }
                    .frame(width: 300, height: 400)
                } primaryButton: {
                    CustomAlertButton(title: Text("거절")) {
                        isPresent = false
                        print("도전")
                    }
                } secondButton: {
                    CustomAlertButton(title: Text("수락")) {
                        
                        //수락을 눌렀을 때
                        //1.수락한사람의 id를 찾아내기
                        //2.Auth.auth()…asdas를 통해서 해당 배열에 있다면 invitedFriend로 append해주고
                        //3.waitingFriend에는 그 아이디가 없어져야 함…
                        Task {
                            challengeInfo = await firestoreViewModel.fetchChallengeInformation(self.sendUser.game)
                            await firestoreViewModel.acceptGame(self.sendUser.game)
                            await realtimeViewModel.acceptGameRequest(friend: self.sendUser)
                            await firestoreViewModel.waitingLogic(data: challengeInfo)
                        }
                        isPresent = false
                        print("도망")
                        
                    }
                }
            }
            .onAppear{
                Task{
                    challengeInfo = await firestoreViewModel.fetchChallengeInformation(self.sendUser.game)
                }
            }
        }
        .modifier(TextViewModifier(color: "Font"))
        
    }
}


//struct GameRequestAlertViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        GameRequestAlertViewCell()
//    }
//}
