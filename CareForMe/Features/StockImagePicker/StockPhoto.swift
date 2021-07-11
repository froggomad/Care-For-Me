//
//  StockPhoto.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 7/10/21.
//

import UIKit

struct StockPhoto: Codable {
    
    private var name: NamedPhoto
    var data: Data = Data()
    
    var image: UIImage? {
        .stockImage(from: name)
    }
    
    var title: String {
        Self.TitleFormatter.formatTitle(title: name.rawValue)
    }
    
    init(name: NamedPhoto) {
        self.name = name
        self.data = image?.pngData() ?? Data()
    }
    
}

extension StockPhoto {
    private struct TitleFormatter {
        static func formatTitle(title: String) -> String {
            var localTitle: String = ""
            
            for char in title {
                let stringChar = String(char)
                switch stringChar {
                
                case stringChar.lowercased():
                    if stringChar == "+" { fallthrough }
                    localTitle += stringChar
                    
                case "+":
                    localTitle += "/"
                case stringChar.uppercased():
                    localTitle += " " + stringChar
                default:
                    break
                }
                
            }
            
            return localTitle.capitalized
        }
    }
}

extension UIImage {
    static func stockImage(from name: NamedPhoto) -> UIImage {
        .init(named: name.rawValue)!
    }
}

enum NamedPhoto: String, Codable, CaseIterable {
    // MARK: - Activities -
    case playAmericanFootball
    case playCards
    case playFootballSoccer = "playFootball+soccer"
    case playTennis
    case walk
    case watchTV
    // MARK: - Fun -
    case cat
    case chess
    case controller
    case dice
    case kirby
    case sword
    case videoGames
    // MARK: - Medical -
    case ambulance
    case callDoctor
    case chiropractor
    case cough
    case dizzy
    case doctorVisit
    case firstAid
    case headache
    case medicalHelicopter
    case medicalVisit
    case pill
    case syringe
    // MARK: - Objects -
    case americanFootball
    case americanFootballGoalpost
    case flower
    case footballSoccerBall = "football+soccerball"
    case footballSoccerGoalPost = "football+soccerGoalpost"
    case tennisCourt
    case tennisRacquet
    
    var photoModel: StockPhoto {
        StockPhoto(name: self)
    }
    
    var title: String {
        photoModel.title
    }
    
    var image: UIImage {
        // TODO: Replace with fallback image
        photoModel.image ?? UIImage()
    }
}
