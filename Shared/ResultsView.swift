//
//  ResultsView.swift
//  swim-ontario
//
//  Created by Asa Riley on 7/26/21.
//

import SwiftUI

struct ResultsView: View {
    let waterStatuses: [WaterQualityResult]
    
    var body: some View {
        List (waterStatuses) { status in
            ResultRowView(wqr: status)
        }.environment(\.defaultMinListRowHeight, 50)
    }
}
