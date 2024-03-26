//
//  EventDestailsResponse.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 26/3/24.
//

import Foundation

struct EventDetailsResponse: Codable {
    let _embedded: EmbeddedX?
    let id: String?
    let images: [EventImage]?
    let name: String?
    let url: String?
    let dates: EventDate
    let priceRanges: [PriceRanges]?
    let ageRestrictions: AgeRestrictions?
    let sales: Sales
}
