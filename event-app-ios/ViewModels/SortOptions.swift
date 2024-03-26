//
//  SortOptions.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 26/3/24.
//

import Foundation

enum SortOption: String, CaseIterable, Identifiable {
    case dateAsc = "Date ASC"
    case dateDesc = "Date DESC"
    case nameAsc = "Name ASC"
    case nameDesc = "Name DESC"
    case random = "Random"
        
    var id: String { self.rawValue }
}
