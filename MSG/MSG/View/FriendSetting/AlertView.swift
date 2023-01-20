//
//  AlertView.swift
//  MSG
//
//  Created by kimminho on 2023/01/17.
//

import SwiftUI

struct AlertView: View {
    
    @State private var testArray: [String] = ["닉네임여섯글","김기분굿","김뽀삐"]
    @EnvironmentObject var realtimeViewModel: PostitStore
    
    var body: some View {
        
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                if realtimeViewModel.user.isEmpty {
                    Text("알람을 모두 확인했습니다.")
                } else {
                    List(realtimeViewModel.user, id: \.self) { user in
                        HStack {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle().inset(by: 5))
                                .frame(width:90)
                            Text(user.userName)
                                .font(.title3)
                            if user.isFight {
                                Text("님의 대결 신청")
                            }
                            else {
                                Text("님의 친구 신청")
                            }
                            Spacer()
                            Button {
                                //
                            } label: {
                                Text("확인")
                                    .foregroundColor(Color("Background"))
                                
                            }
                            .padding(.all, 9)
                            .background(Color("Point2"))
                            .cornerRadius(10)
                        }
                        .listRowBackground(Color("Background"))
                        .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                }
            }
            .foregroundColor(Color("Font"))
        }
        .onAppear {
            realtimeViewModel.startFetching()
            print(realtimeViewModel.user)
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}
