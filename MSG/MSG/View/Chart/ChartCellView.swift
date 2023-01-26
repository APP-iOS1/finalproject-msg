//
//  ChartCellView.swift
//  MSG
//
//  Created by sehooon on 2023/01/18.
//

import SwiftUI

struct ChartCellView: View {
    
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @Binding var selection: String
    
    var body: some View {
        ForEach(Array((fireStoreViewModel.expenditure?.expenditureHistory.keys.enumerated())!), id: \.element) { index, key in
            ForEach((fireStoreViewModel.expenditure?.expenditureHistory[key])!, id: \.self) { value in
                let consume = value.components(separatedBy: "_")
                let date = consume[2].components(separatedBy: " ")
                let time = date[1].components(separatedBy: ":")
                if selection == key {
                    HStack{
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color("Point1"))
                            .frame(width: 12, height: 12)
                        
                        VStack(spacing: 5){
                            HStack {
                                Text("\(date[0])")
                                Spacer()
                            }
                            HStack{
                                Text("\(consume[0])")
                                Spacer()
                                Text("- \(consume[1])")
                            }
                            .bold()
                            
                            HStack{
                                Text("소비태그: \(key)")
                                    .font(.subheadline)
                                Spacer()
                                Text("\(time[0]):\(time[1])")
                                    .font(.subheadline)
                            }
                        }
                        .padding()
                    }
                    .padding([.leading, .trailing], 20)
                }
            }
        }
        .onAppear {
            Task {
                await fireStoreViewModel.fetchExpenditure()
            }
        }
    }
}

struct ChartCellView_Previews: PreviewProvider {
    static var previews: some View {
        ChartCellView(selection: .constant(""))
    }
}
