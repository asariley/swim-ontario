//
//  ContentView.swift
//  Shared
//
//  Created by Asa Riley on 7/26/21.
//

import SwiftUI

#if os(macOS)
let statusBarOffset: CGFloat = 14.0
#else
let statusBarOffset: CGFloat = 5.0
#endif

struct ContentView: View {
    @State var dataStatus: DataStatus = .waiting
    
    var body: some View {
        
        VStack (alignment: .center, spacing: 4) {
            HStack {
                Spacer()
                Text("Toronto Beach Samples")
                    .foregroundColor(.white)
                    .frame(height:60)
                    .offset(y:statusBarOffset)
                Spacer()
            }.background(Color.blue)
            
            switch dataStatus {
            case .waiting:
                Spacer()
                Text("Waiting")
                    .padding()
                    .onAppear(perform:loadData)
                Spacer()
            case .received(let waterStatuses):
                ResultsView(waterStatuses: waterStatuses)
            case .errored(let err):
                Text((err as NSError).description)
                    .padding()
                
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    
    func loadData() {
        let startDate = Date(timeIntervalSinceNow: -14*60*60*24) //show the previous 14 days
        let endDate = Date()
        
        fetchWaterResults(startDate: startDate, endDate: endDate, onComplete: { wqrs in dataStatus = .received(wqrs) }, onError: { err in dataStatus = .errored(err) })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(dataStatus: .received(WaterQualityResult.testData))
            ContentView(dataStatus: .received(WaterQualityResult.testData))
        }
    }
}
