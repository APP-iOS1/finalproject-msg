//
//  GameRequestAlertView.swift
//  MSG
//
//  Created by sehooon on 2023/01/25.
//

import SwiftUI

struct GameRequestAlertView: View {
    @State private var isPresent = false
    @State private var challengeInfo: Challenge?
    @EnvironmentObject private var firestoreViewModel: FireStoreViewModel
    @EnvironmentObject private var realtimeViewModel: RealtimeViewModel
    var body: some View {
        ZStack{
            ScrollView{
                Color("Background").ignoresSafeArea()
                if realtimeViewModel.requsetGameArr.isEmpty{
                    Text("비어있습니다.")
                        .modifier(TextViewModifier(color: "Font"))
                }
                ForEach(realtimeViewModel.requsetGameArr){ sendUser in
                    HStack{
                        if sendUser.profileImage.isEmpty{
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(height: 60)
                        }else{
                            AsyncImage(url: URL(string: sendUser.profileImage)) { Image in
                                Image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(height: 60)
                            } placeholder: {
                                
                            }
                        }
                        Text("\(sendUser.nickName)")
                        Spacer()
                        Button {
                            isPresent = true
                        } label: {
                            Text("확인하기✉️💌")
                                .padding(.trailing)
                        }
                        .alert(isPresented: $isPresent) {
                            CustomAlertView {
                                VStack(spacing: 10){
                                    Text("\(sendUser.nickName)님의 도전장👊")
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
                                        challengeInfo = await firestoreViewModel.fetchChallengeInformation(sendUser.game)
                                        await firestoreViewModel.acceptGame(sendUser.game)
                                        realtimeViewModel.acceptGameRequest(friend: sendUser)
                                        await firestoreViewModel.waitingLogic(data: challengeInfo)
                                    }
                                    isPresent = false
                                    print("도망")
                                    
                                }
                            }
                        }
                        .onAppear{
                            Task{
                                challengeInfo = await firestoreViewModel.fetchChallengeInformation(sendUser.game)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear{
            realtimeViewModel.fetchGameRequest()
        }
    }
}

struct GameRequestAlertView_Previews: PreviewProvider {
    static var previews: some View {
        GameRequestAlertView()
    }
}
