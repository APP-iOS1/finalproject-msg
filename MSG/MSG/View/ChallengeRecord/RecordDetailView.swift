//
//  RecordDetailView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/18.
//

import SwiftUI

struct RecordDetailView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                Color("Background").ignoresSafeArea()
                ScrollView{
                VStack{
                    //타이틀, 날짜 그룹
                    Group{
                        HStack{
                            Text("치킨내기! 30만원으로 한달 살기")
                                .font(.title3.bold())
                                .foregroundColor(Color("Font"))
                            Spacer()
                        }
                        Divider()
                        HStack{
                            Text("2023년01월01일 ~ 2023년01월31일")
                                .padding(.bottom, 20)
                            Spacer()
                        }
                    }.padding(.horizontal)
                     .foregroundColor(Color("Font"))
                    //챌린지 참여인원에 따른 사용금액 그룹
                    Group{
                        ForEach(0..<5, id: \.self) { _ in
                            HStack{
                                Image(systemName: "person")
                                    .font(.largeTitle)
                                    .background(content: {
                                        Color("Point2")
                                    })
                                    .padding(.trailing)
                                Text("총 250,000원 사용")
                                Spacer()
                            }
                        }
                        
                    }.padding([.vertical, .horizontal])
                     .foregroundColor(Color("Font"))
                    //가장적게 쓴, 많이 쓴 사람 그룹
                    Group{
                        HStack{
                            Text("가장 적게 쓴 사람")
                                .padding(.trailing)
                            Image(systemName: "person")
                                .font(.largeTitle)
                                .background(content: {
                                    Color("Point2")
                                })
                        }.padding(.top, 20)
                        HStack{
                            Text("가장 많이 쓴 사람")
                                .padding(.trailing)
                            Image(systemName: "person")
                                .font(.largeTitle)
                                .background(content: {
                                    Color("Point2")
                                })
                        }
                    }
                    .padding([.vertical, .horizontal], 10)
                    .foregroundColor(Color("Font"))
                    
                    }
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ChartView()) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Point2"))
                            .frame(width: 80, height: 45)
                            .overlay {
                                Text("상세내역")
                                    .foregroundColor(Color("Font"))
                                    .font(.subheadline)
                            }
                    }
                }
            }
        }
    }
}

struct RecordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecordDetailView()
    }
}
