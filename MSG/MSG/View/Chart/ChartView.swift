//
//  ChartView.swift
//  MSG
//
//  Created by sehooon on 2023/01/18.
//

import SwiftUI

struct ChartView: View {
    @State private var progressValue:[Float] = [10000, 50000, 60000, 3500]
    @State private var sobiTag:[String] = ["식사", "교통비", "기타"]
    @State private var selection: String = ""
    var body: some View {
        ZStack{
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            VStack(){
                //원형바
                ProgressBar()
                    .padding(40)
                
                // 태그 별 선택
                HStack{
                    Text("지출 내역")
                        .padding(.leading, 50)
                        .foregroundColor(Color("Font"))
                    Spacer()
                }
                HStack(spacing:30){
                    ForEach(sobiTag, id:\.self){ sobi in
                        Button {
                                selection = sobi
                        } label: {
                            VStack{
                                Image(systemName: "fork.knife")
                                Text("\(sobi)")
                            }
                            .foregroundColor(Color("Font"))
                        }
                        .frame(width: 80,height: 80)
                        .overlay{
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("Point2"), lineWidth: 2)
                        }
                        .background( selection == sobi ? Color("Point2") : Color(.clear))
                        .cornerRadius(20)
                    }
                }
                .padding()
                Spacer()
                
                ScrollView{
                    ForEach(1...5, id:\.self){ _ in
                        ChartCellView()
                    }
                }
            }
        }
    }
}


struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
