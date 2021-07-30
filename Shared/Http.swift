//
//  Http.swift
//  swim-ontario
//
//  Created by Asa Riley on 7/27/21.
//

import Foundation

struct WaterQualityCollectionJSON: Decodable {
    let CollectionDate: String
    let data: [WaterQualityResultJSON]
}

struct WaterQualityResultJSON: Decodable {
    let beachId: Int
    let beachName: String
    let eColi: Int?
    let advisory: String
    let statusFlag: WaterStatus
}

func fetchWaterResults(startDate: Date, endDate: Date, onComplete: @escaping ([WaterQualityResult]) -> Void, onError: @escaping (Error) -> Void) {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd"
    
    let startDateStr = dateFormat.string(from: startDate)
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let endDateStr = dateFormat.string(from: endDate)
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let url = URL(string: "https://secure.toronto.ca/opendata/adv/beach_results/v1?format=json&startDate=\(startDateStr)&endDate=\(endDateStr)&beachId=1")!

    
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        
        if let err = error {
            onError(err)
            return
        }

        if let resp = response as? HTTPURLResponse {
            if (resp.statusCode < 200 || resp.statusCode > 299) {
                onError(NSError(domain: "HttpStatusError", code: resp.statusCode, userInfo: nil))
                return
            }
        }
        
        if let rawData = data {
            do {
                let results = try JSONDecoder().decode([WaterQualityCollectionJSON].self, from: rawData)
                func flattenToWqr (jsonIn: WaterQualityCollectionJSON) throws -> [WaterQualityResult] {
                    try jsonIn.data.map { (resultJson: WaterQualityResultJSON) throws -> WaterQualityResult in
                        if let collectionDate = dateFormat.date(from: jsonIn.CollectionDate) {
                            return WaterQualityResult(collectionDate: collectionDate, beachId: resultJson.beachId, beachName: resultJson.beachName, eColi: resultJson.eColi, advisory: resultJson.advisory, statusFlag: resultJson.statusFlag)
                        } else {
                            throw NSError(domain: "JsonBadDate", code: 0, userInfo: ["got": jsonIn.CollectionDate, "expected": "yyy-MM-dd"])
                        }
                    }
                }
                let wqrs = try results.flatMap(flattenToWqr)
                onComplete(wqrs)
            } catch {
                onError(error)
            }
        }
    }

    task.resume()
}

