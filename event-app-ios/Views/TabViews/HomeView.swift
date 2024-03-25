//
//  HomeView.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 25/3/24.
//

import SwiftUI

struct HomeView: View {
    @State private var events: [Event] = []
    @State private var isLoading = false
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State private var searchText = ""
    @State private var isSearching = false
    
    @Binding var emailUsuario: String
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else if events.isEmpty {
                Text("No events available")
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                        ForEach(events) { event in
                            EventView(event: event)
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            fetchEvents()
        }
    }
    
    private func fetchEvents() {
        isLoading = true
        EventAPI.fetchEvents { fetchedEvents in
            DispatchQueue.main.async {
                isLoading = false
                if let fetchedEvents = fetchedEvents {
                    events = fetchedEvents._embedded.events
                }
            }
        }
    }
}

struct EventView: View {
    let event: Event
    
    var body: some View {
        VStack {
            Text(event.name ?? "Unknown")
            // Add more views to display other event details
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(5)
    }
}

/*struct HomeView: View {
    
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
}*/
