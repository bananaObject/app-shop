//
//  Int.swift
//  shop
//
//  Created by Ke4a on 23.11.2022.
//
import Foundation

extension Int {
    /// Format string number into thousands
    /// - Returns: String separator thousands.
    func formatThousandSeparator() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = " "
        return numberFormatter.string(from: self as NSNumber)
    }
}
