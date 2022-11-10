//
//  String.swift
//  shop
//
//  Created by Ke4a on 06.11.2022.
//

import Foundation

extension String {
    var isLetters: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }

    var isNumbers: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
