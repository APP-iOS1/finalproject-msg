//
//  ChartView.swift
//  MSG
//
//  Created by sehooon on 2023/01/18.
//

import SwiftUI

struct Category: Identifiable, Hashable {
    let id = UUID().uuidString
    let tag: String
    let icon: String
    let color: String
}

var category: [Category] = [
    Category(tag: "식비", icon: "fork.knife", color: "Chart1"),
    Category(tag: "교통비", icon: "bus", color: "Chart2"),
    Category(tag: "쇼핑", icon: "cart", color: "Chart3"),
    Category(tag: "의료", icon: "cross", color: "Chart4"),
    Category(tag: "주거", icon: "house", color: "Chart5"),
    Category(tag: "여가", icon: "figure.socialdance", color: "Chart6"),
    Category(tag: "금융", icon: "wonsign", color: "Chart7"),
    Category(tag: "기타", icon: "ellipsis.curlybraces", color: "Chart8")
]

struct ChartView: View {
    
    @State private var progressValue: [Float] = [10000, 50000, 60000, 3500]
    @State private var consumeTags: [String] = ["식비", "교통비", "쇼핑", "의료", "주거", "여가", "금융", "기타"]
    @State private var selection: String = ""
    
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    
    private func totalMoney(title: String, money: String, date: Date) -> String {
        return title + "_" + money + "_" + date.toString()
    }
    
    var body: some View {
        ZStack{
            Color("Background")
                .ignoresSafeArea()
            
            VStack{
                //원형바
                ProgressBar()
                    .padding(40)
                
                // 태그 별 선택
                HStack{
                    Text("지출 내역")
                        .padding(.leading)
                    Spacer()
                }
                
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack{
                        ForEach(category, id: \.self){ item in
                            Button {
                                selection = item.tag
                            } label: {
                                HStack{
                                    Image(systemName: item.icon)
                                    Text("\(item.tag)")
                                }
                                .foregroundColor(selection == item.tag ? Color("Background") : Color("Font"))
                            }
                            .frame(width: 85,height: 45)
                            .overlay{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(item.color), lineWidth: 2)
                            }
                            .background(selection == item.tag ? Color(item.color) : Color(.clear))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                Spacer()
                
                ScrollView(.vertical, showsIndicators: false) {
//                    ForEach(1...5, id:\.self){ _ in
                    ChartCellView(selection: $selection)
//                    }
                }
            }
            .foregroundColor(Color("Font"))
        }
    }
}


struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
