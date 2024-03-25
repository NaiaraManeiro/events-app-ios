//
//  UserModel.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 15/3/24.
//

import Foundation
import Combine

class UserModel: ObservableObject {
    @Published var email: String
    @Published var pass: String
    @Published var salt: String
    @Published var username: String
    @Published var name: String
    @Published var phone: String = ""
    @Published var surname: String = ""
    
    init(email: String, pass: String, salt: String, username: String, name: String) {
        self.email = email
        self.pass = pass
        self.salt = salt
        self.username = username
        self.name = name
    }
}
