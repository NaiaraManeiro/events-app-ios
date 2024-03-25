//
//  HomeView.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 25/3/24.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State private var searchText = ""
    @State private var isSearching = false
    
    @Binding var emailUsuario: String
    
    var body: some View {
        NavigationView {
            /*List(searchResults, id: \.idDrink) { cocktail in
                NavigationLink(destination: CocktailDetailView(cocktail: cocktail)) {
                }
            }*/
        }
    }
}
