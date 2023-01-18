//
//  RecordDetailView.swift
//  MSG
//
//  Created by 정소희 on 2023/01/18.
//

import SwiftUI

struct RecordDetailView: View {
    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea()
            VStack{
                Text("치킨내기! 30만원으로 한달 살기")
            }
        }
    }
}

struct RecordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecordDetailView()
    }
}
