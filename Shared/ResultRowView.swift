//
//  ResultRowView.swift
//  swim-ontario
//
//  Created by Asa Riley on 7/26/21.
//

import SwiftUI

struct ResultRowView: View {
    let wqr: WaterQualityResult
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            HStack {
                Text("\(wqr.collectionDate.shortDateStr()) - \(wqr.beachName)")
                
            
                Spacer()
            
                switch (wqr.statusFlag) {
                case .safe, .unsafe:
                    Text(wqr.statusFlag.rawValue)
                default:
                    Text("")
                }
                
                Text(wqr.eColi.map { ec in String(ec) } ?? "No reading")
            }
            Text(wqr.advisory).font(.system(size:10)).offset(x: 20)
        }
    }
}

struct ResultRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach (WaterQualityResult.testData) { wqr in
                ResultRowView(wqr: wqr)
            }
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
