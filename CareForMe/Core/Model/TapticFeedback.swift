//
//  TapticFeedback.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/3/21.
//


import AudioToolbox.AudioServices


enum TapticEngine: UInt32 {
    /// Single Weak Boom
    case peek = 1519
    /// Single Strong Boom
    case pop = 1520
    /// Three Sequential Weak Booms
    case cancelled = 1521
    // Single Weak Boom Followed by Single Strong Boom
    case tryAgain = 1102
    // Three Sequential Strong Booms
    case failed = 1107
    // Send haptic feedback signal to user's device
    func tapUser() {
        AudioServicesPlaySystemSound(rawValue)
    }
}
