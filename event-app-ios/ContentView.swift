//
//  ContentView.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 14/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("RememberMe") var rememberMe: Bool = false
    @AppStorage("RememberUserEmail") var rememberUserEmail: String = ""
    
    var body: some View {
        Group {
            if rememberMe {
                TabViewMain(emailUsuario: $rememberUserEmail)
            } else {
                LoginView()
            }
        }
    }
}
