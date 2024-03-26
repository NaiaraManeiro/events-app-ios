//
//  TabViewMain.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 15/3/24.
//

import SwiftUI

struct TabViewMain: View {
    
    @Binding var emailUsuario: String
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
        
    @State private var selection = 1

    var body: some View {
        TabView(selection: $selection){
            HomeView(emailUsuario: $emailUsuario).tabItem{
                Label("HomeTab".localized(language), systemImage: "list.bullet")
            }.tag(0)
        }.navigationBarBackButtonHidden(true)
        .accentColor(AppColors.primaryColor)
    }
}
