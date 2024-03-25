//
//  Language.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 15/3/24.
//

import Foundation

enum Language: String {

    case english_us = "en"
    case spanish = "es"
    
    var userSymbol: String {
        switch self {
        case .english_us:
            return "us"
        default:
            return rawValue
        }
    }
}
