//
//  ChartCellView.swift
//  MSG
//
//  Created by sehooon on 2023/01/18.
//

import SwiftUI

struct ChartCellView: View {
    var body: some View {
        HStack{
            Image(systemName: "takeoutbag.and.cup.and.straw")
            VStack(spacing:5){
                HStack{
                    Text("야시장 뻥튀기")
                    Spacer()
                    Text("-3500")
                }
                HStack{
                    Text("소비태그: 식사")
                        .font(.subheadline)
                    Spacer()
                    Text("20: 20")
                        .font(.subheadline)
                }
                
            }
            .padding()
        }
        .padding(20)
    }
}

struct ChartCellView_Previews: PreviewProvider {
    static var previews: some View {
        ChartCellView()
    }
}
