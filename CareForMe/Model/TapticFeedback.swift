//
//  TapticFeedback.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/3/21.
//


import AudioToolbox.AudioServices


enum TapticEngine: UInt32 {
    // DOCUMENT THIS
    case peek = 1519
    // DOCUMENT THIS
    case pop = 1520
    // DOCUMENT THIS
    case cancelled = 1521
    // DOCUMENT THIS
    case tryAgain = 1102
    // DOCUMENT THIS
    case failed = 1107
    // DOCUMENT THIS
    func tapUser() {
        AudioServicesPlaySystemSound(rawValue)
    }
}
