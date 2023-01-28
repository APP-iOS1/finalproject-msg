//
//  CountDownView.swift
//  MSG
//
//  Created by zooey on 2023/01/26.
//

import SwiftUI

struct CountDownView: View {
    
    @State var timeRemaining = 3024000
    var endDate: Double = 0.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func timeString(time: Int) -> String {
        let days = Int(time) / 86400
        let hours = Int(time) / 3600 % 24
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i일 %02i시간 %02i분 %02i초", days, hours, minutes, seconds)
    }
    
    var body: some View {
        
        VStack {
            Text("\(timeString(time: timeRemaining))")
                .font(.title).bold()
                .foregroundColor(Color("Font"))
        }
        .onReceive(timer){ _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }else{
                self.timer.upstream.connect().cancel()
            }
        }
        .onAppear {
            timeRemaining = Int(endDate + 86400 - Date().timeIntervalSince1970)
        }
    }
}

struct CountDownView_Previews: PreviewProvider {
    static var previews: some View {
        CountDownView()
    }
}
