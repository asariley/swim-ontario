//
//  Extensions.swift
//  swim-ontario
//
//  Created by Asa Riley on 7/26/21.
//

import Foundation

extension Date {
    func shortDateStr() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
}
