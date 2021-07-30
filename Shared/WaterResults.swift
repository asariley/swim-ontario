//
//  WaterResults.swift
//  swim-ontario
//
//  Created by Asa Riley on 7/26/21.
//

import Foundation

enum DataStatus {
    case waiting
    case received([WaterQualityResult])
    case errored(Error)
}

enum WaterStatus: String, Decodable {
    case safe = "SAFE"
    case unsafe = "UNSAFE"
    case noData = "NO_DATA"
}

struct WaterQualityResult: Identifiable {
    let id = UUID()
    let collectionDate: Date
    let beachId: Int
    let beachName: String
    let eColi: Int?
    let advisory: String
    let statusFlag: WaterStatus
    
    static let testData: [WaterQualityResult] = [
        WaterQualityResult(collectionDate: Date(), beachId: 1, beachName: "Marie Curtis", eColi: 83, advisory: "its cool", statusFlag: .safe),
        WaterQualityResult(collectionDate: Date(timeIntervalSinceNow: -1*60*60*24), beachId: 1, beachName: "Marie Curtis", eColi: 133, advisory: "warning", statusFlag: .unsafe),
        WaterQualityResult(collectionDate: Date(timeIntervalSinceNow: -2*60*60*24), beachId: 1, beachName: "Marie Curtis", eColi: nil, advisory: "dunno", statusFlag: .noData)
    ]
}
