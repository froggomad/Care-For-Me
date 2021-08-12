//
//  Int+randomString.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 8/7/21.
//

import Foundation

extension Int {
    static func randomString(numDigits: Int = 6) -> String {
        return (1...numDigits).map { _ in
            let randNum = Self.random(in: 0...9)
            return String(randNum)
        }.joined()
    }
}
