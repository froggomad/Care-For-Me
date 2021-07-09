//
//  AppSettingsController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/6/21.
//

import UIKit

class AppSettingsController {
    static func openSettings() { UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!) }
}
