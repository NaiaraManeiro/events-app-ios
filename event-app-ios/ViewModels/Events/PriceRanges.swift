//
//  PriceRanges.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 25/3/24.
//

import Foundation

struct PriceRanges: Codable {
    let min: Double?
    let max: Double?
    let currency: String
}
