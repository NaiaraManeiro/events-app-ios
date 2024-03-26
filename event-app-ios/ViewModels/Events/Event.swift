//
//  Event.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 25/3/24.
//

import Foundation

struct Event: Codable, Identifiable {
    let _embedded: EmbeddedX?
    let id: String
    let images: [EventImage]?
    let name: String?
    let url: String?
    let dates: EventDate
    let priceRanges: [PriceRanges]?
    let place: Place?
}
