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
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView()
                } else if events.isEmpty {
                    Text("noEvents".localized(language))
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 1)) {
                            ForEach(events) { event in
                                NavigationLink {
                                    EventDetailsView(id: event.id)
                                } label : {
                                    EventView(event: event)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "searchBar".localized(language))
            .padding()
            .onChange(of: searchText) { newValue in
                fetchEvents(key: "keyword", data: newValue)
            }
            .onAppear {
                fetchEvents()
            }
        }
    }
    
    private func fetchEvents(key: String? = nil , data: String? = nil) {
        isLoading = true
        
        var parameters: [String: String]? = nil
            
        if let key = key, let data = data {
            parameters = [key: data]
        }
        
        EventAPI.fetchEvents(withParameters: parameters) { fetchedEvents in
            DispatchQueue.main.async {
                isLoading = false
                if let fetchedEvents = fetchedEvents {
                    events = fetchedEvents._embedded.events
                }
            }
        }
    }
}
