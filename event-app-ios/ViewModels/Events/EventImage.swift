//
//  Image.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 25/3/24.
//

import Foundation

struct EventImage: Codable {
    let fallback: Bool?
    let height: Int
    let ratio: String
    let url: String
    let width: Int
}
